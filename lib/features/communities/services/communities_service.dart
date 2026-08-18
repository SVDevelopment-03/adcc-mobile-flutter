import 'package:adcc/core/constants/api_endpoints.dart';
import 'package:adcc/core/services/api_client.dart';
import 'package:adcc/core/services/api_exception.dart';
import 'package:adcc/core/services/api_response.dart';
import 'package:adcc/core/services/language_storage_service.dart';
import 'package:adcc/core/services/lookup_service.dart';
import 'package:adcc/features/communities/models/community_model.dart';
import 'package:dio/dio.dart';

class CommunitiesService {
  final _apiClient = ApiClient.instance;

  List<dynamic> _extractCommunitiesList(dynamic payload) {
    if (payload == null) return [];

    if (payload is List) return payload;

    if (payload is Map<String, dynamic>) {
      if (payload['communities'] is List) {
        return payload['communities'] as List<dynamic>;
      }

      final data = payload['data'];
      if (data is List) return data;

      if (data is Map<String, dynamic>) {
        if (data['communities'] is List) {
          return data['communities'] as List<dynamic>;
        }

        for (final value in data.values) {
          if (value is List) return value;
        }
      }

      for (final value in payload.values) {
        if (value is List) return value;
      }
    }

    return [];
  }

  static const List<String> _allowedCommunityCategories = [
    'City Communities',
    'Group Communities',
    'Racing & Performance',
    'Family & Leisure',
    'Women (SheRides)',
    'Youth',
    'Social / Weekend',
    'Night Riders',
    'MTB / Trail',
    'Training & Clinics',
    'Awareness & Charity',
    'Corporate',
    'Education',
    'Health',
  ];

  List<String> _extractCommunityTypes(dynamic payload) {
    final communities = _extractCommunitiesList(payload);
    final types = <String>{};

    for (final item in communities) {
      if (item is! Map<String, dynamic>) continue;

      final rawType = item['type'];

      if (rawType is List) {
        for (final value in rawType) {
          final type = value?.toString().trim();
          if (type != null && type.isNotEmpty) {
            types.add(type);
          }
        }
        continue;
      }

      final typeValue = rawType?.toString().trim();
      if (typeValue == null || typeValue.isEmpty) continue;

      for (final part in typeValue.split(',')) {
        final type = part.trim();
        if (type.isNotEmpty) {
          types.add(type);
        }
      }
    }

    final list = types.toList();
    list.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return list;
  }

  Future<ApiResponse<dynamic>> getCommunities({
    Map<String, dynamic>? queryParameters,
  }) async {
    const endpoint = ApiEndpoints.communities;

    try {
      final response = await _apiClient.get<dynamic>(
        endpoint,
        queryParameters: queryParameters,
      );

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data != null) {
        return ApiResponse.success(
          data: response.data,
          statusCode: response.statusCode,
        );
      }

      return ApiResponse.error(
        message: response.data?["message"] ??
            ApiResponse.localized((l) => l.failed_to_fetch_communities, 'Failed to fetch communities'),
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      final apiException = ApiException.fromDioException(e);

      return ApiResponse.error(
        message: apiException.toString(),
        statusCode: apiException.statusCode,
      );
    } catch (e) {
      return ApiResponse.error(
        message: ApiResponse.localized((l) => l.unexpected_error, 'An unexpected error occurred'),
      );
    }
  }

  Future<ApiResponse<List<String>>> getCommunityTypes() async {
    try {
      final response = await _apiClient.get<dynamic>(
        ApiEndpoints.communities,
        queryParameters: const {
          'page': 1,
          'limit': 1000,
        },
      );

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data != null) {
        return ApiResponse.success(
          data: _extractCommunityTypes(response.data),
          statusCode: response.statusCode,
        );
      }

      return ApiResponse.error(
        message: response.data?['message'] ??
            ApiResponse.localized((l) => l.failed_to_fetch_community_types, 'Failed to fetch community types'),
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      final apiException = ApiException.fromDioException(e);

      return ApiResponse.error(
        message: apiException.toString(),
        statusCode: apiException.statusCode,
      );
    } catch (e) {
      return ApiResponse.error(
        message: 'An unexpected error occurred',
      );
    }
  }

  Future<ApiResponse<List<String>>> getCommunityCategories() async {
    try {
      // Dashboard-managed bilingual lookup list (`/v1/lookups?type=community_category`).
      final lookups = await LookupService.instance
          .getLookups(ApiEndpoints.lookupTypeCommunityCategory);
      final locale = await LanguageStorageService.getLocaleCode();
      return ApiResponse.success(
        data: lookups.map((item) => item.displayFor(locale)).toList(),
      );
    } on DioException catch (e) {
      final apiException = ApiException.fromDioException(e);
      return ApiResponse.error(
        message: apiException.toString(),
        statusCode: apiException.statusCode,
      );
    } catch (e) {
      // Fall back to deriving categories from community data.
      try {
        final response = await _apiClient.get<dynamic>(
          ApiEndpoints.communities,
          queryParameters: const {'page': 1, 'limit': 1000},
        );
        if (response.data != null) {
          return ApiResponse.success(
            data: _extractCommunityCategories(response.data),
          );
        }
      } catch (_) {}
      return ApiResponse.error(
        message: 'An unexpected error occurred',
      );
    }
  }

  List<String> _extractCommunityCategories(dynamic payload) {
    final communities = _extractCommunitiesList(payload);
    final matchedCategories = <String>{};

    for (final item in communities) {
      if (item is! Map<String, dynamic>) continue;

      final rawCategory = item['category'];
      if (rawCategory is Iterable) {
        for (final category in rawCategory) {
          final normalized = _normalizeCommunityCategory(category?.toString());
          if (normalized != null) matchedCategories.add(normalized);
        }
      } else {
        final normalized = _normalizeCommunityCategory(rawCategory?.toString());
        if (normalized != null) matchedCategories.add(normalized);
      }
    }

    final list = <String>[];
    for (final category in _allowedCommunityCategories) {
      if (matchedCategories.contains(category)) {
        list.add(category);
      }
    }
    return list;
  }

  String? _normalizeCommunityCategory(String? rawCategory) {
    if (rawCategory == null) return null;
    final value = rawCategory.trim().toLowerCase();
    if (value.isEmpty) return null;

    if (value.contains('city communities')) return 'City Communities';
    if (value.contains('group communities')) return 'Group Communities';
    if (value.contains('family') ||
        value.contains('leisure') ||
        value.contains('kids')) {
      return 'Family & Leisure';
    }
    if (value.contains('women') || value.contains('she'))
      return 'Women (SheRides)';
    if (value.contains('youth') || value.contains('cycling')) return 'Youth';
    if (value.contains('social') || value.contains('weekend'))
      return 'Social / Weekend';
    if (value.contains('night')) return 'Night Riders';
    if (value.contains('mtb') || value.contains('trail')) return 'MTB / Trail';
    if (value.contains('training') || value.contains('clinic'))
      return 'Training & Clinics';
    if (value.contains('awareness') ||
        value.contains('special') ||
        value.contains('charity')) {
      return 'Awareness & Charity';
    }
    if (value.contains('corporate')) return 'Corporate';
    if (value.contains('education')) return 'Education';
    if (value.contains('health')) return 'Health';
    if (value.contains('racing') || value.contains('performance'))
      return 'Racing & Performance';

    return null;
  }

  Future<ApiResponse<dynamic>> joinCommunity({
    required String communityId,
  }) async {
    final endpoint = ApiEndpoints.joinCommunity(communityId);

    try {
      final response = await _apiClient.post<dynamic>(
        endpoint,
        data: {},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data != null && response.data["success"] == true) {
          return ApiResponse.success(
            data: response.data,
            statusCode: response.statusCode,
            message: response.data?["message"] ??
                ApiResponse.localized(
                    (l) => l.communityJoinedSuccessfully, "Community joined successfully"),
          );
        }
      }

      return ApiResponse.error(
        message: response.data?["message"] ??
            ApiResponse.localized((l) => l.failed_to_join_community, "Failed to join community"),
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      final apiException = ApiException.fromDioException(e);

      return ApiResponse.error(
        message: apiException.toString(),
        statusCode: apiException.statusCode,
      );
    } catch (e) {
      return ApiResponse.error(
        message: "An unexpected error occurred",
      );
    }
  }

  Future<ApiResponse<bool>> getCommunityMemberStatus({
    required String communityId,
  }) async {
    final endpoint = ApiEndpoints.isMemberOfCommunity(communityId);

    try {
      final response = await _apiClient.post<dynamic>(endpoint);

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data != null &&
          response.data["success"] == true) {
        final joined = response.data["data"]?['isMember'] == true;

        return ApiResponse.success(
          data: joined,
          statusCode: response.statusCode,
        );
      }

      return ApiResponse.error(
        message: response.data?["message"] ??
            ApiResponse.localized(
                (l) => l.failed_to_fetch_member_status, "Failed to fetch member status"),
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      final apiException = ApiException.fromDioException(e);

      return ApiResponse.error(
        message: apiException.toString(),
        statusCode: apiException.statusCode,
      );
    } catch (e) {
      return ApiResponse.error(
        message: "Unexpected error occurred",
      );
    }
  }

  Future<ApiResponse<dynamic>> leaveCommunity({
    required String communityId,
    String? reason,
    String? feedback,
  }) async {
    final endpoint = ApiEndpoints.leaveCommunity(communityId);

    try {
      final requestData = {
        if (reason != null) "reason": reason,
        if (feedback != null) "feedback": feedback,
      };

      final response = await _apiClient.post<dynamic>(
        endpoint,
        data: requestData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data != null && response.data["success"] == true) {
          return ApiResponse.success(
            data: response.data,
            statusCode: response.statusCode,
            message: response.data?["message"] ??
                ApiResponse.localized(
                    (l) => l.community_left_successfully, "Community left successfully"),
          );
        }
      }

      return ApiResponse.error(
        message: response.data?["message"] ??
            ApiResponse.localized(
                (l) => l.failed_to_leave_community, "Failed to leave community"),
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      final apiException = ApiException.fromDioException(e);

      return ApiResponse.error(
        message: apiException.toString(),
        statusCode: apiException.statusCode,
      );
    } catch (e) {
      return ApiResponse.error(
        message: "An unexpected error occurred",
      );
    }
  }

  // Future<ApiResponse<dynamic>> getCityCommunities() {
  //   return getCommunities(
  //     queryParameters: {"category": "City Communities"},
  //   );
  // }

  // Future<ApiResponse<dynamic>> getGroupCommunities() {
  //   return getCommunities(
  //     queryParameters: {"category": "Group Communities"},
  //   );
  // }

  // Future<ApiResponse<dynamic>> getAwarenessCommunities() {
  //   return getCommunities(
  //     queryParameters: {"category": "Awareness & Special Communities"},
  //   );
  // }

  // Future<ApiResponse<dynamic>> getCommunitiesByType(String type) {
  //   return getCommunities(
  //     queryParameters: {"type": type},
  //   );
  // }

  Future<ApiResponse<dynamic>> getCommunitiesByCategory(String category) {
    return getCommunities(
      queryParameters: {"category": category},
    );
  }

  Future<ApiResponse<dynamic>> getCommunitiesByLocation(String location) {
    return getCommunities(
      queryParameters: {"location": location},
    );
  }

  Future<ApiResponse<CommunityModel>> getCommunityById({
    required String communityId,
  }) async {
    final endpoint = ApiEndpoints.communityById(communityId);

    try {
      final response = await _apiClient.get<dynamic>(endpoint);

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data != null &&
          response.data["success"] == true) {
        final community = CommunityModel.fromJson(response.data["data"]);

        return ApiResponse.success(
          data: community,
          statusCode: response.statusCode,
        );
      }

      return ApiResponse.error(
        message: response.data?["message"] ??
            ApiResponse.localized(
                (l) => l.failed_to_fetch_community, "Failed to fetch community"),
        statusCode: response.statusCode,
      );
    } catch (e) {
      return ApiResponse.error(
        message: "Unexpected error occurred",
      );
    }
  }
}
