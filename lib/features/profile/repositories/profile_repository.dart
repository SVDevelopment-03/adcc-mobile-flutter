import 'package:adcc/core/constants/api_endpoints.dart';
import 'package:adcc/core/services/api_client.dart';
import 'package:adcc/core/services/language_storage_service.dart';
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

  Future<String> _resolvedLocale({String? locale}) async {
    final savedLocale = locale ?? await LanguageStorageService.getLocaleCode();
    return (savedLocale ?? 'en').trim().isEmpty ? 'en' : savedLocale!.trim();
  }

  Future<List<ProfileEventHistoryItem>> fetchCompletedEvents(
      {String? locale}) async {
    try {
      final resolvedLocale = await _resolvedLocale(locale: locale);
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
          .map((item) =>
              ProfileEventHistoryItem.fromApi(item, locale: resolvedLocale))
          .toList();
    } catch (_) {
      return const [];
    }
  }

  Future<List<ProfileUpcomingEventItem>> fetchActiveParticipations(
      {String? locale}) async {
    try {
      final resolvedLocale = await _resolvedLocale(locale: locale);
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
          .map((item) =>
              ProfileUpcomingEventItem.fromApi(item, locale: resolvedLocale))
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

  static String resolveCommunityDisplayName(
    Map<String, dynamic> community, {
    required bool isArabic,
  }) {
    final nested = community['community'];
    final localeSpecificCandidates = <dynamic>[];
    final fallbackCandidates = <dynamic>[];

    final addCandidates = (Map<String, dynamic> map) {
      localeSpecificCandidates.addAll([
        map['nameAr'],
        map['titleAr'],
        map['labelAr'],
      ]);
      fallbackCandidates.addAll([
        map['name'],
        map['title'],
        map['communityName'],
        map['nameEn'],
        map['label'],
        map['slug'],
      ]);
    };

    addCandidates(community);
    if (nested is Map<String, dynamic>) {
      addCandidates(nested);
    }

    final ordered = isArabic
        ? [...localeSpecificCandidates, ...fallbackCandidates]
        : [...fallbackCandidates, ...localeSpecificCandidates];

    for (final value in ordered) {
      final text = ResponseParser.asString(value);
      if (text.isNotEmpty) {
        return text;
      }
    }

    return '';
  }

  Future<List<Map<String, dynamic>>> fetchJoinedCommunities(
      {String? locale}) async {
    try {
      final response = await _apiClient.get<dynamic>(
        ApiEndpoints.authMeJoinedCommunities,
        queryParameters: const {'page': 1, 'limit': 50},
      );

      final list = ResponseParser.extractList(
        response.data,
        const ['data', 'communities', 'results'],
      ).whereType<Map<String, dynamic>>().toList();

      final resolvedLocale = await _resolvedLocale(locale: locale);
      if (resolvedLocale.toLowerCase().startsWith('ar')) {
        return list.map((community) {
          final mapped = Map<String, dynamic>.from(community);
          final nested = mapped['community'];

          if (nested is Map<String, dynamic>) {
            final nestedMap = Map<String, dynamic>.from(nested);
            mapped['community'] = nestedMap;

            final arabicName = nestedMap['nameAr'] ?? nestedMap['titleAr'];
            final fallbackName = nestedMap['name'] ?? nestedMap['title'];
            mapped['name'] = ResponseParser.asString(arabicName).isNotEmpty
                ? arabicName
                : (ResponseParser.asString(fallbackName).isNotEmpty
                    ? fallbackName
                    : mapped['name']);
            mapped['title'] = ResponseParser.asString(arabicName).isNotEmpty
                ? arabicName
                : (ResponseParser.asString(fallbackName).isNotEmpty
                    ? fallbackName
                    : mapped['title']);
          }

          final arabicPrimary = ResponseParser.asString(mapped['nameAr'])
                  .isNotEmpty
              ? mapped['nameAr']
              : ResponseParser.asString(mapped['titleAr']).isNotEmpty
                  ? mapped['titleAr']
                  : null;

          if (arabicPrimary != null) {
            mapped['name'] = arabicPrimary;
            mapped['title'] = arabicPrimary;
          }

          return mapped;
        }).toList();
      }

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

      // Prefer Arabic fields when locale is Arabic
      final localeCode = await LanguageStorageService.getLocaleCode();
      if (localeCode == 'ar') {
        return list.map((raw) {
          final copy = Map<String, dynamic>.from(raw);
          if (copy['titleAr'] != null && (copy['titleAr'] as String).trim().isNotEmpty) copy['title'] = copy['titleAr'];
          if (copy['nameAr'] != null && (copy['nameAr'] as String).trim().isNotEmpty) copy['title'] = copy['nameAr'];
          if (copy['descriptionAr'] != null && (copy['descriptionAr'] as String).trim().isNotEmpty) copy['description'] = copy['descriptionAr'];
          if (copy['specificationsAr'] != null && copy['specificationsAr'] is List) copy['specifications'] = copy['specificationsAr'];
          return copy;
        }).toList();
      }

      return list;
    } catch (_) {
      return const [];
    }
  }
}
