import 'package:adcc/core/constants/api_endpoints.dart';
import 'package:adcc/core/services/api_client.dart';
import 'package:adcc/core/utils/response_parser.dart';
import 'package:adcc/features/community_posts/models/community_post_model.dart';

class CommunityPostsRepository {
  final ApiClient _apiClient;

  CommunityPostsRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient.instance;

  Future<List<CommunityPostModel>> fetchPosts({required String communityId}) async {
    try {
      final response = await _apiClient.get<dynamic>(
        ApiEndpoints.communityPosts(communityId),
      );

      final list = ResponseParser.extractList(
        response.data,
        const ['posts', 'items', 'results', 'data'],
      );

      return list
          .whereType<Map<String, dynamic>>()
          .map(CommunityPostModel.fromJson)
          .toList();
    } catch (_) {
      return const [];
    }
  }

  Future<CommunityPostModel?> fetchPostById({
    required String communityId,
    required String postId,
  }) async {
    try {
      final response = await _apiClient.get<dynamic>(
        ApiEndpoints.communityPostById(communityId, postId),
      );

      final map = ResponseParser.extractMap(
        response.data,
        const ['post', 'item', 'data'],
      );

      if (map == null) return null;
      return CommunityPostModel.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  Future<bool> createPost({
    required String communityId,
    required Map<String, dynamic> payload,
  }) async {
    try {
      final response = await _apiClient.post<dynamic>(
        ApiEndpoints.communityPosts(communityId),
        data: payload,
      );
      return response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300;
    } catch (_) {
      return false;
    }
  }

  Future<bool> updatePost({
    required String communityId,
    required String postId,
    required Map<String, dynamic> payload,
  }) async {
    try {
      final response = await _apiClient.patch<dynamic>(
        ApiEndpoints.communityPostById(communityId, postId),
        data: payload,
      );
      return response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300;
    } catch (_) {
      return false;
    }
  }

  Future<bool> deletePost({
    required String communityId,
    required String postId,
  }) async {
    try {
      final response = await _apiClient.delete<dynamic>(
        ApiEndpoints.communityPostById(communityId, postId),
      );
      return response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300;
    } catch (_) {
      return false;
    }
  }
}
