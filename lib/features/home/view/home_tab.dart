import 'package:adcc/core/constants/cosmatic_imgs.dart';
import 'package:adcc/core/services/token_storage_service.dart';
import 'package:adcc/features/event_details/view/event_details_screen.dart';
import 'package:adcc/features/events/view/events_screen.dart';
import 'package:adcc/features/home/view/horizontal_rideList.dart';
import 'package:adcc/features/home/viewmodels/home_view_model.dart';
import 'package:adcc/features/home/view/community_updates_section.dart';
import 'package:adcc/features/home/view/join_community_card.dart';
import 'package:adcc/features/home/view/near_by_track.dart';
import 'package:adcc/features/home/view/quick_actions_section.dart';
import 'package:adcc/features/home/view/promo_carousel.dart';
import 'package:adcc/features/home/view/promo_card.dart';
import 'package:adcc/features/home/view/recently_posted_section.dart.dart';
import 'package:adcc/features/home/view/ride_info_section.dart';
import 'package:adcc/features/home/models/home_models.dart';
import 'package:adcc/features/home/models/weather_models.dart';
import 'package:adcc/features/home/repositories/weather_repository.dart';
import 'package:adcc/features/home/view/upcoming_tracks_list.dart';
import 'package:adcc/features/communities/models/community_model.dart';
import 'package:adcc/features/communities/view/community_type_details.dart';
import 'package:adcc/features/home/view/weather_screen.dart';
import 'package:adcc/features/route_details/view/route_details_screen.dart';
import 'package:adcc/features/profile/repositories/profile_repository.dart';
import 'package:adcc/shared/widgets/section_header.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:adcc/l10n/app_localizations.dart';
import '../../auth/view/registrationScreen/create_account.dart';
import 'section/profile_header.dart';
import 'package:adcc/features/notifications/view/notifications_screen.dart';

// class HomeTab extends StatefulWidget {
//   final ValueChanged<int>? onTabChange;

//   const HomeTab({super.key, this.onTabChange});

//   @override
//   State<HomeTab> createState() => _HomeTabState();
// }

class HomeTab extends StatefulWidget {
  final ValueChanged<int>? onTabChange;
  final bool fromGuest;

  const HomeTab({
    super.key,
    this.onTabChange,
    this.fromGuest = false,
  });

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final HomeViewModel _viewModel = HomeViewModel();
  final WeatherRepository _weatherRepository = WeatherRepository();
  String _userName = '';
  late final Future<WeatherSnapshot?> _weatherFuture;

  @override
  void initState() {
    super.initState();
    _viewModel.addListener(_onVmChanged);
    _weatherFuture = _weatherRepository.fetchWeatherSnapshot();
    _viewModel.loadHome();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final storedName = (await TokenStorageService.getUserName())?.trim() ?? '';
    if (storedName.isNotEmpty) {
      if (mounted) setState(() => _userName = storedName);
      return;
    }

    try {
      final profile = await ProfileRepository().fetchProfile();
      final profileName = profile?.fullName.trim() ?? '';
      if (profileName.isNotEmpty) {
        await TokenStorageService.saveUserName(profileName);
        if (mounted) setState(() => _userName = profileName);
      }
    } catch (_) {
      // Ignore and keep the default guest state if no profile name is available.
    }
  }

  void _onVmChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onVmChanged);
    _viewModel.dispose();
    super.dispose();
  }

  void _goToEvent(String eventId) {
    if (eventId.isEmpty) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EventDetailsScreen(eventId: eventId),
      ),
    );
  }

  /// Builds the "Ride info" section title: an API-provided section title wins,
  /// otherwise "Ride in {user city}", falling back to "Ride in Abu Dhabi" for
  /// guests / users without a city. Localized via [loc].
  String _rideInfoTitle(AppLocalizations loc, HomeFeedModel? feed) {
    final apiTitle = (feed?.rideInfoSectionTitle ?? '').trim();
    if (apiTitle.isNotEmpty) return apiTitle;

    final city = (feed?.userCity ?? '').trim();
    if (city.isNotEmpty) return loc.ride_in_city(city);
    return loc.ride_in_abu_dhabi;
  }

  void _redirectGuestToLogin() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(AppLocalizations.of(dialogContext)!.login_required_title),
          content: Text(
            AppLocalizations.of(dialogContext)!.login_required_message,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(AppLocalizations.of(dialogContext)!.delete_account_cancel),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const CreateAccountScreen(),
                  ),
                );
              },
              child: Text(AppLocalizations.of(dialogContext)!.login),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final feed = _viewModel.feed;
    final isLoading = _viewModel.isLoading;
    final error = _viewModel.error;

    final upcomingEvents = feed?.upcomingEvents ?? const [];
    final communities = feed?.popularCommunities ?? const [];
    var promoItems = (feed?.promoBanners ?? const [])
        .where((e) =>
            e.image.isNotEmpty && RegExp(r'^https?://').hasMatch(e.image))
        .map((e) {
      var img = e.image.trim();
      // Append updatedAt as cache-busting query param when available
      final updatedAt = (e.updatedAt.isNotEmpty) ? e.updatedAt : null;
      if (updatedAt != null && updatedAt.isNotEmpty) {
        final separator = img.contains('?') ? '&' : '?';
        img = '$img${separator}v=${Uri.encodeComponent(updatedAt)}';
      }
      return PromoData(
        image: img,
        title: e.title,
        subtitle: e.subtitle,
        highlight: e.highlight,
        buttonText: e.buttonText,
        targetScreen: e.targetScreen,
      );
    }).toList();

    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 34),
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(
                          HomeImgs.homeheaderbackground,
                        ),
                        fit: BoxFit.fitWidth,
                        alignment: Alignment(0, -0.9), // Move image down
                      ),
                    ),
                    child: Column(
                      children: [
                        ProfileHeader(
                          name: widget.fromGuest
                              ? loc.welcome_guest
                              : (_userName.isNotEmpty ? _userName : ''),
                          weatherFuture: _weatherFuture,
                          onNotificationTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const NotificationsScreen(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        _SearchWeatherBar(
                          feed: feed,
                          onNotificationTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const NotificationsScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  PromoCarousel(
                    items: promoItems,
                    showFallback: false,
                  ),
                  const SizedBox(height: 26),
                  WeatherScreen(weatherFuture: _weatherFuture),
                  const SizedBox(height: 32),
                  Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(
                          HomeImgs.homeQuickActionBackground,
                        ),
                        fit: BoxFit.cover,
                        alignment: Alignment(0, -0.9), // Move image down
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 24),
                      child: QuickActionsSection(
                        onTabChange: widget.onTabChange,
                        fromGuest: widget.fromGuest,
                        onGuestRestrictedTap: _redirectGuestToLogin,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  HorizontalRideList(
                    communities: communities,
                    showFallback: false,
                    onCommunityTap: (id) {
                      if (widget.fromGuest) {
                        _redirectGuestToLogin();
                        return;
                      }
                      final community = communities.firstWhere(
                        (community) => community.id == id,
                        orElse: () => HomeCommunityModel(
                          id: id,
                          title: AppLocalizations.of(context)!.community,
                          image: 'assets/images/family_ride.png',
                          members: 0,
                        ),
                      );
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => CommunityCityDetails(
                            community: CommunityModel(
                              id: community.id,
                              title: community.title,
                              description: '',
                              type: '',
                              category: const [],
                              imageUrl: community.image,
                              isActive: true,
                              isPublic: true,
                              isFeatured: false,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                  // FeaturedEventsList(
                  //   events: featuredEvents,
                  //   showFallback: false,
                  //   onEventTap: _goToEvent,
                  // ),
                  // const SizedBox(height: 40),
                  NearbyTracksSection(
                    tracks: feed?.nearbyTracks ?? const [],
                    showFallback: false,
                  ),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SectionHeader(
                      title: loc.upcomingEvents,
                      onViewAll: () {
                        if (widget.onTabChange != null) {
                          widget.onTabChange!.call(1);
                          return;
                        }
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const EventsScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 22),
                  UpcomingTracksList(
                    events: upcomingEvents,
                    onEventTap: _goToEvent,
                    showFallback: false,
                  ),
                  const SizedBox(height: 40),
                  RecentlyPost(
                    items: feed?.recentItems ?? const [],
                    showFallback: false,
                  ),
                  const SizedBox(height: 40),
                  CommunityUpdatesSection(
                    updates: feed?.communityUpdates ?? const [],
                    showFallback: false,
                    fromGuest: widget.fromGuest,
                    onGuestRestrictedTap: _redirectGuestToLogin,
                  ),
                  const SizedBox(height: 70),
                  RideInfoSection(
                    rideInfos: feed?.rideInfos ?? const [],
                    sectionTitle: _rideInfoTitle(loc, feed),
                    showFallback: true,
                  ),
                  const SizedBox(height: 40),
                  JoinCommunityCard(
                    onJoinTap: () {
                      if (widget.fromGuest) {
                        _redirectGuestToLogin();
                      }
                    },
                  ),
                  const SizedBox(height: 94),
                ],
              ),

              // Loading overlay on first load
              if (isLoading && feed == null)
                const Center(child: CircularProgressIndicator()),

              // Error banner with retry (only when no cached data)
              if (error != null && feed == null)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.wifi_off_rounded,
                            size: 48, color: Colors.grey),
                        const SizedBox(height: 12),
                        Text(
                          loc.could_not_load_feed,
                          style: const TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: _viewModel.loadHome,
                          child: Text(loc.common_retry),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SearchWeatherBar extends StatelessWidget {
  const _SearchWeatherBar({
    this.feed,
    this.onNotificationTap,
  });

  final HomeFeedModel? feed;
  final VoidCallback? onNotificationTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                showSearch(
                  context: context,
                  delegate: _HomeSearchDelegate(feed: feed),
                );
              },
              child: Container(
                height: 47,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFEBF3FF),
                  border: Border.all(
                    color: const Color(0xFFD7E4FA),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.search,
                        size: 14,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context)!.searchHint,
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF666666),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // const SizedBox(width: 12),
          GestureDetector(
            onTap: onNotificationTap,
            child: SizedBox(
              width: 50,
              height: 50,
              child: Image.asset(
                'assets/icons/notification.gif',
                width: 50,
                height: 50,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeSearchDelegate extends SearchDelegate<String> {
  final HomeFeedModel? feed;

  _HomeSearchDelegate({required this.feed});

  @override
  String get searchFieldLabel => 'Search events, communities, tracks';

  @override
  TextStyle get searchFieldStyle => const TextStyle(
        fontFamily: 'Outfit',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Color(0xFF333333),
      );

  @override
  List<Widget>? buildActions(BuildContext context) {
    if (query.isEmpty) return null;
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: theme.appBarTheme.copyWith(
        backgroundColor: const Color(0xFFEBF3FF),
        elevation: 0,
        iconTheme: theme.iconTheme.copyWith(color: Colors.black87),
        // titleTextStyle: theme.textTheme.titleLarge?.copyWith(
        //   color: Colors.black87,
        //   fontWeight: FontWeight.w700,
        // ),
      ),
      scaffoldBackgroundColor: const Color(0xFFEBF3FF),
      inputDecorationTheme: theme.inputDecorationTheme.copyWith(
        filled: true,
        fillColor: const Color(0xFFEBF3FF),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        hintStyle: const TextStyle(
          fontFamily: 'Outfit',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(0xFF666666),
        ),
        // focusedBorder: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(18),
        //   borderSide: const BorderSide(color: Color(0xFFD7E4FA), width: 1.5),
        // ),
        // enabledBorder: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(18),
        //   borderSide: const BorderSide(color: Color(0xFFD7E4FA), width: 1.2),
        // ),
      ),
    );
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, ''),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final items = _filterItems(context, query);
    return _buildResultList(context, items);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (feed == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(AppLocalizations.of(context)!.loadingSearchResults),
        ),
      );
    }

    final results = query.isEmpty ? _topSuggestions(context) : _filterItems(context, query);
    return _buildResultList(context, results,
        emptyMessage: query.isEmpty
            ? AppLocalizations.of(context)!.searchAcrossHint
            : AppLocalizations.of(context)!.noResultsFound);
  }

  List<_HomeSearchItem> _topSuggestions(BuildContext context) {
    return _allItems(context).take(6).toList();
  }

  List<_HomeSearchItem> _filterItems(BuildContext context, String query) {
    final search = query.trim().toLowerCase();
    if (search.isEmpty) return _allItems(context);
    return _allItems(context).where((item) {
      return item.title.toLowerCase().contains(search) ||
          item.subtitle.toLowerCase().contains(search);
    }).toList();
  }

  List<_HomeSearchItem> _allItems(BuildContext context) {
    if (feed == null) return const [];

    final items = <_HomeSearchItem>[];

    for (final event in feed!.upcomingEvents) {
      items.add(_HomeSearchItem(
        id: event.id,
        title: event.title,
        subtitle: event.date,
        type: _HomeSearchItemType.event,
      ));
    }

    if (feed!.featuredEvent != null) {
      final featured = feed!.featuredEvent!;
      items.insert(
        0,
        _HomeSearchItem(
          id: featured.id,
          title: featured.title,
          subtitle: featured.date,
          type: _HomeSearchItemType.event,
        ),
      );
    }

    for (final community in feed!.popularCommunities) {
      items.add(_HomeSearchItem(
        id: community.id,
        title: community.title,
        subtitle: '${community.members} ${AppLocalizations.of(context)!.members}',
        type: _HomeSearchItemType.community,
      ));
    }

    for (final track in feed!.nearbyTracks) {
      items.add(_HomeSearchItem(
        id: track.id,
        title: track.title,
        subtitle: track.location,
        type: _HomeSearchItemType.track,
      ));
    }

    for (final item in feed!.recentItems) {
      items.add(_HomeSearchItem(
        id: item.id,
        title: item.title,
        subtitle: '${AppLocalizations.of(context)!.soldBy} ${item.postedBy}',
        type: _HomeSearchItemType.storeItem,
      ));
    }

    for (final post in feed!.communityUpdates) {
      items.add(_HomeSearchItem(
        id: post.id,
        title: post.name,
        subtitle: post.caption,
        type: _HomeSearchItemType.post,
      ));
    }

    return items;
  }

  Widget _buildResultList(BuildContext context, List<_HomeSearchItem> items,
      {String? emptyMessage}) {
    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            emptyMessage ?? AppLocalizations.of(context)!.noResultsFound,
            style: const TextStyle(
              color: Color(0xFF333333),
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }

    return Container(
      color: const Color(0xFFEBF3FF),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        physics: const BouncingScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = items[index];
          return Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            elevation: 1.5,
            shadowColor: Colors.black.withValues(alpha: 0.08),
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () => _onItemTap(context, item),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFFB8D2FF),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        _iconForType(item.type),
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF111827),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            item.subtitle,
                            style: const TextStyle(
                              fontSize: 13,
                              height: 1.35,
                              color: Color(0xFF5B6270),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Directionality.of(context) == TextDirection.rtl
                          ? Icons.arrow_back_ios
                          : Icons.arrow_forward_ios,
                      size: 16,
                      color: const Color(0xFF7A8AAF),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  IconData _iconForType(_HomeSearchItemType type) {
    switch (type) {
      case _HomeSearchItemType.event:
        return Icons.event;
      case _HomeSearchItemType.community:
        return Icons.group;
      case _HomeSearchItemType.track:
        return Icons.map;
      case _HomeSearchItemType.storeItem:
        return Icons.store;
      case _HomeSearchItemType.post:
        return Icons.article;
    }
  }

  void _onItemTap(BuildContext context, _HomeSearchItem item) {
    close(context, item.title);

    switch (item.type) {
      case _HomeSearchItemType.event:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => EventDetailsScreen(eventId: item.id),
          ),
        );
        break;
      case _HomeSearchItemType.community:
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => CommunityCityDetails(
                              community: CommunityModel(
                                id: item.id,
                                title: item.title,
                                description: item.subtitle,
                                type: '',
                                category: const [],
                                isActive: false,
                                isPublic: false,
                                isFeatured: false,
                                isJoined: false,
                              ),
                            ),
                          ),
                        );
        break;
      case _HomeSearchItemType.track:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => RouteDetailsScreen(
              routeData: {'id': item.id},
            ),
          ),
        );
        break;
      case _HomeSearchItemType.storeItem:
      case _HomeSearchItemType.post:
        break;
    }
  }
}

enum _HomeSearchItemType { event, community, track, storeItem, post }

class _HomeSearchItem {
  final String id;
  final String title;
  final String subtitle;
  final _HomeSearchItemType type;

  const _HomeSearchItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
  });
}
