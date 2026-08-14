import 'package:adcc/l10n/app_localizations.dart';
import 'package:adcc/features/event_details/view/event_details_screen.dart';
import 'package:adcc/features/events/Model/model_events.dart';
import 'package:adcc/features/events/services/events_service.dart';
import 'package:adcc/features/events/view/special_ride_card.dart';
import 'package:adcc/core/utils/share_helper.dart';
import 'package:flutter/material.dart';

class UpcomingEventsViewAll extends StatefulWidget {
  final List<Event> events;

  const UpcomingEventsViewAll({
    super.key,
    this.events = const [],
  });

  @override
  State<UpcomingEventsViewAll> createState() => _UpcomingEventsViewAllState();
}

class _UpcomingEventsViewAllState extends State<UpcomingEventsViewAll> {
  final EventsService _eventsService = EventsService();
  final List<_UpcomingFilter> _filters = const [
    _UpcomingFilter(
      label: 'All',
      window: _UpcomingWindow.all,
      imagePath: 'assets/images/events.png',
    ),
    _UpcomingFilter(
      label: 'This Week',
      window: _UpcomingWindow.week,
      imagePath: 'assets/images/racing.png',
    ),
    _UpcomingFilter(
      label: 'This Month',
      window: _UpcomingWindow.month,
      imagePath: 'assets/images/community_ride.png',
    ),
    _UpcomingFilter(
      label: 'Later',
      window: _UpcomingWindow.later,
      imagePath: 'assets/images/bike_experience.png',
    ),
  ];

  int selectedFilterIndex = 0;
  bool _isLoading = true;
  String? _errorMessage;
  late List<Event> _events;

  @override
  void initState() {
    super.initState();
    _events = _normalizeUpcomingEvents(widget.events);

    if (widget.events.isEmpty) {
      _loadEvents();
    } else {
      _isLoading = false;
    }
  }

  Future<void> _loadEvents() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final response = await _eventsService.getEvents(
      queryParameters: const {'page': 1, 'limit': 100},
    );

    if (!mounted) return;

      setState(() {
      _isLoading = false;
      if (response.success && response.data != null) {
        _events = _normalizeUpcomingEvents(response.data!);
      } else {
        _events = const [];
        _errorMessage = response.message ?? 'failedToLoadUpcomingEvents';
      }
    });
  }

  List<Event> _normalizeUpcomingEvents(List<Event> events) {
    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);

    final normalized = events.where((event) {
      if (_isCompleted(event)) {
        return false;
      }

      final parsedDate = _parseEventDate(event);
      if (parsedDate == null) {
        return true;
      }

      final eventDay =
          DateTime(parsedDate.year, parsedDate.month, parsedDate.day);
      return !eventDay.isBefore(todayStart);
    }).toList();

    normalized.sort((first, second) {
      final firstDate = _parseEventDate(first);
      final secondDate = _parseEventDate(second);

      if (firstDate == null && secondDate == null) return 0;
      if (firstDate == null) return 1;
      if (secondDate == null) return -1;

      return firstDate.compareTo(secondDate);
    });

    return normalized;
  }

  bool _isCompleted(Event event) {
    final status = (event.status ?? '').toLowerCase().trim();
    return status == 'completed' ||
        status == 'complete' ||
        status == 'cancelled' ||
        status == 'canceled' ||
        status == 'closed';
  }

  DateTime? _parseEventDate(Event event) {
    final raw = event.eventDate;
    if (raw == null || raw.trim().isEmpty) {
      return null;
    }

    return DateTime.tryParse(raw);
  }

  List<Event> _filterEvents(List<Event> events) {
    final filter = _filters[selectedFilterIndex].window;
    if (filter == _UpcomingWindow.all) {
      return events;
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final thisWeekEnd = today.add(const Duration(days: 7));
    final thisMonthEnd = DateTime(today.year, today.month + 1, 0);

    return events.where((event) {
      final parsedDate = _parseEventDate(event);
      if (parsedDate == null) {
        return filter == _UpcomingWindow.all;
      }

      final day = DateTime(parsedDate.year, parsedDate.month, parsedDate.day);
      switch (filter) {
        case _UpcomingWindow.week:
          return !day.isBefore(today) && !day.isAfter(thisWeekEnd);
        case _UpcomingWindow.month:
          return !day.isBefore(today) && !day.isAfter(thisMonthEnd);
        case _UpcomingWindow.later:
          return day.isAfter(thisMonthEnd);
        case _UpcomingWindow.all:
          return true;
      }
    }).toList();
  }

  String _getImagePath(Event event) {
    final image = event.mainImage?.trim();
    if (image != null && image.isNotEmpty) {
      return image;
    }

    return 'assets/images/no-img.jpg';
  }

  String _badgeLabel(Event event) {
    final text =
        '${event.category ?? ''} ${event.title} ${event.description ?? ''}'
            .toLowerCase();

    bool hasAny(List<String> words) => words.any(text.contains);

    if (hasAny(['national', 'uae national', 'flag'])) {
      return 'National';
    }
    if (hasAny(['corporate', 'company', 'business', 'team building'])) {
      return 'Corporate';
    }
    if (hasAny(['awareness', 'charity', 'cause', 'fundraiser'])) {
      return 'Awareness';
    }
    if (hasAny(['training', 'clinic', 'coaching', 'workshop'])) {
      return 'Training';
    }
    if (hasAny(['race', 'racing', 'competition', 'championship'])) {
      return 'Race';
    }
    return 'Community Ride';
  }

  String _participantsText(Event event) {
    final participants = event.currentParticipants ?? 0;
    final maxParticipants = event.maxParticipants;
    if (maxParticipants == null) {
      return '$participants riders';
    }

    return '$participants/$maxParticipants riders';
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
    final visibleEvents = _filterEvents(_events);

    return Scaffold(
      backgroundColor: const Color(0xFFF5EDFF),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 34),
                children: [
                  const _UpcomingEventsHero(),
                  const SizedBox(height: 30),
                  _UpcomingFilterRail(
                    filters: _filters,
                    selectedIndex: selectedFilterIndex,
                    onSelected: (index) {
                      setState(() => selectedFilterIndex = index);
                    },
                  ),
                  const SizedBox(height: 27),
                  Text(
                    () {
                      final window = _filters[selectedFilterIndex].window;
                      final l = AppLocalizations.of(context)!;
                      switch (window) {
                        case _UpcomingWindow.all:
                          return l.filterAll;
                        case _UpcomingWindow.week:
                          return l.filterThisWeek;
                        case _UpcomingWindow.month:
                          return l.filterThisMonth;
                        case _UpcomingWindow.later:
                          return l.filterLater;
                      }
                    }(),
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      height: 1.25,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 17),
                  if (_errorMessage != null && visibleEvents.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 80),
                      child: Center(
                        child: Column(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.failedToLoadUpcomingEvents,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF6B6B6B),
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _loadEvents,
                              child: Text(AppLocalizations.of(context)!.retry),
                            ),
                          ],
                        ),
                      ),
                    )
                  else if (visibleEvents.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 80),
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.noUpcomingEvents,
                          style: const TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF6B6B6B),
                          ),
                        ),
                      ),
                    )
                  else
                    ...List.generate(visibleEvents.length, (index) {
                      final event = visibleEvents[index];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 25),
                        child: SpecialRideCard(
                          imagePath: _getImagePath(event),
                          title: event.title,
                          date: event.formattedDate ?? 'TBD',
                          time: event.eventTime,
                          distance:
                              event.additionalData?['distance']?.toString() ??
                                  event.additionalData?['routeDistance']
                                      ?.toString() ??
                                  event.distance?.toString(),
                          location: event.address,
                          city: event.city,
                          venue: event.additionalData?['venue']?.toString() ??
                              event.additionalData?['circuit']?.toString(),
                          riders: _participantsText(event),
                          eventType:
                              event.derivedCategory ?? _badgeLabel(event),
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
    );
  }
}

enum _UpcomingWindow { all, week, month, later }

class _UpcomingFilter {
  final String label;
  final _UpcomingWindow window;
  final String imagePath;

  const _UpcomingFilter({
    required this.label,
    required this.window,
    required this.imagePath,
  });
}

class _UpcomingEventsHero extends StatelessWidget {
  const _UpcomingEventsHero();

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
              'assets/images/no-img.jpg',
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
                AppLocalizations.of(context)!.upcomingEvents,
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 20.11,
                  fontWeight: FontWeight.w600,
                  height: 1.1,
                  color: Colors.white,
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 28,
              child: Text(
                AppLocalizations.of(context)!.upcomingEventsSubtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
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

class _UpcomingFilterRail extends StatelessWidget {
  final List<_UpcomingFilter> filters;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const _UpcomingFilterRail({
    required this.filters,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 118,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 6),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final selected = selectedIndex == index;

          return GestureDetector(
            onTap: () => onSelected(index),
            child: SizedBox(
              width: 82,
              child: Column(
                children: [
                  Container(
                    width: 82,
                    height: 82,
                    decoration: BoxDecoration(
                      color: selected
                          ? const Color(0xFF1B1A6E)
                          : const Color(0xFFE6E0F7),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: selected
                          ? [
                              BoxShadow(
                                color: const Color(0xFF1B1A6E)
                                    .withValues(alpha: 0.2),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : null,
                    ),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              filter.imagePath,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                color: selected
                                    ? const Color(0xFF1B1A6E)
                                    : const Color(0xFFE6E0F7),
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.event_available,
                                  color: selected
                                      ? Colors.white
                                      : const Color(0xFF1B1A6E),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: selected
                                  ? Colors.black.withValues(alpha: 0.12)
                                  : Colors.white.withValues(alpha: 0.02),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 8,
                          right: 8,
                          bottom: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: selected
                                  ? Colors.white.withValues(alpha: 0.92)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              () {
                                final l = AppLocalizations.of(context)!;
                                switch (filter.window) {
                                  case _UpcomingWindow.all:
                                    return l.filterAll;
                                  case _UpcomingWindow.week:
                                    return l.filterThisWeek;
                                  case _UpcomingWindow.month:
                                    return l.filterThisMonth;
                                  case _UpcomingWindow.later:
                                    return l.filterLater;
                                }
                              }(),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                height: 1.1,
                                color: selected
                                    ? const Color(0xFF1B1A6E)
                                    : const Color(0xFF333333),
                              ),
                            ),
                          ),
                        ),
                      ],
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
