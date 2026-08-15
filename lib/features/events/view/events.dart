import 'dart:math';

import 'package:adcc/core/constants/cosmatic_imgs.dart';
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

  final List<String> categories = [
    'All',
    'Races',
    'Community Rides',
    'Training & Clinics',
    'Awareness Rides',
    'Family & Kids',
    'Corporate',
  ];

  // ── Category icons mapping ────────────────────────────────────────────────
  static const Map<String, String> _categoryAssets = {
    'races': 'assets/icons/ra.png',
    'community rides': 'assets/icons/cf.png',
    'training & clinics': 'assets/icons/tc.png',
    'awareness rides': 'assets/icons/awareness.png',
    'family & kids': 'assets/icons/cf.png',
    'corporate': 'assets/icons/tc.png',
    'all': 'assets/icons/add_calendar.png',
  };

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
    const purposeKeywords = [
      'community',
      'charity',
      'cause',
      'family',
      'kids',
    ];
    final filtered = _events.where((e) {
      final text = '${e.title} ${e.description ?? ''}'.toLowerCase();
      return purposeKeywords.any(text.contains);
    }).toList();
    return filtered.isNotEmpty ? filtered : _events;
  }

  List<Event> get _filteredEvents {
    List<Event> list = _events;
    if (selectedCategoryIndex != 0) {
      final selected = categories[selectedCategoryIndex].toLowerCase();
      list = list
          .where((e) => _derivedCategory(e).toLowerCase() == selected)
          .toList();
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
        _errorMessage = response.message ?? 'Failed to load events';
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
      ' riders';

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
          title: 'Events',
          searchValue: _searchQuery,
          onSearchChanged: (v) => setState(() => _searchQuery = v),
          categories: categories,
          selectedIndex: selectedCategoryIndex,
          onCategorySelected: (i) => setState(
              () => selectedCategoryIndex = selectedCategoryIndex == i ? 0 : i),
          categoryAssets: _categoryAssets,
        ),

        const SizedBox(height: 33),

        // ── Upcoming Events ─────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SectionHeader(
            title: 'Upcoming Events',
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
            ? const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Center(
                  child: Text(
                    'No events available',
                    style: TextStyle(color: Color(0xFF888888), fontSize: 15),
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
                      date: event.formattedDate ?? 'TBD',
                      time: event.eventTime,
                      distance: event.additionalData?['distance']?.toString() ??
                          event.additionalData?['routeDistance']?.toString() ??
                          event.distance?.toString(),
                      location: event.address,
                      city: event.city,
                      venue: event.additionalData?['venue']?.toString() ??
                          event.additionalData?['circuit']?.toString(),
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
                          ShareHelper.event(event.title, event.id),
                          subject: 'Check out this event on ADCC',
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
            title: 'Purpose Based Events',
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
                date: event.formattedDate ?? 'TBD',
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
  final Map<String, String> categoryAssets;

  const _EventsTopSection({
    required this.title,
    required this.searchValue,
    required this.onSearchChanged,
    required this.categories,
    required this.selectedIndex,
    required this.onCategorySelected,
    required this.categoryAssets,
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
                            hintText:
                                AppLocalizations.of(context)!.searchHint,
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
              padding: const EdgeInsets.fromLTRB(12, 16, 0, 16),
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
                categoryAssets: widget.categoryAssets,
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
  final Map<String, String> categoryAssets;

  const _CategoryGrid({
    required this.categories,
    required this.selectedIndex,
    required this.onSelected,
    required this.categoryAssets,
  });

  static const List<String> _categoryImageUrls = [
    'https://projet-adcc-image.s3.me-central-1.amazonaws.com/content/1-1781532636129-c5cadcbfd942.jfif',
    'https://projet-adcc-image.s3.me-central-1.amazonaws.com/content/2-1781532636663-10091017b61a.jfif',
    'https://projet-adcc-image.s3.me-central-1.amazonaws.com/content/6-1781532638130-147b1aea8e78.jfif',
    'https://projet-adcc-image.s3.me-central-1.amazonaws.com/content/5-1781532637733-ed19f7a77a5c.jfif',
    'https://projet-adcc-image.s3.me-central-1.amazonaws.com/content/4-1781532637356-e8cb3e82b340.jfif',
    'https://projet-adcc-image.s3.me-central-1.amazonaws.com/content/3-1781532637019-37f4ba925dc4.jfif',
    'https://projet-adcc-image.s3.me-central-1.amazonaws.com/content/7-1781532638497-a41b59dfcca5.jfif',
    'https://projet-adcc-image.s3.me-central-1.amazonaws.com/content/8-1781532640629-601900e00d2f.jfif',
  ];

  String _labelFor(BuildContext context, String category) {
    final l10n = AppLocalizations.of(context)!;
    return switch (category) {
      'Awareness Rides' => l10n.awarenessRides,
      'Training & Clinics' => l10n.trainingClinics,
      'Community Rides' => l10n.communityRides,
      'Family & Kids' => l10n.familyAndKids,
      _ => category,
    };
  }

  String _imageUrlFor(int index) {
    return index < _categoryImageUrls.length
        ? _categoryImageUrls[index]
        : _categoryImageUrls.first;
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
