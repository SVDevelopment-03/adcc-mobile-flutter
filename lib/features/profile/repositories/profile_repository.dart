import 'package:adcc/core/constants/api_endpoints.dart';
import 'package:adcc/core/services/api_client.dart';
import 'package:adcc/core/utils/response_parser.dart';
import 'package:adcc/features/profile/models/profile_history_models.dart';
import 'package:adcc/features/profile/models/profile_model.dart';

class ProfileRepository {
  final ApiClient _apiClient;

  ProfileRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient.instance;

  Future<ProfileModel?> fetchProfile() async {
    try {
      // Fetch profile and stats in parallel to keep Profile top section fast.
      final meFuture = _apiClient.get<dynamic>(ApiEndpoints.authMe);
      final statsFuture = () async {
        try {
          return await _apiClient.get<dynamic>(ApiEndpoints.authMeStats);
        } catch (_) {
          return null;
        }
      }();

      final meResponse = await meFuture;
      final statsResponse = await statsFuture;

      final userMap = ResponseParser.extractMap(
        meResponse.data,
        const ['user', 'profile', 'data'],
      );
      final statsMap = ResponseParser.extractMap(
        statsResponse?.data,
        const ['stats', 'data'],
      );

      if (userMap == null) return null;

      return ProfileModel.fromApi(
        user: userMap,
        stats: statsMap ?? const {},
      );
    } catch (_) {
      return null;
    }
  }

  Future<ProfilePerformanceInsights> fetchPerformanceInsights() async {
    try {
      final response = await _apiClient.get<dynamic>(
        ApiEndpoints.authMePerformanceInsights,
      );

      final map = ResponseParser.extractMap(
        response.data,
        const ['insights', 'data'],
      );

      if (map == null) return ProfilePerformanceInsights.fallback;
      return ProfilePerformanceInsights.fromApi(map);
    } catch (_) {
      return ProfilePerformanceInsights.fallback;
    }
  }

  Future<List<ProfileEventHistoryItem>> fetchCompletedEvents() async {
    try {
      final response = await _apiClient.get<dynamic>(
        ApiEndpoints.authMeCompletedEvents,
        queryParameters: const {'page': 1, 'limit': 10},
      );

      final root = ResponseParser.extractMap(
        response.data,
        const ['data', 'results'],
      );

      final rides = (root?['rides'] as List?) ?? const [];
      final events = (root?['events'] as List?) ?? const [];
      final list = [...rides, ...events];

      return list
          .whereType<Map<String, dynamic>>()
          .map(ProfileEventHistoryItem.fromApi)
          .toList();
    } catch (_) {
      return const [];
    }
  }

  Future<List<ProfileUpcomingEventItem>> fetchActiveParticipations() async {
    try {
      final response = await _apiClient.get<dynamic>(
        ApiEndpoints.authMeActiveParticipations,
        queryParameters: const {'page': 1, 'limit': 10},
      );

      final root = ResponseParser.extractMap(
        response.data,
        const ['data', 'results'],
      );

      final rides = (root?['rides'] as List?) ?? const [];
      final events = (root?['events'] as List?) ?? const [];
      final list = [...rides, ...events];

      return list
          .whereType<Map<String, dynamic>>()
          .map(ProfileUpcomingEventItem.fromApi)
          .toList();
    } catch (_) {
      return const [];
    }
  }

  Future<List<ProfileBadgeItem>> fetchUserBadges() async {
    try {
      final badgesFuture = _apiClient.get<dynamic>(
        ApiEndpoints.badges,
        queryParameters: const {
          'active': true,
          'page': 1,
          'limit': 100,
        },
      );

      final iconsFuture = _apiClient.get<dynamic>(ApiEndpoints.badgeIcons);

      final completedFuture = _apiClient.get<dynamic>(
        ApiEndpoints.authMeCompletedEvents,
        queryParameters: const {'page': 1, 'limit': 100},
      );

      final badgesResponse = await badgesFuture;
      final iconsResponse = await iconsFuture;
      final completedResponse = await completedFuture;

      final allBadges = ResponseParser.extractList(
        badgesResponse.data,
        const ['badges', 'items', 'results'],
      ).whereType<Map<String, dynamic>>().toList();

      final badgeIcons = ResponseParser.extractList(
        iconsResponse.data,
        const ['icons'],
      ).whereType<Map<String, dynamic>>().toList();

      final iconMap = Map<String, String>.fromEntries(
        badgeIcons.map((icon) {
          final key = ResponseParser.asString(icon['key']);
          final emoji = ResponseParser.asString(icon['emoji']);
          return MapEntry(key, emoji);
        }),
      );

      final completedData = ResponseParser.extractMap(
        completedResponse.data,
        const ['data'],
      );

      final rides = (completedData?['rides'] as List?)
              ?.whereType<Map<String, dynamic>>()
              .toList() ??
          const <Map<String, dynamic>>[];
      final events = (completedData?['events'] as List?)
              ?.whereType<Map<String, dynamic>>()
              .toList() ??
          const <Map<String, dynamic>>[];

      final earnedByName = <String, DateTime>{};
      for (final item in [...rides, ...events]) {
        final event = item['event'];
        if (event is! Map<String, dynamic>) continue;

        final badgeName = ResponseParser.asString(
          event['badgeName'] ?? event['rewards']?['badgeName'],
        );
        if (badgeName.isEmpty) continue;

        final completedAtRaw = item['completedAt'] ?? item['updatedAt'];
        final completedAt = DateTime.tryParse(
          ResponseParser.asString(completedAtRaw),
        );

        final normalizedBadgeName = _normalizeBadgeKey(badgeName);
        final existing = earnedByName[normalizedBadgeName];
        if (existing == null ||
            (completedAt != null && completedAt.isBefore(existing))) {
          earnedByName[normalizedBadgeName] = completedAt ?? DateTime.now();
        }
      }

      final mapped = allBadges.map((badge) {
        final name = ResponseParser.asString(badge['name']);
        final earnedAt = earnedByName[_normalizeBadgeKey(name)];
        final iconKey = ResponseParser.asString(badge['icon']);
        return ProfileBadgeItem.fromBadgeApi(
          badge,
          earned: earnedAt != null,
          earnedAt: earnedAt,
          iconEmoji: iconMap[iconKey] ?? '',
        );
      }).toList();

      mapped.sort((a, b) {
        if (a.earned != b.earned) return a.earned ? -1 : 1;
        if (a.earned && b.earned) {
          final ad = a.earnedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          final bd = b.earnedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          return bd.compareTo(ad);
        }
        return a.name.compareTo(b.name);
      });

      return mapped;
    } catch (_) {
      return const [];
    }
  }

  String _normalizeBadgeKey(String value) {
    return value.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '');
  }

  Future<List<Map<String, dynamic>>> fetchJoinedCommunities() async {
    try {
      final response = await _apiClient.get<dynamic>(
        ApiEndpoints.authMeJoinedCommunities,
        queryParameters: const {'page': 1, 'limit': 50},
      );

      final list = ResponseParser.extractList(
        response.data,
        const ['data', 'communities', 'results'],
      ).whereType<Map<String, dynamic>>().toList();

      return list;
    } catch (_) {
      return const [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchUserStoreItems() async {
    try {
      final response = await _apiClient.get<dynamic>(
        ApiEndpoints.storeMyItems,
        queryParameters: const {'page': 1, 'limit': 50},
      );

      final list = ResponseParser.extractList(
        response.data,
        const ['data', 'items', 'results'],
      ).whereType<Map<String, dynamic>>().toList();

      return list;
    } catch (_) {
      return const [];
    }
  }
}
