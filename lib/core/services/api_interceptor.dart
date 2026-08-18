import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../constants/api_endpoints.dart';
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

  bool _isRefreshing = false;
  final List<Completer<String?>> _refreshQueue = [];

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
      final accessToken = await TokenStorageService.getAccessToken();
      final isRefreshApi = options.path.contains(ApiEndpoints.authRefresh);

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
      final localeCode = await LanguageStorageService.getLocaleCode();
      if (localeCode != null && localeCode.isNotEmpty) {
        options.headers['x-language'] = localeCode;
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

    if (_isRefreshing) {
      final completer = Completer<String?>();
      _refreshQueue.add(completer);

      final newAccessToken = await completer.future;
      if (newAccessToken == null || newAccessToken.isEmpty) {
        return null;
      }

      return _retryWithNewToken(requestOptions, newAccessToken);
    }

    _isRefreshing = true;

    try {
      final newTokens = await _refreshTokens(requestOptions.baseUrl);

      if (newTokens == null || newTokens.accessToken.isEmpty) {
        await TokenStorageService.clearTokens();
        _notifyRefreshQueue(null);
        return null;
      }

      _notifyRefreshQueue(newTokens.accessToken);
      return _retryWithNewToken(requestOptions, newTokens.accessToken);
    } catch (_) {
      await TokenStorageService.clearTokens();
      _notifyRefreshQueue(null);
      return null;
    } finally {
      _isRefreshing = false;
    }
  }

  Future<_RefreshedTokens?> _refreshTokens(String baseUrl) async {
    final refreshToken = await TokenStorageService.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      return null;
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

        if (accessToken != null && accessToken.isNotEmpty) {
          await TokenStorageService.saveAccessToken(accessToken);
        }
        if (newRefreshToken != null && newRefreshToken.isNotEmpty) {
          await TokenStorageService.saveRefreshToken(newRefreshToken);
        }

        if (accessToken != null && accessToken.isNotEmpty) {
          return _RefreshedTokens(
            accessToken: accessToken,
            refreshToken: newRefreshToken,
          );
        }
      }

      return null;
    } catch (_) {
      return null;
    }
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

  void _notifyRefreshQueue(String? token) {
    for (final completer in _refreshQueue) {
      if (!completer.isCompleted) {
        completer.complete(token);
      }
    }
    _refreshQueue.clear();
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

class _RefreshedTokens {
  final String accessToken;
  final String? refreshToken;

  const _RefreshedTokens({
    required this.accessToken,
    this.refreshToken,
  });
}
