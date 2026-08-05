import 'dart:io';

import 'package:adcc/core/constants/api_endpoints.dart';
import 'package:adcc/core/services/api_client.dart';
import 'package:adcc/core/services/token_storage_service.dart';
import 'package:adcc/core/utils/response_parser.dart';
import 'package:adcc/features/feed_posts/models/feed_post_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class FeedPostsRepository {
  final ApiClient _apiClient;

  FeedPostsRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient.instance;

  Future<List<FeedPostModel>> fetchPosts(
      {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _apiClient.get<dynamic>(
        ApiEndpoints.feed,
        queryParameters: queryParameters,
      );

      // Debug: log raw response payload to help diagnose empty lists
      try {
        // ignore: avoid_print
        debugPrint('[FeedPosts] raw response: ${response.data}');
      } catch (_) {}

      final list = ResponseParser.extractList(
        response.data,
        const ['posts', 'items', 'results', 'data'],
      );
      final authorFallback = await _currentUserAuthorFallback();

      return list
          .whereType<Map<String, dynamic>>()
          .map(
            (json) => FeedPostModel.fromJson(
              json,
              currentUserId: authorFallback.id,
              currentUserName: authorFallback.name,
            ),
          )
          .toList();
    } catch (_) {
      return const [];
    }
  }

  Future<FeedPostModel?> fetchPostById(String id) async {
    try {
      final response =
          await _apiClient.get<dynamic>(ApiEndpoints.feedById(id));

      final map = ResponseParser.extractMap(
        response.data,
        const ['post', 'item', 'data'],
      );

      if (map == null) return null;
      final authorFallback = await _currentUserAuthorFallback();
      return FeedPostModel.fromJson(
        map,
        currentUserId: authorFallback.id,
        currentUserName: authorFallback.name,
      );
    } catch (_) {
      return null;
    }
  }

  Future<List<FeedPostModel>> fetchMyPosts() async {
    try {
      final response = await _apiClient.get<dynamic>(
        ApiEndpoints.feedMyPosts,
      );

      final list = ResponseParser.extractList(
        response.data,
        const ['posts', 'items', 'results', 'data'],
      );
      final authorFallback = await _currentUserAuthorFallback();

      return list
          .whereType<Map<String, dynamic>>()
          .map(
            (json) => FeedPostModel.fromJson(
              json,
              currentUserId: authorFallback.id,
              currentUserName: authorFallback.name,
              preferCurrentUserWhenAuthorMissing: true,
            ),
          )
          .toList();
    } catch (_) {
      return const [];
    }
  }

  Future<bool> createPost({
    required String description,
    String? title,
    File? image,
    String? eventId,
    String? eventTitle,
    String? trackId,
    String? trackTitle,
    String? location,
  }) async {
    try {
      final payload = <String, dynamic>{
        'title':
            (title?.trim().isNotEmpty ?? false) ? title!.trim() : 'Ride update',
        'description': description.trim(),
        'status': 'pending_approval',
      };

      if (eventId != null) payload['eventId'] = eventId;
      if (eventTitle != null) payload['eventTitle'] = eventTitle;
      if (trackId != null) payload['trackId'] = trackId;
      if (trackTitle != null) payload['trackTitle'] = trackTitle;
      if (location != null) payload['location'] = location;

      dynamic data = payload;
      Options? options;

      if (image != null) {
        data = FormData.fromMap({
          ...payload,
          'image': await MultipartFile.fromFile(image.path),
        });
        options = Options(contentType: 'multipart/form-data');
      }

      final response = await _apiClient.post<dynamic>(
        ApiEndpoints.feed,
        data: data,
        options: options,
      );
      return response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300;
    } catch (_) {
      return false;
    }
  }

  Future<bool> updatePost({
    required String id,
    String? title,
    required String description,
    File? image,
    String? eventId,
    String? eventTitle,
    String? trackId,
    String? trackTitle,
    String? location,
  }) async {
    try {
      final payload = <String, dynamic>{
        'description': description.trim(),
      };

      if (title?.trim().isNotEmpty ?? false) payload['title'] = title!.trim();
      if (eventId != null) payload['eventId'] = eventId;
      if (eventTitle != null) payload['eventTitle'] = eventTitle;
      if (trackId != null) payload['trackId'] = trackId;
      if (trackTitle != null) payload['trackTitle'] = trackTitle;
      if (location != null) payload['location'] = location;

      dynamic data = payload;
      Options? options;

      if (image != null) {
        data = FormData.fromMap({
          ...payload,
          'image': await MultipartFile.fromFile(image.path),
        });
        options = Options(contentType: 'multipart/form-data');
      }

      final response = await _apiClient.put<dynamic>(
        ApiEndpoints.feedById(id),
        data: data,
        options: options,
      );
      return response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300;
    } catch (_) {
      return false;
    }
  }

  Future<FeedPostModel?> toggleLike(String id) async {
    try {
      final response =
          await _apiClient.post<dynamic>(ApiEndpoints.feedLike(id));
      final map = ResponseParser.extractMap(
        response.data,
        const ['post', 'item', 'data'],
      );

      if (map == null) return null;
      final authorFallback = await _currentUserAuthorFallback();
      return FeedPostModel.fromJson(
        map,
        currentUserId: authorFallback.id,
        currentUserName: authorFallback.name,
      );
    } catch (_) {
      return null;
    }
  }

  Future<FeedPostModel?> addComment({
    required String postId,
    required String text,
  }) async {
    try {
      final response = await _apiClient.post<dynamic>(
        ApiEndpoints.feedComments(postId),
        data: {'text': text.trim()},
      );
      final map = ResponseParser.extractMap(
        response.data,
        const ['post', 'item', 'data'],
      );

      if (map == null) return null;
      final authorFallback = await _currentUserAuthorFallback();
      return FeedPostModel.fromJson(
        map,
        currentUserId: authorFallback.id,
        currentUserName: authorFallback.name,
      );
    } catch (_) {
      return null;
    }
  }

  Future<FeedPostModel?> deleteComment({
    required String postId,
    required String commentId,
  }) async {
    try {
      final response = await _apiClient.delete<dynamic>(
        ApiEndpoints.feedCommentById(postId, commentId),
      );
      final map = ResponseParser.extractMap(
        response.data,
        const ['post', 'item', 'data'],
      );

      if (map == null) return null;
      final authorFallback = await _currentUserAuthorFallback();
      return FeedPostModel.fromJson(
        map,
        currentUserId: authorFallback.id,
        currentUserName: authorFallback.name,
      );
    } catch (_) {
      return null;
    }
  }

  Future<_FeedAuthorFallback> _currentUserAuthorFallback() async {
    var id = (await TokenStorageService.getUserId())?.trim() ?? '';
    var name = (await TokenStorageService.getUserName())?.trim() ?? '';

    if (id.isNotEmpty && name.isNotEmpty) {
      return _FeedAuthorFallback(id: id, name: name);
    }

    final isGuest = await TokenStorageService.isGuestUser();
    final token = await TokenStorageService.getAccessToken();
    if (isGuest || token == null || token.isEmpty) {
      return _FeedAuthorFallback(id: id, name: name);
    }

    try {
      final response = await _apiClient.get<dynamic>(ApiEndpoints.authMe);
      final user = ResponseParser.extractMap(
        response.data,
        const ['user', 'profile', 'data'],
      );

      if (user != null) {
        final fetchedId = ResponseParser.asString(
          user['_id'] ?? user['id'] ?? user['userId'],
        );
        final fetchedName = ResponseParser.asString(
          user['fullName'] ??
              user['name'] ??
              user['userName'] ??
              user['username'] ??
              user['displayName'],
        );

        if (fetchedId.isNotEmpty) {
          id = fetchedId;
          await TokenStorageService.saveUserId(fetchedId);
        }
        if (fetchedName.isNotEmpty) {
          name = fetchedName;
          await TokenStorageService.saveUserName(fetchedName);
        }
      }
    } catch (_) {}

    return _FeedAuthorFallback(id: id, name: name);
  }
}

class _FeedAuthorFallback {
  final String id;
  final String name;

  const _FeedAuthorFallback({
    required this.id,
    required this.name,
  });
}
