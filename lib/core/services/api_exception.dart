import 'package:dio/dio.dart';
import 'package:adcc/l10n/app_localizations.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;
  final DioExceptionType? type;

  /// Global localization reference, set once at app startup in main.dart.
  /// Used to localize network error messages in this context-free layer.
  static AppLocalizations? l10n;

  ApiException({
    required this.message,
    this.statusCode,
    this.data,
    this.type,
  });

  /// Localized fallback: returns [resolver] result when localization is
  /// available, otherwise the English [fallback] string.
  static String localized(String Function(AppLocalizations) resolver, String fallback) {
    final l = l10n;
    return l != null ? resolver(l) : fallback;
  }

  /// Create ApiException from DioException
  factory ApiException.fromDioException(DioException dioException) {
    final l = l10n;
    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException(
          message: l != null
              ? l.connection_timeout
              : 'Connection timeout. Please check your internet connection.',
          type: dioException.type,
        );

      case DioExceptionType.badResponse:
        return ApiException(
          message: _handleStatusCode(dioException.response?.statusCode),
          statusCode: dioException.response?.statusCode,
          data: dioException.response?.data,
          type: dioException.type,
        );

      case DioExceptionType.cancel:
        return ApiException(
          message: l != null ? l.request_cancelled : 'Request was cancelled',
          type: dioException.type,
        );

      case DioExceptionType.connectionError:
        return ApiException(
          message: l != null
              ? l.no_internet_connection
              : 'No internet connection. Please check your network settings.',
          type: dioException.type,
        );

      case DioExceptionType.badCertificate:
        return ApiException(
          message: l != null
              ? l.ssl_certificate_error
              : 'SSL certificate error. Please try again later.',
          type: dioException.type,
        );

      case DioExceptionType.unknown:
        if (dioException.message?.contains('SocketException') ?? false) {
          return ApiException(
            message: l != null
                ? l.no_internet_connection
                : 'No internet connection. Please check your network settings.',
            type: dioException.type,
          );
        }
        return ApiException(
          message: dioException.message ??
              (l != null ? l.unexpected_error : 'An unexpected error occurred'),
          statusCode: dioException.response?.statusCode,
          data: dioException.response?.data,
          type: dioException.type,
        );
    }
  }

  /// Handle HTTP status codes
  static String _handleStatusCode(int? statusCode) {
    final l = l10n;
    switch (statusCode) {
      case 400:
        return l != null ? l.bad_request : 'Bad request. Please check your input.';
      case 401:
        return l != null ? l.unauthorized_login_again : 'Unauthorized. Please login again.';
      case 403:
        return l != null ? l.forbidden_no_permission : 'Forbidden. You don\'t have permission to access this resource.';
      case 404:
        return l != null ? l.resource_not_found : 'Resource not found.';
      case 409:
        return l != null ? l.conflict_exists : 'Conflict. The resource already exists.';
      case 422:
        return l != null ? l.validation_error : 'Validation error. Please check your input.';
      case 429:
        return l != null ? l.too_many_requests : 'Too many requests. Please try again later.';
      case 500:
        return l != null ? l.internal_server_error : 'Internal server error. Please try again later.';
      case 502:
        return l != null ? l.bad_gateway : 'Bad gateway. Please try again later.';
      case 503:
        return l != null ? l.service_unavailable : 'Service unavailable. Please try again later.';
      case 504:
        return l != null ? l.gateway_timeout : 'Gateway timeout. Please try again later.';
      default:
        return l != null
            ? l.error_status_code('$statusCode')
            : 'An error occurred. Status code: $statusCode';
    }
  }

  String? getErrorMessage() {
    if (data is Map<String, dynamic>) {
      return data['message'] as String? ??
          data['error'] as String? ??
          data['error_message'] as String?;
    }
    if (data is String) {
      return data;
    }
    return null;
  }

  @override
  String toString() {
    final errorMsg = getErrorMessage();
    return errorMsg ?? message;
  }
}
