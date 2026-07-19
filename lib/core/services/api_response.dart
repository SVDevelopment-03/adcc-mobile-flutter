/// Generic API response wrapper
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final int? statusCode;
  final Map<String, dynamic>? errors;

  ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.statusCode,
    this.errors,
  });

  /// Create success response
  factory ApiResponse.success({
    T? data,
    String? message,
    int? statusCode,
  }) {
    return ApiResponse<T>(
      success: true,
      data: data,
      message: message,
      statusCode: statusCode,
    );
  }

  /// Create error response
  factory ApiResponse.error({
    String? message,
    int? statusCode,
    Map<String, dynamic>? errors,
  }) {
    return ApiResponse<T>(
      success: false,
      message: message,
      statusCode: statusCode,
      errors: errors,
    );
  }

  /// Parse from Dio response
  factory ApiResponse.fromResponse(dynamic response) {
    if (response is Map<String, dynamic>) {
      // Adjust these keys based on your API response structure
      final success = response['success'] as bool? ??
          response['status'] == 'success' ||
              response['statusCode'] != null &&
                  (response['statusCode'] as int) >= 200 &&
                  (response['statusCode'] as int) < 300;

      return ApiResponse<T>(
        success: success,
        data: response['data'] as T?,
        message: response['message'] as String?,
        statusCode: response['statusCode'] as int?,
        errors: response['errors'] as Map<String, dynamic>?,
      );
    }

    // If response is not a map, treat it as data
    return ApiResponse<T>(
      success: true,
      data: response as T?,
    );
  }
}
