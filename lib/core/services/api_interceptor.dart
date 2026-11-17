import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';

import '../constants/api_endpoints.dart';
import '../navigation/app_navigation.dart';
import '../widgets/auth_wrapper.dart';
import 'language_storage_service.dart';
import 'token_storage_service.dart';

class ApiInterceptor extends Interceptor {
  final bool enableLogging;
  final int maxRetries;
  final Duration retryDelay;

  ApiInterceptor({
    this.enableLogging = kDebugMode,
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 1),
  });

  /// The refresh currently in progress, shared by all callers.
  Future<_RefreshResult>? _refreshInFlight;

  String _stringifyBody(dynamic body) {
    if (body == null) return 'null';

    if (body is FormData) {
      return '{fields: ${body.fields}, files: ${body.files.map((file) => file.key).toList()}}';
    }

    if (body is Map || body is List) {
      return body.toString();
    }

    return body.toString();
  }

  void _logRequest(RequestOptions options) {
    if (!enableLogging) return;

    debugPrint('[API] ${options.method} ${options.uri}');
    debugPrint('[API] headers: ${options.headers}');
    debugPrint('[API] body: ${_stringifyBody(options.data)}');
  }

  void _logResponse(Response response) {
    if (!enableLogging) return;

    debugPrint(
        '[API] RESPONSE ${response.statusCode} ${response.requestOptions.uri}');
    debugPrint('[API] response body: ${_stringifyBody(response.data)}');
  }

  void _logError(DioException err) {
    if (!enableLogging) return;

    debugPrint(
        '[API] ERROR ${err.requestOptions.method} ${err.requestOptions.uri}');
    debugPrint('[API] status: ${err.response?.statusCode}');
    debugPrint('[API] error body: ${_stringifyBody(err.response?.data)}');
  }

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      var accessToken = await TokenStorageService.getAccessToken();
      final isRefreshApi = options.path.contains(ApiEndpoints.authRefresh);

      // If we don't have an access token, try to refresh proactively so
      // requests that require Authorization don't immediately fail with
      // "No token provided" (e.g., registration after OTP verification).
      if (!isRefreshApi && (accessToken == null || accessToken.isEmpty)) {
        final result = await _refreshTokensOnce(options.baseUrl);
        if (result.accessToken != null) {
          accessToken = result.accessToken;
        }
      }

      if (!isRefreshApi && accessToken != null && accessToken.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $accessToken';
      }

      // Do not override Content-Type when sending multipart FormData so Dio
      // can set the proper multipart boundary header.
      if (options.data is! FormData) {
        options.headers['Content-Type'] =
            options.headers['Content-Type'] ?? 'application/json';
      } else {
        options.headers.remove('Content-Type');
      }
      options.headers['Accept'] =
          options.headers['Accept'] ?? 'application/json';

      // Tell the backend which language to return for localized content
      // (communities, events, tracks, challenges, badges, lookups, etc.).
      // Allow callers to opt out of automatic language header (set in options.extra)
      final skipLang = options.extra['skip_language_header'] == true;
      if (!skipLang) {
        final localeCode = await LanguageStorageService.getLocaleCode();
        if (localeCode != null && localeCode.isNotEmpty) {
          options.headers['x-language'] = localeCode;
        }
      }

      _logRequest(options);

      handler.next(options);
    } catch (_) {
      handler.next(options);
    }
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    _logResponse(response);
    handler.next(response);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    _logError(err);

    if (err.response?.statusCode == 401) {
      final response = await _handle401(err);
      if (response != null) {
        handler.resolve(response);
        return;
      }
    }

    if (_shouldRetry(err)) {
      final response = await _retryRequest(err.requestOptions);
      if (response != null) {
        handler.resolve(response);
        return;
      }
    }

    handler.next(err);
  }

  Future<Response?> _handle401(DioException err) async {
    final requestOptions = err.requestOptions;

    if (requestOptions.path.contains(ApiEndpoints.authRefresh)) {
      return null;
    }

    if (requestOptions.extra['retriedAfterRefresh'] == true) {
      return null;
    }

    final result = await _refreshTokensOnce(requestOptions.baseUrl);
    final newAccessToken = result.accessToken;
    if (newAccessToken == null) {
      // Tokens are only cleared (signing the user out) inside _refreshTokens,
      // when the server rejects the refresh token itself. Network errors and
      // server outages keep the session so the user stays logged in.
      return null;
    }

    return _retryWithNewToken(requestOptions, newAccessToken);
  }

  /// Runs at most one refresh at a time. Concurrent callers (several requests
  /// failing with 401 together) share the same refresh, so the refresh token
  /// is only sent once and every caller gets the new access token.
  Future<_RefreshResult> _refreshTokensOnce(String baseUrl) {
    final inFlight = _refreshInFlight;
    if (inFlight != null) return inFlight;

    final future = _refreshTokens(baseUrl).whenComplete(() {
      _refreshInFlight = null;
    });
    _refreshInFlight = future;
    return future;
  }

  Future<_RefreshResult> _refreshTokens(String baseUrl) async {
    final refreshToken = await TokenStorageService.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      return const _RefreshResult.failed();
    }

    try {
      final dio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 60),
          receiveTimeout: const Duration(seconds: 60),
          headers: const {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          validateStatus: (status) =>
              status != null && status >= 200 && status < 300,
        ),
      );

      final response = await dio.post(
        ApiEndpoints.authRefresh,
        data: {'refreshToken': refreshToken},
      );

      final payload = response.data;
      final data = payload is Map<String, dynamic> ? payload['data'] : null;
      final tokenMap = data is Map<String, dynamic> ? data : payload;

      if (tokenMap is Map<String, dynamic>) {
        final accessToken = tokenMap['accessToken'] as String?;
        final newRefreshToken = tokenMap['refreshToken'] as String?;

        // Save the rotated refresh token first: it is what keeps the user
        // signed in on the next app start.
        if (newRefreshToken != null && newRefreshToken.isNotEmpty) {
          await TokenStorageService.saveRefreshToken(newRefreshToken);
        }
        if (accessToken != null && accessToken.isNotEmpty) {
          await TokenStorageService.saveAccessToken(accessToken);
          return _RefreshResult.success(accessToken);
        }
      }

      return const _RefreshResult.failed();
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      if (status == 401 || status == 403) {
        // The server rejected the refresh token: the 30-day session has
        // ended, the user logged out elsewhere, or the account was disabled.
        // Only now is the user signed out.
        debugPrint('[Auth] Refresh token rejected ($status); signing out.');
        await TokenStorageService.clearTokens();
        _showSignIn();
        return const _RefreshResult.rejected();
      }
      // No connection, timeout or server error: keep the session and let the
      // next request try again.
      debugPrint('[Auth] Refresh failed (${status ?? e.type}); keeping session.');
      return const _RefreshResult.failed();
    } catch (e) {
      debugPrint('[Auth] Refresh failed ($e); keeping session.');
      return const _RefreshResult.failed();
    }
  }

  /// After the session ends, return to the start of the app. AuthWrapper sees
  /// no tokens and shows the welcome/login screen.
  void _showSignIn() {
    final navigator = appNavigatorKey.currentState;
    if (navigator == null) return;
    navigator.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const AuthWrapper()),
      (route) => false,
    );
  }

  Future<Response?> _retryWithNewToken(
    RequestOptions requestOptions,
    String newAccessToken,
  ) async {
    try {
      requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
      requestOptions.extra['retriedAfterRefresh'] = true;

      final dio = Dio(
        BaseOptions(
          baseUrl: requestOptions.baseUrl,
          connectTimeout: const Duration(seconds: 60),
          receiveTimeout: const Duration(seconds: 60),
          headers: const {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          validateStatus: (status) =>
              status != null && status >= 200 && status < 300,
        ),
      );

      final response = await dio.fetch(requestOptions);
      return response;
    } catch (_) {
      return null;
    }
  }

  Future<Response?> _retryRequest(RequestOptions requestOptions) async {
    int retryCount = 0;

    while (retryCount < maxRetries) {
      try {
        await Future.delayed(retryDelay * (retryCount + 1));

        final dio = Dio(
          BaseOptions(
            baseUrl: requestOptions.baseUrl,
            connectTimeout: const Duration(seconds: 60),
            receiveTimeout: const Duration(seconds: 60),
            headers: const {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            validateStatus: (status) =>
                status != null && status >= 200 && status < 300,
          ),
        );

        final response = await dio.fetch(requestOptions);
        return response;
      } catch (_) {
        retryCount++;
      }
    }

    return null;
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError;
  }
}

/// Outcome of a token refresh. [accessToken] is set only on success.
class _RefreshResult {
  final String? accessToken;

  /// The server rejected the refresh token; the user has been signed out.
  final bool rejected;

  const _RefreshResult.success(String this.accessToken) : rejected = false;
  const _RefreshResult.rejected()
      : accessToken = null,
        rejected = true;

  /// Temporary failure (network/server); the session is kept.
  const _RefreshResult.failed()
      : accessToken = null,
        rejected = false;
}
