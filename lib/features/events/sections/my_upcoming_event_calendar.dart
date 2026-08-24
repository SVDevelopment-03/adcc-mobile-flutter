import 'package:adcc/features/event_details/view/event_details_screen.dart';
import 'package:adcc/features/events/Model/model_events.dart';
import 'package:adcc/features/profile/models/profile_history_models.dart';
import 'package:adcc/features/profile/repositories/profile_repository.dart';
import 'package:adcc/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyUpcomingeventfrom extends StatefulWidget {
  final List<Event> events;

  const MyUpcomingeventfrom({
    super.key,
    required this.events,
  });

  @override
  State<MyUpcomingeventfrom> createState() => _MyUpcomingeventfromState();
}

class _MyUpcomingeventfromState extends State<MyUpcomingeventfrom> {
  int selectedDateIndex = 0;
  final ProfileRepository _profileRepository = ProfileRepository();
  bool _isLoading = false;
  String? _errorMessage;
  late List<Event> _events;

  @override
  void initState() {
    super.initState();
    _events = const [];
    _loadJoinedEvents();
  }

  Event _toEvent(ProfileUpcomingEventItem item) {
    return Event(
      id: item.id,
      title: item.title,
      eventDate: item.date,
      mainImage: item.image,
      distance: int.tryParse(item.distance.replaceAll(RegExp(r'[^0-9.]'), '')),
      currentParticipants: null,
      maxParticipants: null,
      status: 'joined',
      additionalData: const {},
    );
  }

  List<Event> _normalizeUpcomingEvents(List<Event> events) {
    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);

    final normalized = events.where((event) {
      final d = _parseEventDate(event);
      if (d == null) return true;
      final eventDay = DateTime(d.year, d.month, d.day);
      return !eventDay.isBefore(todayStart);
    }).toList();

    normalized.sort((a, b) {
      final ad = _parseEventDate(a);
      final bd = _parseEventDate(b);
      if (ad == null && bd == null) return 0;
      if (ad == null) return 1;
      if (bd == null) return -1;
      return ad.compareTo(bd);
    });

    return normalized;
  }

  Future<void> _loadJoinedEvents() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final joined = await _profileRepository.fetchActiveParticipations();

      if (!mounted) return;

      setState(() {
        _events = _normalizeUpcomingEvents(joined.map(_toEvent).toList());
        _isLoading = false;
      });
      } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'failedToLoadJoinedEvents';
      });
    }
  }

  List<_ScheduleDate> _buildScheduleDates(List<Event> events) {
    const windowSize = 90; // roughly three months of dates
    final today = DateTime.now();

    final days = List<DateTime>.generate(
      windowSize,
      (i) => DateTime(today.year, today.month, today.day + i),
    );

    for (final event in events) {
      final date = _parseEventDate(event);
      if (date == null) continue;
      final normalized = DateTime(date.year, date.month, date.day);
      final exists = days.any((d) => _isSameDay(d, normalized));
      if (!exists) days.add(normalized);
    }

    days.sort((a, b) => a.compareTo(b));

    final unique = <DateTime>[];
    for (final d in days) {
      if (!unique.any((u) => _isSameDay(u, d))) unique.add(d);
    }

    return unique.map(_ScheduleDate.fromDate).toList();
  }

  DateTime? _parseEventDate(Event event) {
    final raw = event.eventDate;
    if (raw == null || raw.trim().isEmpty) {
      return null;
    }

    return DateTime.tryParse(raw);
  }

  bool _isSameDay(DateTime first, DateTime second) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }

  List<Event> _eventsForDate(List<Event> events, DateTime selectedDate) {
    final hasParsableDates =
        events.any((event) => _parseEventDate(event) != null);
    if (!hasParsableDates) {
      return events;
    }

    return events.where((event) {
      final date = _parseEventDate(event);
      if (date == null) {
        return true;
      }
      return _isSameDay(date, selectedDate);
    }).toList();
  }

  String _imagePath(Event event) {
    final image = event.mainImage?.trim();
    if (image != null && image.isNotEmpty) {
      return image;
    }
    return 'assets/images/no-img.jpg';
  }

  String _badgeLabel(Event event) {
    final l = AppLocalizations.of(context)!;
    final text =
        '${event.category ?? ''} ${event.title} ${event.description ?? ''}'
            .toLowerCase();

    bool hasAny(List<String> words) => words.any(text.contains);

    if (hasAny(['national', 'uae national', 'flag'])) {
      return l.event_badge_national;
    }
    if (hasAny(['corporate', 'company', 'business', 'team building'])) {
      return l.event_badge_corporate;
    }
    if (hasAny(['awareness', 'charity', 'cause', 'fundraiser'])) {
      return l.event_badge_awareness;
    }
    if (hasAny(['training', 'clinic', 'coaching', 'workshop'])) {
      return l.event_badge_training;
    }
    if (hasAny(['race', 'racing', 'competition', 'championship'])) {
      return l.event_badge_race;
    }
    return l.event_badge_community_ride;
  }

  String _participantsText(Event event) {
    final l = AppLocalizations.of(context)!;
    final participants = event.currentParticipants ?? 0;
    final maxParticipants = event.maxParticipants;
    if (maxParticipants == null) {
      return '$participants ${l.riders_suffix}';
    }
    return '$participants/$maxParticipants ${l.riders_suffix}';
  }

  void _openEvent(Event event) {
    if (event.id.isEmpty) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EventDetailsScreen(eventId: event.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheduleDates = _buildScheduleDates(_events);
    final safeSelectedIndex = scheduleDates.isEmpty
        ? 0
        : selectedDateIndex.clamp(0, scheduleDates.length - 1);
    final selectedDate = scheduleDates.isEmpty
        ? DateTime.now()
        : scheduleDates[safeSelectedIndex].date;
    final filteredEvents = _eventsForDate(_events, selectedDate);

    return Scaffold(
      backgroundColor: const Color(0xFFF5EDFF),
      body: SafeArea(
        top: false,
        bottom: false,
        child: Stack(
          children: [
            Positioned.fill(
              child: Column(
                children: [
                  Container(
                    height: 220,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFFF6A400), Color(0xFFE89400)],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Positioned.fill(
              child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(top: 180, bottom: 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _DateSelectorCard(
                          dates: scheduleDates,
                          selectedIndex: safeSelectedIndex,
                          onSelected: (index) {
                            setState(() => selectedDateIndex = index);
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          AppLocalizations.of(context)!.upcomingEvents,
                          style: const TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF343434),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (_isLoading && _events.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 48),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      else if (_errorMessage != null && _events.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              Text(
                                AppLocalizations.of(context)!.failedToLoadJoinedEvents,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontFamily: 'Outfit',
                                  fontSize: 13,
                                  color: Color(0xFF8A8A8A),
                                ),
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: _loadJoinedEvents,
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: const Color(0xFFF5A400),
                                  foregroundColor: Colors.white,
                                ),
                                child: Text(AppLocalizations.of(context)!.retry),
                              ),
                            ],
                          ),
                        )
                      else if (filteredEvents.isEmpty)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context)!.noUpcomingEvents,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF8A8A8A),
                              ),
                            ),
                          ),
                        )
                      else
                        SizedBox(
                          height: 380,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: filteredEvents.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 12),
                            itemBuilder: (context, index) {
                              final event = filteredEvents[index];
                              return _UpcomingEventCard(
                                event: event,
                                imagePath: _imagePath(event),
                                badgeText: _badgeLabel(event),
                                dateText: event.formattedDate ?? AppLocalizations.of(context)!.event_badge_tbd,
                                timeText: event.eventTime ?? AppLocalizations.of(context)!.event_badge_tbd,
                                locationText:
                                    event.address?.trim().isNotEmpty == true
                                        ? event.address!.trim()
                                        : (event.city?.trim().isNotEmpty == true
                                            ? event.city!.trim()
                                            : AppLocalizations.of(context)!.defaultCity),
                                ridersText: _participantsText(event),
                                onTap: () => _openEvent(event),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            Positioned(
              top: 32,
              left: 0,
              right: 0,
              child: _ScheduleHeader(
                onBack: () {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScheduleHeader extends StatelessWidget {
  final VoidCallback onBack;

  const _ScheduleHeader({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 32, 16, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onBack,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.18),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.22),
                ),
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 12),
                    Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)!.checkYourEventSchedule,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    height: 1.1,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context)!.chooseDateHint,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 36),
        ],
      ),
    );
  }
}

class _UpcomingEventCard extends StatelessWidget {
  final Event event;
  final String imagePath;
  final String badgeText;
  final String dateText;
  final String timeText;
  final String locationText;
  final String ridersText;
  final VoidCallback onTap;

  const _UpcomingEventCard({
    required this.event,
    required this.imagePath,
    required this.badgeText,
    required this.dateText,
    required this.timeText,
    required this.locationText,
    required this.ridersText,
    required this.onTap,
  });

  bool get _isNetworkImage =>
      imagePath.startsWith('http://') || imagePath.startsWith('https://');

  Widget _buildImage() {
    if (_isNetworkImage) {
      return Image.network(
        imagePath,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (_, __, ___) => _imageFallback(),
        loadingBuilder: (context, child, progress) {
          if (progress == null) {
            return child;
          }
          return Container(
            color: const Color(0xFFEAEAEA),
            alignment: Alignment.center,
            child: const CircularProgressIndicator(strokeWidth: 2),
          );
        },
      );
    }

    return Image.asset(
      imagePath,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (_, __, ___) => _imageFallback(),
    );
  }

  Widget _imageFallback() {
    return Container(
      color: const Color(0xFFE8E1D4),
      alignment: Alignment.center,
      child: const Icon(Icons.directions_bike, size: 46, color: Colors.black38),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 15, color: const Color(0xFF505050)),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xFF3F3F3F),
            ),
          ),
        ),
      ],
    );
  }

  Widget _avatarDot(Color color) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 1.6),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color, color.withValues(alpha: 0.65)],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 275,
        decoration: BoxDecoration(
          color: const Color(0xFFF4E3C8),
          borderRadius: BorderRadius.circular(22),
          boxShadow: const [
            BoxShadow(
              color: Color(0x18000000),
              blurRadius: 18,
              offset: Offset(0, 8),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 7,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _buildImage(),
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.04),
                              Colors.black.withValues(alpha: 0.08),
                              Colors.black.withValues(alpha: 0.68),
                            ],
                            stops: const [0, 0.58, 1],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 14,
                      top: 14,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color:
                              const Color(0xFFF0E0C1).withValues(alpha: 0.94),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          badgeText,
                          style: const TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF202020),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 14,
                      right: 14,
                      bottom: 14,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            event.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              height: 1.1,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            locationText,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFFF5F5F5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _infoRow(Icons.calendar_today_rounded, dateText),
                    _infoRow(Icons.access_time_rounded, timeText),
                    _infoRow(Icons.place_rounded, locationText),
                    Row(
                      children: [
                        SizedBox(
                          width: 58,
                          height: 24,
                          child: Stack(
                            children: [
                              Positioned(
                                  left: 0,
                                  child: _avatarDot(const Color(0xFFDF4C4C))),
                              Positioned(
                                  left: 12,
                                  child: _avatarDot(const Color(0xFF3D6BD6))),
                              Positioned(
                                  left: 24,
                                  child: _avatarDot(const Color(0xFFF2B800))),
                              Positioned(
                                  left: 36,
                                  child: _avatarDot(const Color(0xFF4BAF72))),
                            ],
                          ),
                        ),
                        Container(
                          width: 26,
                          height: 26,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFFD4C6AB)),
                          ),
                          child: const Text(
                            '+20',
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 8,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF3A3A3A),
                            ),
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          height: 34,
                          child: ElevatedButton(
                            onPressed: onTap,
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: const Color(0xFFF5A400),
                              foregroundColor: Colors.white,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              minimumSize: const Size(0, 34),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.viewDetails,
                              style: const TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        ridersText,
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF575757),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScheduleDate {
  final DateTime date;

  const _ScheduleDate({required this.date});

  factory _ScheduleDate.fromDate(DateTime date) {
    return _ScheduleDate(date: DateTime(date.year, date.month, date.day));
  }

  String get weekdayLabel => DateFormat('EEE').format(date);

  String get dayNumber => DateFormat('d').format(date);

  String get monthLabel => DateFormat('MMM').format(date);
}

class _DateSelectorCard extends StatelessWidget {
  final List<_ScheduleDate> dates;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const _DateSelectorCard({
    required this.dates,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: SizedBox(
        height: 104,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: dates.length,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            final d = dates[index];
            final selected = index == selectedIndex;

            return GestureDetector(
              onTap: () => onSelected(index),
              child: Container(
                width: 72,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFFF3E4CA)
                      : const Color(0xFFF9F7F5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color:
                        selected ? const Color(0xFFE6D5B0) : Colors.transparent,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        d.weekdayLabel,
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 10,
                          color: Color(0xFF6B6B6B),
                        ),
                      ),
                    ),
                    Text(
                      d.dayNumber,
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        height: 1,
                        color: selected
                            ? const Color(0xFF101010)
                            : const Color(0xFF222222),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          d.monthLabel,
                          style: const TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 11,
                            height: 1,
                            color: Color(0xFF6B6B6B),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: selected
                                ? const Color(0xFFD64C43)
                                : Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
