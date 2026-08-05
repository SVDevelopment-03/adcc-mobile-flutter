import 'dart:math';

import 'package:adcc/core/constants/cosmatic_imgs.dart';
import 'package:adcc/features/event_details/view/event_details_screen.dart';
import 'package:adcc/features/events/Model/model_events.dart';
import 'package:adcc/features/events/view/special_ride_card.dart';
import 'package:adcc/core/utils/share_helper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class EventsByCategoryViewAll extends StatefulWidget {
  final List<Event> events;
  final String? initialCategory;

  const EventsByCategoryViewAll({
    super.key,
    required this.events,
    this.initialCategory,
  });

  @override
  State<EventsByCategoryViewAll> createState() =>
      _EventsByCategoryViewAllState();
}

class _EventsByCategoryViewAllState extends State<EventsByCategoryViewAll> {
  int selectedCategoryIndex = -1; // -1 means "All / Upcoming Events"

  final List<_EventCategoryFilter> categories = const [
    _EventCategoryFilter(
      label: 'Races',
      filter: 'Races',
      imagePath: 'assets/images/racing.png',
    ),
    _EventCategoryFilter(
      label: 'Community\nRides',
      filter: 'Community Rides',
      imagePath: 'assets/images/community_ride.png',
    ),
    _EventCategoryFilter(
      label: 'Training &\nClinics',
      filter: 'Training & Clinics',
      imagePath: 'assets/images/bike_experience.png',
    ),
    _EventCategoryFilter(
      label: 'Awareness\nRides',
      filter: 'Awareness Rides',
      imagePath: 'assets/images/community_ride.png',
    ),
    _EventCategoryFilter(
      label: 'Corporate\nEvents',
      filter: 'Corporate Events',
      imagePath: 'assets/images/no-img.jpg',
    ),
    _EventCategoryFilter(
      label: 'National\nEvents',
      filter: 'National Events',
      imagePath: 'assets/images/events.png',
    ),
  ];

  @override
  void initState() {
    super.initState();

    final initial = widget.initialCategory?.toLowerCase().trim();
    if (initial == null || initial.isEmpty) return;

    final index = categories.indexWhere((category) {
      final filter = category.filter.toLowerCase();
      final label = category.label.replaceAll('\n', ' ').toLowerCase();
      return filter == initial || label == initial || filter.contains(initial);
    });

    if (index != -1) selectedCategoryIndex = index;
  }

  String _getImagePath(Event event) {
    final image = event.mainImage;
    if (image != null && image.isNotEmpty) return image;
    return 'assets/images/no-img.jpg';
  }

  String _formatParticipants(Event event) {
    return '${event.currentParticipants ?? 0}'
        '${event.maxParticipants != null ? '/${event.maxParticipants}' : ''}'
        ' riders';
  }

  String _derivedCategory(Event event) {
    final text = '${event.category ?? ''} ${event.derivedCategory ?? ''} '
            '${event.title} ${event.description ?? ''} ${event.city ?? ''}'
        .toLowerCase();

    bool hasAny(List<String> words) => words.any(text.contains);

    if (hasAny(['national', 'uae national', 'flag'])) {
      return 'National Events';
    }
    if (hasAny([
      'corporate',
      'company',
      'business',
      'enterprise',
      'team building',
      'teambuilding',
    ])) {
      return 'Corporate Events';
    }
    if (hasAny(['awareness', 'cause', 'charity', 'campaign', 'fundraiser'])) {
      return 'Awareness Rides';
    }
    if (hasAny(['training', 'clinic', 'coaching', 'workshop', 'session'])) {
      return 'Training & Clinics';
    }
    if (hasAny(['race', 'racing', 'series', 'competition', 'championship'])) {
      return 'Races';
    }
    return 'Community Rides';
  }

  String _badgeLabel(Event event) {
    switch (_derivedCategory(event)) {
      case 'Races':
        return 'Race';
      case 'Community Rides':
        return 'Community Ride';
      case 'Awareness Rides':
        return 'Awareness';
      case 'Training & Clinics':
        return 'Community Ride';
      case 'Corporate Events':
        return 'Corporate';
      case 'National Events':
        return 'National';
      default:
        return _derivedCategory(event);
    }
  }

  List<Event> get _filteredEvents {
    if (widget.events.isEmpty) return const [];

    // If no category selected (-1) return all upcoming events passed to this
    // view. Otherwise filter by the selected category.
    if (selectedCategoryIndex == -1) return widget.events;

    final selected = categories[selectedCategoryIndex].filter;
    final filtered = widget.events
        .where((event) => _derivedCategory(event) == selected)
        .toList();

    return filtered.isNotEmpty ? filtered : widget.events.take(1).toList();
  }

  void _openEvent(Event event) {
    if (event.id.isEmpty) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EventDetailsScreen(eventId: event.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final list = _filteredEvents;
    final selectedCategory = selectedCategoryIndex == -1
        ? 'Upcoming Events'
        : categories[selectedCategoryIndex].filter;

    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: CachedNetworkImageProvider(EventsImgs.eventBackground),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 34),
          children: [
            _EventsByCategoryHero(
              title: selectedCategoryIndex == -1
                  ? 'Upcoming Events'
                  : 'Events by Category',
            ),
            const SizedBox(height: 30),
            _EventCategoryRail(
              categories: categories,
              selectedIndex: selectedCategoryIndex,
              onSelected: (index) {
                setState(() {
                  // toggle selection: tap again to go back to "All"
                  selectedCategoryIndex =
                      selectedCategoryIndex == index ? -1 : index;
                });
              },
            ),
            const SizedBox(height: 27),
            Text(
              selectedCategory,
              style: const TextStyle(
                fontFamily: 'Outfit',
                fontSize: 15,
                fontWeight: FontWeight.w500,
                height: 1.25,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 17),
            if (list.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 80),
                child: Center(
                  child: Text(
                    'No events found',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6B6B6B),
                    ),
                  ),
                ),
              )
            else
              ...List.generate(list.length, (index) {
                final event = list[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: SpecialRideCard(
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
                    eventType: _badgeLabel(event),
                    groupName: event.createdBy?['name']?.toString() ??
                        event.createdBy?['groupName']?.toString(),
                    eventId: event.id,
                    width: double.infinity,
                    badgeColor: const Color(0xFF1B1A6E),
                    badgeTextColor: const Color(0xFFFFF4E3),
                    shareBackgroundColor: const Color(0xFF1B1A6E),
                    shareIconColor: Colors.white,
                    onShare: () {
                      ShareHelper.share(
                        context,
                        ShareHelper.event(event.title, event.id),
                        subject: 'Check out this event on ADCC',
                      );
                    },
                    onOpen: () => _openEvent(event),
                    onTap: () => _openEvent(event),
                  ),
                );
              }),
          ],
        ),
      ),
    ),);
  }
}

class _EventsByCategoryHero extends StatelessWidget {
  final String title;

  const _EventsByCategoryHero({required this.title});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 299,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/upcoming-event-bg.png',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: const Color(0xFFF7BCBC),
                alignment: Alignment.center,
                child: const Icon(Icons.image, color: Colors.black38),
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0),
                      Colors.black.withValues(alpha: 0.12),
                      Colors.black,
                    ],
                    stops: const [0, 0.72, 1],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 19,
              top: 18,
              child: InkWell(
                onTap: () => Navigator.pop(context),
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  width: 35,
                  height: 35,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Color(0xFF1B1A6E),
                    size: 18,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 45,
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 20.11,
                  fontWeight: FontWeight.w600,
                  height: 1.1,
                  color: Colors.white,
                ),
              ),
            ),
            const Positioned(
              left: 16,
              right: 16,
              bottom: 28,
              child: Text(
                'Competitive cycling events organized by ADCC communities',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  height: 1.33,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EventCategoryFilter {
  final String label;
  final String filter;
  final String imagePath;

  const _EventCategoryFilter({
    required this.label,
    required this.filter,
    required this.imagePath,
  });
}

class _EventCategoryRail extends StatelessWidget {
  final List<_EventCategoryFilter> categories;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  static const List<String> _categoryImageUrls = [
    'https://projet-adcc-image.s3.me-central-1.amazonaws.com/content/1-1781532636129-c5cadcbfd942.jfif',
    'https://projet-adcc-image.s3.me-central-1.amazonaws.com/content/2-1781532636663-10091017b61a.jfif',
    'https://projet-adcc-image.s3.me-central-1.amazonaws.com/content/6-1781532638130-147b1aea8e78.jfif',
    'https://projet-adcc-image.s3.me-central-1.amazonaws.com/content/5-1781532637733-ed19f7a77a5c.jfif',
    'https://projet-adcc-image.s3.me-central-1.amazonaws.com/content/4-1781532637356-e8cb3e82b340.jfif',
    'https://projet-adcc-image.s3.me-central-1.amazonaws.com/content/3-1781532637019-37f4ba925dc4.jfif',
    'https://projet-adcc-image.s3.me-central-1.amazonaws.com/content/7-1781532638497-a41b59dfcca5.jfif',
    'https://projet-adcc-image.s3.me-central-1.amazonaws.com/content/12-1781532644463-56ba5130bf39.jfif',
    'https://projet-adcc-image.s3.me-central-1.amazonaws.com/content/10-1781532643582-cd6b24554f61.jfif',
    'https://projet-adcc-image.s3.me-central-1.amazonaws.com/content/11-1781532644058-49ff207e67ad.jfif',
  ];

  const _EventCategoryRail({
    required this.categories,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final category = categories[index];
          final selected = selectedIndex == index;
          final imageUrl =
              _categoryImageUrls[index % _categoryImageUrls.length];

          return GestureDetector(
            onTap: () => onSelected(index),
            child: Container(
              width: 92,
              decoration: BoxDecoration(
                color: Color(0xFFE8E6FB),
                borderRadius: BorderRadius.circular(10.36),
                border: Border.all(
                  color: selected
                      ? const Color(0xFF381D8C)
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
                      child: Text(
                        category.label,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          height: 1,
                          color:  Color(0xff333333),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
