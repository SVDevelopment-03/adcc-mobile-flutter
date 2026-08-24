import 'package:adcc/core/constants/api_endpoints.dart';
import 'package:adcc/core/constants/cosmatic_imgs.dart';
import 'package:adcc/core/models/lookup_model.dart';
import 'package:adcc/core/services/language_storage_service.dart';
import 'package:adcc/core/services/lookup_service.dart';
import 'package:adcc/features/event_details/view/event_details_screen.dart';
import 'package:adcc/features/events/Model/model_events.dart';
import 'package:adcc/features/events/sections/purpose_based_event_card.dart';
import 'package:adcc/features/events/view/view_all_purpose_based_events.dart';
import 'package:adcc/core/utils/share_helper.dart';

import 'package:adcc/features/events/view/special_ride_card.dart';
import 'package:adcc/features/events/services/events_service.dart';
import 'package:adcc/shared/widgets/section_header.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:adcc/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

import '../sections/event_by_category.dart';

class EventsTab extends StatefulWidget {
  const EventsTab({super.key});

  @override
  State<EventsTab> createState() => _EventsTabState();
}

class _EventsTabState extends State<EventsTab> {
  int selectedCategoryIndex = 0;
  bool _isLoading = true;
  String? _errorMessage;
  String _searchQuery = '';
  List<Event> _events = [];
  final EventsService _eventsService = EventsService();

  // Display labels come from the dashboard-managed lookup service
  // (`/v1/lookups?type=event_category`) and are localized (en/ar).
  // Index 0 is always "All". The backing English `value` is kept for
  // filtering against `_derivedCategory`.
  List<String> categories = ['All'];
  List<String> _categoryValues = ['All'];
  List<LookupModel> _categoryLookups = const [];

  // ── Category icon handling ────────────────────────────────────────────────
  // Category grid images come from the dashboard-managed lookup service
  // (`GET /v1/lookups?type=event_category` → `icon` field on each entry).
  // These S3 URLs are only a fallback for categories that don't have an
  // icon uploaded in the dashboard yet.
  static const List<String> _fallbackCategoryImages = [
    'https://projet-adcc-image.s3.me-central-1.amazonaws.com/content/1-1781532636129-c5cadcbfd942.jfif',
    'https://projet-adcc-image.s3.me-central-1.amazonaws.com/content/2-1781532636663-10091017b61a.jfif',
    'https://projet-adcc-image.s3.me-central-1.amazonaws.com/content/6-1781532638130-147b1aea8e78.jfif',
    'https://projet-adcc-image.s3.me-central-1.amazonaws.com/content/5-1781532637733-ed19f7a77a5c.jfif',
    'https://projet-adcc-image.s3.me-central-1.amazonaws.com/content/4-1781532637356-e8cb3e82b340.jfif',
    'https://projet-adcc-image.s3.me-central-1.amazonaws.com/content/3-1781532637019-37f4ba925dc4.jfif',
    'https://projet-adcc-image.s3.me-central-1.amazonaws.com/content/7-1781532638497-a41b59dfcca5.jfif',
    'https://projet-adcc-image.s3.me-central-1.amazonaws.com/content/8-1781532640629-601900e00d2f.jfif',
  ];

  String _derivedCategory(Event e) {
    final text =
        '${e.category ?? ''} ${e.title} ${e.description ?? ''} ${e.city ?? ''}'
            .toLowerCase();

    bool hasAny(List<String> words) => words.any(text.contains);

    if (hasAny(['race', 'racing', 'series', 'competition', 'championship'])) {
      return 'Races';
    }
    if (hasAny(['training', 'clinic', 'coaching', 'workshop', 'session'])) {
      return 'Training & Clinics';
    }
    if (hasAny(['awareness', 'cause', 'charity', 'campaign', 'fundraiser'])) {
      return 'Awareness Rides';
    }
    if (hasAny(['family', 'kid', 'kids', 'children', 'youth', 'junior'])) {
      return 'Family & Kids';
    }
    if (hasAny([
      'corporate',
      'company',
      'business',
      'enterprise',
      'team building',
      'teambuilding',
    ])) {
      return 'Corporate';
    }
    if (hasAny(['community', 'ride', 'social', 'group ride', 'club ride'])) {
      return 'Community Rides';
    }
    return 'Community Rides';
  }

  List<Event> get _purposeBasedEventsDynamic {
    final filtered = _events.where((e) => e.isPurposeBased == true).toList();
    return filtered.isNotEmpty ? filtered : const <Event>[];
  }

  List<Event> get _filteredEvents {
    List<Event> list = _events;
    if (selectedCategoryIndex != 0) {
      final categoryIndex = selectedCategoryIndex - 1; // skip 'All'
      final matchables = <String>{};
      if (categoryIndex >= 0 && categoryIndex < _categoryLookups.length) {
        final lookup = _categoryLookups[categoryIndex];
        matchables.add(lookup.value.toLowerCase());
        matchables.add(lookup.label.toLowerCase());
        if (lookup.labelAr.isNotEmpty) {
          matchables.add(lookup.labelAr.toLowerCase());
        }
      }
      // Fall back to the plain English value (e.g. before lookups load).
      final selected = _categoryValues[selectedCategoryIndex].toLowerCase();
      matchables.add(selected);

      list = list.where((e) {
        final cat = (e.derivedCategory ?? _derivedCategory(e)).toLowerCase();
        return matchables.any((m) => cat == m || cat.contains(m));
      }).toList();
    }
    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.trim().toLowerCase();
      list = list
          .where((e) =>
              e.title.toLowerCase().contains(q) ||
              (e.description ?? '').toLowerCase().contains(q) ||
              (e.address ?? '').toLowerCase().contains(q))
          .toList();
    }
    return list;
  }

  @override
  void initState() {
    super.initState();
    _loadEvents();
    _loadCategories();
  }

  /// Loads event category display labels from the dashboard-managed lookup
  /// service (localized). Backing English values are preserved for filtering.
  Future<void> _loadCategories() async {
    try {
      final lookups = await LookupService.instance
          .getLookups(ApiEndpoints.lookupTypeEventCategory);
      final locale = await LanguageStorageService.getLocaleCode();
      if (!mounted) return;
      setState(() {
        _categoryLookups = lookups;
        _categoryValues = [
          'All',
          ...lookups.map((item) => item.value),
        ];
        categories = [
          'All',
          ...lookups.map((item) => item.displayFor(locale)),
        ];
      });
    } catch (_) {
      // Fall back to the localized defaults if the lookup call fails.
      final l10n = AppLocalizations.of(context);
      setState(() {
        categories = [
          'All',
          l10n?.categoryRacing ?? 'Races',
          l10n?.communityRides ?? 'Community Rides',
          l10n?.trainingClinics ?? 'Training & Clinics',
          l10n?.awarenessRides ?? 'Awareness Rides',
          l10n?.familyAndKids ?? 'Family & Kids',
          l10n?.corporateEvents ?? 'Corporate',
        ];
        _categoryValues = [
          'All',
          'Races',
          'Community Rides',
          'Training & Clinics',
          'Awareness Rides',
          'Family & Kids',
          'Corporate',
        ];
      });
    }
  }

  Future<void> _loadEvents() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    final response = await _eventsService.getEvents();
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      if (response.success &&
          response.data != null &&
          response.data!.isNotEmpty) {
        _events = response.data!;
      } else {
        _errorMessage = response.message ??
            AppLocalizations.of(context)!.failedToLoadEvents;
        _events = [];
      }
    });
  }

  String _getImagePath(Event event) {
    if (event.mainImage != null && event.mainImage!.isNotEmpty) {
      return event.mainImage!;
    }
    return 'assets/images/ride_events.png';
  }

  String _formatParticipants(Event event) => '${event.currentParticipants ?? 0}'
      '${event.maxParticipants != null ? '/${event.maxParticipants}' : ''}'
      ' ${AppLocalizations.of(context)!.riders_suffix}';

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final eventsToShow = _filteredEvents;
    final purposeEvents = _purposeBasedEventsDynamic;

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: CachedNetworkImageProvider(EventsImgs.eventBackground),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : (_errorMessage != null && eventsToShow.isEmpty)
                    ? _buildErrorState()
                    : _buildContent(eventsToShow, purposeEvents),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            _errorMessage!,
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadEvents,
            child: Text(AppLocalizations.of(context)!.retry),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(List<Event> eventsToShow, List<Event> purposeEvents) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        // ── Top section (header + search + categories) ──────────────────
        _EventsTopSection(
          title: AppLocalizations.of(context)!.eventsTab,
          searchValue: _searchQuery,
          onSearchChanged: (v) => setState(() => _searchQuery = v),
          categories: categories,
          selectedIndex: selectedCategoryIndex,
          onCategorySelected: (i) => setState(
              () => selectedCategoryIndex = selectedCategoryIndex == i ? 0 : i),
          categoryLookups: _categoryLookups,
        ),

        const SizedBox(height: 53),

        // ── Upcoming Events ─────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SectionHeader(
            title: AppLocalizations.of(context)!.upcomingEvents,
            onViewAll: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    EventsByCategoryViewAll(events: _filteredEvents),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        eventsToShow.isEmpty
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.noEventsAvailable,
                    style:
                        const TextStyle(color: Color(0xFF888888), fontSize: 15),
                  ),
                ),
              )
            : SizedBox(
                height: 319,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: eventsToShow.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (context, i) {
                    final event = eventsToShow[i];
                    return SpecialRideCard(
                      imagePath: _getImagePath(event),
                      title: event.title,
                      date: event.formattedDate ??
                          AppLocalizations.of(context)!.event_badge_tbd,
                      time: event.eventTime,
                      distance: event.additionalData?['distance']?.toString() ??
                          event.additionalData?['routeDistance']?.toString() ??
                          event.distance?.toString(),
                      location: event.address,
                      city: event.city,
                      venue: (event.additionalData?['trackName'] ??
                                  event.additionalData?['venue'] ??
                                  event.additionalData?['circuit'] ??
                                  (event.additionalData?['track'] is Map
                                      ? (event.additionalData?['track']
                                                  ['title'] ??
                                              event.additionalData?['track']
                                                  ['name'] ??
                                              event.additionalData?['track']
                                                  ['titleAr'] ??
                                              event.additionalData?['track']
                                                  ['nameAr'])
                                      : null))
                              ?.toString() ??
                          AppLocalizations.of(context)!.various_tracks,
                      riders: _formatParticipants(event),
                      eventType:
                          event.derivedCategory ?? _derivedCategory(event),
                      groupName: event.createdBy?['name']?.toString() ??
                          event.createdBy?['groupName']?.toString(),
                      eventId: event.id,
                      width: 358,
                      onShare: () {
                        ShareHelper.share(
                          context,
                          ShareHelper.event(event.title, event.id,
                              AppLocalizations.of(context)!),
                          subject:
                              AppLocalizations.of(context)!.share_event_subject,
                        );
                      },
                      onOpen: () {
                        if (event.id.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  EventDetailsScreen(eventId: event.id),
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
              ),

        const SizedBox(height: 34),

        // ── Purpose Based Events ────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SectionHeader(
            title: AppLocalizations.of(context)!.purposeBasedEvents,
            onViewAll: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PurposeBasedEventsViewAllScreen(
                  events: purposeEvents,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 275,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: purposeEvents.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, i) {
              final event = purposeEvents[i];
              return PurposeBasedEventCard(
                imagePath: _getImagePath(event),
                title: event.title,
                date: event.formattedDate ??
                    AppLocalizations.of(context)!.event_badge_tbd,
                groupName: event.createdBy?['name']?.toString() ??
                    event.createdBy?['groupName']?.toString() ??
                    AppLocalizations.of(context)!.eventsTab,
                onTap: () {
                  if (event.id.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EventDetailsScreen(eventId: event.id),
                      ),
                    );
                  }
                },
              );
            },
          ),
        ),

        const SizedBox(height: 94),
      ],
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Top Section
// ────────────────────────────────────────────────────────────────────────────

class _EventsTopSection extends StatefulWidget {
  final String title;
  final String searchValue;
  final ValueChanged<String> onSearchChanged;
  final List<String> categories;
  final int selectedIndex;
  final ValueChanged<int> onCategorySelected;
  final List<LookupModel> categoryLookups;

  const _EventsTopSection({
    required this.title,
    required this.searchValue,
    required this.onSearchChanged,
    required this.categories,
    required this.selectedIndex,
    required this.onCategorySelected,
    required this.categoryLookups,
  });

  @override
  State<_EventsTopSection> createState() => _EventsTopSectionState();
}

class _EventsTopSectionState extends State<_EventsTopSection> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.searchValue);
  }

  @override
  void didUpdateWidget(covariant _EventsTopSection old) {
    super.didUpdateWidget(old);
    if (old.searchValue != widget.searchValue &&
        _controller.text != widget.searchValue) {
      _controller.text = widget.searchValue;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 417,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 349,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: CachedNetworkImageProvider(
                  EventsImgs.eventheaderbackground,
                ),
                fit: BoxFit.cover,
              ),
              // gradient: LinearGradient(
              //   begin: Alignment.topCenter,
              //   end: Alignment.bottomCenter,
              //   stops: [0.0, 0.8362, 1.0],
              //   colors: [
              //     Color(0xFF1B1A6E),
              //     Color(0xFF1B1A6E),
              //     Colors.white,
              //   ],
              // ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            top: 182,
            child: SizedBox(
              height: 48,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Align(
                  //   alignment: Alignment.centerLeft,
                  //   child: IconButton(
                  //     visualDensity: VisualDensity.compact,
                  //     padding: EdgeInsets.zero,
                  //     onPressed: () {
                  //       if (Navigator.canPop(context)) {
                  //         Navigator.pop(context);
                  //       }
                  //     },
                  //     icon: const Icon(
                  //       Icons.arrow_back,
                  //       color: Colors.white,
                  //       size: 24,
                  //     ),
                  //   ),
                  // ),
                  // TODO: Temporarily disable back arrow navigation. Re-enable when required.

                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      height: 1.25,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            top: 230,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  height: 38,
                  padding: const EdgeInsets.fromLTRB(11, 7, 12, 7),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.21),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.28),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.search_rounded,
                          size: 15,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          onChanged: widget.onSearchChanged,
                          cursorColor: Colors.white,
                          style: const TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)!.searchHint,
                            hintStyle: const TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                            border: InputBorder.none,
                            isCollapsed: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            top: 286,
            child: Container(
              height: 156,
              padding: const EdgeInsets.fromLTRB(12, 16, 12, 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFf5edff),
                  width: 1.16,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1A000000),
                    offset: Offset(0, 1),
                    blurRadius: 3,
                  ),
                ],
              ),
              child: _CategoryGrid(
                categories: widget.categories,
                selectedIndex: widget.selectedIndex,
                onSelected: widget.onCategorySelected,
                categoryLookups: widget.categoryLookups,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Category rail
// ────────────────────────────────────────────────────────────────────────────

class _CategoryGrid extends StatelessWidget {
  final List<String> categories;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final List<LookupModel> categoryLookups;

  const _CategoryGrid({
    required this.categories,
    required this.selectedIndex,
    required this.onSelected,
    required this.categoryLookups,
  });

  String _labelFor(BuildContext context, String category) {
    // Categories now come from the dashboard-managed lookup service already
    // localized (en/ar). Fall back to the l10n map for the hardcoded defaults
    // used before the lookup data loads.
    final l10n = AppLocalizations.of(context)!;
    return switch (category) {
      'Awareness Rides' => l10n.awarenessRides,
      'Training & Clinics' => l10n.trainingClinics,
      'Community Rides' => l10n.communityRides,
      'Family & Kids' => l10n.familyAndKids,
      _ => category,
    };
  }

  /// Prefer the dashboard-managed lookup `icon` (S3 URL) for this category.
  /// Falls back to the shared fallback images when no icon is uploaded yet.
  String _imageUrlFor(int index) {
    if (index >= 0 && index < categoryLookups.length) {
      final icon = categoryLookups[index].icon;
      if (icon != null && icon.isNotEmpty) return icon;
    }
    const fallbacks = _EventsTabState._fallbackCategoryImages;
    return fallbacks[index % fallbacks.length];
  }

  @override
  Widget build(BuildContext context) {
    final visibleIndices = [
      for (int i = 0; i < categories.length; i++)
        if (categories[i].toLowerCase() != 'all') i,
    ];

    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.zero,
      physics: const BouncingScrollPhysics(),
      itemCount: visibleIndices.length,
      separatorBuilder: (_, __) => const SizedBox(width: 10),
      itemBuilder: (context, index) {
        final categoryIndex = visibleIndices[index];
        final isSelected = categoryIndex == selectedIndex;
        final category = categories[categoryIndex];
        final imageUrl = _imageUrlFor(index);

        return GestureDetector(
          onTap: () => onSelected(categoryIndex),
          child: Container(
            width: 92,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.36),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF0359E8)
                    : const Color(0x803059E8),
                width: 0.61,
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(6),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(7.36),
                    child: SizedBox(
                      width: 80,
                      height: 75,
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 80,
                          height: 75,
                          color: const Color(0xFFE5E7EB),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.image_not_supported,
                            color: Color(0xFF9CA3AF),
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        _labelFor(context, category),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 9,
                          fontWeight: FontWeight.w500,
                          height: 1,
                          color: isSelected
                              ? const Color(0xFF0359E8)
                              : const Color(0x803059E8),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
