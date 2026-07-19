import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;
  final DioExceptionType? type;

  ApiException({
    required this.message,
    this.statusCode,
    this.data,
    this.type,
  });

  /// Create ApiException from DioException
  factory ApiException.fromDioException(DioException dioException) {
    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException(
          message: 'Connection timeout. Please check your internet connection.',
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
          message: 'Request was cancelled',
          type: dioException.type,
        );

      case DioExceptionType.connectionError:
        return ApiException(
          message:
              'No internet connection. Please check your network settings.',
          type: dioException.type,
        );

      case DioExceptionType.badCertificate:
        return ApiException(
          message: 'SSL certificate error. Please try again later.',
          type: dioException.type,
        );

      case DioExceptionType.unknown:
        if (dioException.message?.contains('SocketException') ?? false) {
          return ApiException(
            message:
                'No internet connection. Please check your network settings.',
            type: dioException.type,
          );
        }
        return ApiException(
          message: dioException.message ?? 'An unexpected error occurred',
          statusCode: dioException.response?.statusCode,
          data: dioException.response?.data,
          type: dioException.type,
        );
    }
  }

  /// Handle HTTP status codes
  static String _handleStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request. Please check your input.';
      case 401:
        return 'Unauthorized. Please login again.';
      case 403:
        return 'Forbidden. You don\'t have permission to access this resource.';
      case 404:
        return 'Resource not found.';
      case 409:
        return 'Conflict. The resource already exists.';
      case 422:
        return 'Validation error. Please check your input.';
      case 429:
        return 'Too many requests. Please try again later.';
      case 500:
        return 'Internal server error. Please try again later.';
      case 502:
        return 'Bad gateway. Please try again later.';
      case 503:
        return 'Service unavailable. Please try again later.';
      case 504:
        return 'Gateway timeout. Please try again later.';
      default:
        return 'An error occurred. Status code: $statusCode';
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
