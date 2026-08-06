import 'package:adcc/core/constants/api_endpoints.dart';
import 'package:adcc/core/services/api_client.dart';
import 'package:flutter/foundation.dart';
import 'package:adcc/features/communities/models/community_model.dart';

class CommunitiesRepository {
  final ApiClient _apiClient;

  CommunitiesRepository({required ApiClient apiClient})
      : _apiClient = apiClient;

  /// Fetch all communities joined by the current user
  /// Returns a list of CommunityModel objects
  /// Throws an exception if the API call fails
  Future<List<CommunityModel>> getMyJoinedCommunities() async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.authMeJoinedCommunities,
      );

      // Log response for debugging joined communities display issues
      if (kDebugMode) {
        debugPrint('[API][joined-communities] status: ${response.statusCode}');
        debugPrint('[API][joined-communities] body: ${response.data}');
      }

      // Extract the actual response data from the Response object
      final responseData = response.data;

      // Extract the communities list from the response in a robust way.
      List<dynamic> communitiesData = _extractListFromResponse(responseData);

      return communitiesData.where((e) => e is Map<String, dynamic>).map((raw) {
        final map = raw as Map<String, dynamic>;
        // Some API responses wrap the community under `community` or `communityId`
        final candidate = map['community'] ?? map['communityId'] ?? map;
        if (candidate is Map<String, dynamic>) {
          return CommunityModel.fromJson(candidate);
        }
        // Fallback: try to parse the map itself
        return CommunityModel.fromJson(map);
      }).toList();
    } catch (e) {
      rethrow;
    }
  }

  List<dynamic> _extractListFromResponse(dynamic payload) {
    if (payload == null) return [];

    if (payload is List) return payload;

    if (payload is Map<String, dynamic>) {
      // Common shapes: { data: [...] }, { data: { communities: [...] } }, { communities: [...] }
      if (payload['communities'] is List)
        return payload['communities'] as List<dynamic>;

      final data = payload['data'];
      if (data is List) return data;
      if (data is Map<String, dynamic>) {
        if (data['communities'] is List)
          return data['communities'] as List<dynamic>;
        // If data directly contains list-like keys, try to find first list value
        for (final v in data.values) {
          if (v is List) return v;
        }
      }

      // As a fallback, search top-level values for the first List
      for (final v in payload.values) {
        if (v is List) return v;
      }
    }

    return [];
  }

  /// Join a community by ID
  /// Returns the updated CommunityModel
  Future<CommunityModel> joinCommunity(String communityId) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.joinCommunity(communityId),
      );

      // Handle the response and convert to CommunityModel
      final responseData = response.data;
      final communityData = responseData is Map<String, dynamic>
          ? responseData
          : (responseData is Map
              ? Map<String, dynamic>.from(responseData)
              : responseData['data']);
      return CommunityModel.fromJson(communityData);
    } catch (e) {
      rethrow;
    }
  }

  /// Leave a community by ID
  /// Returns a success message or updated community data
  Future<void> leaveCommunity(String communityId) async {
    try {
      await _apiClient.post(
        ApiEndpoints.leaveCommunity(communityId),
      );
    } catch (e) {
      rethrow;
    }
  }
}
