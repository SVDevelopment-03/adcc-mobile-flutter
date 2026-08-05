import 'package:adcc/core/constants/api_endpoints.dart';
import 'package:adcc/core/services/api_client.dart';
import 'package:adcc/core/utils/response_parser.dart';
import 'package:adcc/features/challenges/models/challenge_model.dart';

class ChallengesRepository {
  final ApiClient _apiClient;

  ChallengesRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient.instance;

  Future<List<ChallengeModel>> fetchChallenges(
      {String? status, int page = 1, int limit = 30}) async {
    try {
      final queryParameters = <String, dynamic>{
        'page': page,
        'limit': limit,
      };

      if (status != null && status.isNotEmpty) {
        queryParameters['status'] = status;
      }

      final response = await _apiClient.get<dynamic>(
        ApiEndpoints.challenges,
        queryParameters: queryParameters,
      );

      final list = ResponseParser.extractList(
        response.data,
        const ['challenges', 'items', 'results'],
      );

      return list
          .whereType<Map<String, dynamic>>()
          .map(ChallengeModel.fromJson)
          .toList();
    } catch (_) {
      return const [];
    }
  }

  Future<ChallengeModel?> fetchChallengeById(String id) async {
    try {
      final response =
          await _apiClient.get<dynamic>(ApiEndpoints.challengeById(id));

      final map = ResponseParser.extractMap(
        response.data,
        const ['challenge', 'item', 'data'],
      );

      if (map == null) return null;
      return ChallengeModel.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  Future<List<Map<String, String>>> fetchLeaderboard({int limit = 10}) async {
    try {
      final response = await _apiClient.get<dynamic>(
        ApiEndpoints.challengeLeaderboard,
        queryParameters: {
          'limit': limit,
        },
      );

      final list = ResponseParser.extractList(
        response.data,
        const ['data', 'riders'],
      );

      return list.whereType<Map<String, dynamic>>().map((item) {
        return {
          'name': ResponseParser.asString(item['name'], fallback: 'Rider'),
          'team': ResponseParser.asString(item['team']),
          'time': ResponseParser.asString(item['time'], fallback: '0'),
        };
      }).toList();
    } catch (_) {
      return const [];
    }
  }

  Future<bool> joinChallenge(String id) async {
    try {
      final response = await _apiClient.post<dynamic>(
        ApiEndpoints.joinChallenge(id),
      );

      final map = ResponseParser.extractMap(
        response.data,
        const ['challenge', 'item', 'data'],
      );

      return map != null;
    } catch (_) {
      return false;
    }
  }

  Future<Map<String, dynamic>?> updateChallengeProgress(String id,
      {required int progress, int? progressPercent}) async {
    try {
      final response = await _apiClient.patch<dynamic>(
        ApiEndpoints.challengeProgress(id),
        data: {
          'progress': progress,
          if (progressPercent != null) 'progressPercent': progressPercent,
        },
      );

      final data = ResponseParser.extractMap(
        response.data,
        const ['data', 'challenge'],
      );

      if (data != null && data.containsKey('challenge')) {
        final challenge = data['challenge'];
        if (challenge is Map<String, dynamic>) return challenge;
      }

      if (data is Map<String, dynamic>) {
        return data;
      }

      return null;
    } catch (_) {
      return null;
    }
  }

  Future<bool> isChallengeJoined(String id) async {
    try {
      final response = await _apiClient.get<dynamic>(
        ApiEndpoints.challengeMemberStatus(id),
      );

      final map = ResponseParser.extractMap(
        response.data,
        const ['data', 'participationDetails'],
      );

      if (map != null) {
        final status = map['status']?.toString();
        return status == 'joined';
      }

      final data = response.data;
      if (data is Map<String, dynamic>) {
        final status = data['data']?['status']?.toString();
        return status == 'joined';
      }

      return false;
    } catch (_) {
      return false;
    }
  }
}
