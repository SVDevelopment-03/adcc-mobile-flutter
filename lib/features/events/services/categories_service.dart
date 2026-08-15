import 'package:dio/dio.dart';

import '../../../core/services/api_client.dart';
import '../../../core/services/api_response.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/utils/response_parser.dart';

class CategoriesService {
  final _apiClient = ApiClient.instance;

  /// Fetch available event categories by reading events and extracting
  /// unique `category`/`categories` values. This is a best-effort fallback
  /// when there is no dedicated categories endpoint.
  Future<ApiResponse<List<String>>> getAvailableCategories() async {
    try {
      final response = await _apiClient.get<dynamic>(
        ApiEndpoints.events,
        queryParameters: {'limit': 100, 'page': 1},
      );

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data != null) {
        try {
          final list = ResponseParser.extractList(
            response.data,
            const ['events', 'items', 'results', 'data', 'results'],
          );

          final categories = <String>{};

          for (final item in list) {
            if (item is Map<String, dynamic>) {
              final cat = (item['category'] ?? item['categories'])?.toString();
              if (cat != null && cat.trim().isNotEmpty) {
                categories.add(_normalizeCategory(cat));
              }
            }
          }

          if (categories.isEmpty) {
            return ApiResponse.error(
                message: ApiResponse.localized(
                    (l) => l.no_categories_found, 'No categories found'));
          }

          return ApiResponse.success(data: categories.toList());
        } catch (e) {
          return ApiResponse.error(message: 'Failed to parse categories: $e');
        }
      }

      return ApiResponse.error(
          message: ApiResponse.localized(
              (l) => l.failed_to_fetch_categories, 'Failed to fetch categories'));
    } on DioException catch (e) {
      return ApiResponse.error(
          message: e.message ??
              ApiResponse.localized((l) => l.network_error, 'Network error'));
    } catch (e) {
      return ApiResponse.error(message: 'Unexpected error: $e');
    }
  }

  String _normalizeCategory(String raw) {
    final s = raw.trim();
    // basic normalization: title-case common variants
    if (s.toLowerCase().contains('race')) return 'Race';
    if (s.toLowerCase().contains('community')) return 'Community Ride';
    if (s.toLowerCase().contains('training')) return 'Training & Clinics';
    if (s.toLowerCase().contains('awareness')) return 'Awareness Rides';
    if (s.toLowerCase().contains('family')) return 'Family & Kids';
    if (s.toLowerCase().contains('corporate')) return 'Corporate';
    if (s.toLowerCase().contains('national')) return 'National Events';
    return s;
  }
}
