import 'package:adcc/core/constants/api_endpoints.dart';
import 'package:adcc/core/services/api_client.dart';
import 'package:adcc/core/services/api_response.dart';
import 'package:adcc/core/services/language_storage_service.dart';
import 'package:adcc/core/services/lookup_service.dart';
import 'package:adcc/core/utils/response_parser.dart';
import 'package:adcc/features/home/models/home_models.dart';
import 'package:adcc/features/profile/repositories/profile_repository.dart';
import 'package:flutter/foundation.dart';

class HomeRepository {
  final ApiClient _apiClient;
  final ProfileRepository _profileRepository;

  HomeRepository({ApiClient? apiClient, ProfileRepository? profileRepository})
      : _apiClient = apiClient ?? ApiClient.instance,
        _profileRepository = profileRepository ?? ProfileRepository();

  static String resolvePromoBannerEndpoint(String? localeCode) {
    final normalized = (localeCode ?? '').trim().toLowerCase();
    if (normalized.startsWith('ar')) {
      return ApiEndpoints.appBannersAr;
    }
    return ApiEndpoints.appBanners;
  }

  Future<HomeFeedModel> fetchHomeFeed() async {
    final results = await Future.wait<dynamic>([
      _safeFetch(_fetchEvents),
      _safeFetch(_fetchCommunities),
      _safeFetch(_fetchPromoBanners),
      _safeFetch(_fetchTracks),
      _safeFetch(_fetchRecentStoreItems),
      _safeFetch(_fetchFeedPosts),
      _safeFetch(_fetchRideInfos),
    ]);

    final events = results[0] as List<HomeEventModel>;
    final communities = results[1] as List<HomeCommunityModel>;
    final banners = results[2] as List<HomeBannerModel>;
    final tracks = results[3] as List<HomeTrackModel>;
    final recentItems = results[4] as List<HomeStoreItemModel>;
    final feedPosts = results[5] as List<HomeFeedPostModel>;
    final rideInfos = results[6] as List<HomeRideInfoModel>;

    return HomeFeedModel(
      featuredEvent: events.isEmpty ? null : events.first,
      upcomingEvents: events,
      popularCommunities: communities,
      promoBanners: banners,
      nearbyTracks: tracks,
      recentItems: recentItems,
      communityUpdates: feedPosts,
      rideInfos: rideInfos,
      rideInfoSectionTitle: _extractRideInfoSectionTitle(rideInfos),
      userCity: await _fetchUserCity(),
    );
  }

  String _extractRideInfoSectionTitle(List<HomeRideInfoModel> rideInfos) {
    for (final item in rideInfos) {
      final title = item.sectionTitle.trim();
      if (title.isNotEmpty) return title;
    }
    return '';
  }

  /// Returns the logged-in user's city localized for the current locale
  /// (empty for guests / no city), so the widget layer can build a localized
  /// "Ride in {city}" headline.
  Future<String> _fetchUserCity() async {
    try {
      final profile = await _profileRepository.fetchProfile();
      final rawCity = (profile?.city ?? '').trim();
      if (rawCity.isEmpty) return '';
      return await LookupService.instance.resolveLabel(
        ApiEndpoints.lookupTypeCity,
        rawCity,
      );
    } catch (_) {
      return '';
    }
  }

  Future<List<T>> _safeFetch<T>(Future<List<T>> Function() fetcher) async {
    try {
      return await fetcher();
    } catch (_) {
      return const [];
    }
  }

  Future<List<HomeEventModel>> _fetchEvents() async {
    try {
      final homeEvents = await _fetchEventsWithFilter(
        {'limit': 10, 'page': 1},
        endpoint: ApiEndpoints.homeEvents,
      );
      if (homeEvents.isNotEmpty) return homeEvents;
    } catch (_) {
      // Continue to legacy fallback if the new home endpoint is unavailable.
    }

    try {
      final openEvents = await _fetchEventsWithFilter(
        {'status': 'Open', 'limit': 10, 'page': 1},
      );
      if (openEvents.isNotEmpty) return openEvents;

      final upcomingEvents = await _fetchEventsWithFilter(
        {'status': 'Upcoming', 'limit': 10, 'page': 1},
      );
      if (upcomingEvents.isNotEmpty) return upcomingEvents;

      return await _fetchEventsWithFilter(
        {'limit': 10, 'page': 1},
      );
    } catch (_) {
      return const [];
    }
  }

  Future<List<HomeEventModel>> _fetchEventsWithFilter(
    Map<String, dynamic> queryParameters, {
    String endpoint = ApiEndpoints.events,
  }) async {
    final response = await _apiClient.get<dynamic>(
      endpoint,
      queryParameters: queryParameters,
    );

    final list = ResponseParser.extractList(
      response.data,
      const ['events', 'items', 'results'],
    );

    return list
        .whereType<Map<String, dynamic>>()
        .map(HomeEventModel.fromJson)
        .toList();
  }

  Future<List<HomeCommunityModel>> _fetchCommunities() async {
    try {
      final response = await _apiClient.get<dynamic>(
        ApiEndpoints.communities,
        queryParameters: {
          'isFeatured': true,
          'limit': 10,
          'page': 1,
        },
      );

      final list = ResponseParser.extractList(
        response.data,
        const ['communities', 'items', 'results'],
      );

      return list
          .whereType<Map<String, dynamic>>()
          .map(HomeCommunityModel.fromJson)
          .toList();
    } catch (_) {
      return const [];
    }
  }

  Future<List<HomeTrackModel>> _fetchTracks() async {
    try {
      final response = await _apiClient.get<dynamic>(
        ApiEndpoints.tracks,
        queryParameters: {
          'status': 'open',
          'limit': 10,
          'page': 1,
        },
      );

      final list = ResponseParser.extractList(
        response.data,
        const ['tracks', 'items', 'results'],
      );

      return list
          .whereType<Map<String, dynamic>>()
          .map(HomeTrackModel.fromJson)
          .toList();
    } catch (_) {
      return const [];
    }
  }

  Future<List<HomeStoreItemModel>> _fetchRecentStoreItems() async {
    try {
      final response = await _apiClient.get<dynamic>(
        ApiEndpoints.storeItems,
        queryParameters: {
          'status': 'Approved',
          'limit': 10,
          'page': 1,
        },
      );

      final list = ResponseParser.extractList(
        response.data,
        const ['items', 'products', 'results'],
      );

      final localeCode = await LanguageStorageService.getLocaleCode();

      final mapped = list.whereType<Map<String, dynamic>>().map((raw) {
        if (localeCode == 'ar') {
          final copy = Map<String, dynamic>.from(raw);
          if (copy['titleAr'] != null && (copy['titleAr'] as String).trim().isNotEmpty) copy['title'] = copy['titleAr'];
          if (copy['nameAr'] != null && (copy['nameAr'] as String).trim().isNotEmpty) copy['title'] = copy['nameAr'];
          if (copy['descriptionAr'] != null && (copy['descriptionAr'] as String).trim().isNotEmpty) copy['description'] = copy['descriptionAr'];
          if (copy['specificationsAr'] != null && copy['specificationsAr'] is List) copy['specifications'] = copy['specificationsAr'];
          return copy;
        }
        return raw as Map<String, dynamic>;
      }).toList();

      return mapped.map(HomeStoreItemModel.fromJson).toList();
    } catch (_) {
      return const [];
    }
  }

  Future<List<HomeFeedPostModel>> _fetchFeedPosts() async {
    try {
      final response = await _apiClient.get<dynamic>(
        ApiEndpoints.feed,
        queryParameters: {
          'limit': 10,
          'page': 1,
        },
      );

      final list = ResponseParser.extractList(
        response.data,
        const ['feedPosts', 'posts', 'items', 'results'],
      );

      return list
          .whereType<Map<String, dynamic>>()
          .map(HomeFeedPostModel.fromJson)
          .toList();
    } catch (_) {
      return const [];
    }
  }

  Future<List<HomeBannerModel>> _fetchPromoBanners() async {
    try {
      final localeCode = await LanguageStorageService.getLocaleCode();
      final endpoint = resolvePromoBannerEndpoint(localeCode);
      final response = await _apiClient.get<dynamic>(
        endpoint,
      );

      final list = ResponseParser.extractList(
        response.data,
        const ['banners'],
      );

      if (kDebugMode) {
        for (var i = 0; i < list.length; i++) {
          final item = list[i];
          if (item is Map<String, dynamic>) {
            final raw = ResponseParser.asString(
              item['image'] ?? item['mainImage'] ?? item['bannerImage'] ?? '',
            );
            if (raw.isEmpty) {
              debugPrint('API promo banner [$i] image: <empty>');
            } else if (RegExp(r'^https?://').hasMatch(raw)) {
              debugPrint('API promo banner [$i] image URL: $raw');
            } else {
              debugPrint('API promo banner [$i] image non-URL: $raw');
            }
          }
        }
      }

      final mapped = list
          .whereType<Map<String, dynamic>>()
          .map(HomeBannerModel.fromJson)
          .toList();

      if (mapped.isNotEmpty) return mapped;
    } catch (_) {
      // ignore and fallback to legacy banner source
    }

    return _fetchLegacyPromoBanners();
  }

  Future<List<HomeBannerModel>> _fetchLegacyPromoBanners() async {
    try {
      final response = await _apiClient.get<dynamic>(
        ApiEndpoints.settingsContentList,
      );

      final list = ResponseParser.extractList(
        response.data,
        const ['contents', 'items', 'results', 'banners'],
      );

      return list
          .whereType<Map<String, dynamic>>()
          .where((item) {
            final key = ResponseParser.asString(item['key'] ?? item['type'])
                .toLowerCase();
            return key.contains('home') || key.contains('banner');
          })
          .map(HomeBannerModel.fromJson)
          .toList();
    } catch (_) {
      return const [];
    }
  }

  Future<List<HomeRideInfoModel>> _fetchRideInfos() async {
    try {
      final response = await _apiClient.get<dynamic>(
        ApiEndpoints.settingsContentList,
      );

      final list = ResponseParser.extractList(
        response.data,
        const ['contents', 'items', 'results', 'settings'],
      );

      final mapped = list.whereType<Map<String, dynamic>>().where((item) {
        final key = ResponseParser.asString(item['key']).toLowerCase();
        final group = ResponseParser.asString(item['group']).toLowerCase();
        final title = ResponseParser.asString(item['title']);
        final description = ResponseParser.asString(item['description']);

        final isRideKey = key.contains('ride_info') ||
            key.contains('ride-info') ||
            key.contains('rideinabudhabi') ||
            key.contains('ride_in_abu_dhabi') ||
            key.contains('guideline') ||
            key.contains('route');
        final isHomeGroup = group.contains('home') || group.contains('ride');
        final hasContent = title.isNotEmpty && description.isNotEmpty;

        return (isRideKey || isHomeGroup) && hasContent;
      }).map((item) {
        final sectionTitle = ResponseParser.asString(
          item['label'] ?? item['sectionTitle'] ?? item['section_title'],
        );
        return HomeRideInfoModel(
          title: ResponseParser.asString(
            item['title'],
            fallback: ApiResponse.localized(
              (l) => l.officialCyclingRoutes,
              'Official Cycling Routes',
            ),
          ),
          subtitle: ResponseParser.asString(
            item['description'],
            fallback: ApiResponse.localized(
              (l) => l.exploreSafeRoutes,
              'Explore safe routes across Abu Dhabi',
            ),
          ),
          sectionTitle: sectionTitle,
        );
      }).toList();

      return mapped;
    } catch (_) {
      return const [];
    }
  }
}
