import 'package:adcc/features/communities/sections/community_highlight_track_card.dart';
import 'package:adcc/features/event_details/view/event_details_screen.dart';
import 'package:adcc/features/events/Model/model_events.dart';
import 'package:adcc/features/events/services/events_service.dart';
import 'package:adcc/features/routes/services/tracks_services.dart';
import 'package:adcc/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class CommunityEventsTab extends StatefulWidget {
  final Color cardColor;
  final String? communityId;
  final String? trackId;
  final EventsService? eventsService;

  const CommunityEventsTab({
    super.key,
    this.cardColor = const Color(0xFFD6F6FF),
    this.communityId,
    this.trackId,
    this.eventsService,
  });

  @override
  State<CommunityEventsTab> createState() => _CommunityEventsTabState();
}

class _CommunityEventsTabState extends State<CommunityEventsTab> {
  final TracksService _tracksService = TracksService();
  final EventsService _eventsService = EventsService();
  late Future<List<Event>> _eventsFuture;

  @override
  void initState() {
    super.initState();
    _eventsFuture = _loadEvents();
  }

  Future<List<Event>> _loadEvents() async {
    final communityId = widget.communityId?.trim() ?? '';
    final trackId = widget.trackId?.trim() ?? '';

    if (communityId.isEmpty && trackId.isEmpty) {
      debugPrint('CommunityEventsTab: no communityId or trackId; skipping events API');
      return const [];
    }

    if (communityId.isNotEmpty) {
      final service = widget.eventsService ?? _eventsService;
      debugPrint('CommunityEventsTab: loading community events for $communityId');
      final result = await service.getEvents(
        queryParameters: {
          'communityId': communityId,
          'status': 'Upcoming',
          'limit': 20,
        },
      );

      if (result.success && result.data != null) {
        return result.data!;
      }

      return const [];
    }

    if (trackId.isNotEmpty) {
      try {
        final events = await _tracksService.getTrackRelatedEvents(trackId);
        return events
            .map(
              (event) => Event(
                id: event.id,
                title: event.title,
                description: event.description,
                mainImage: event.mainImage,
                eventDate: event.eventDate.toString(),
                eventTime: event.eventTime,
                address: event.address,
                category: event.category,
              ),
            )
            .toList();
      } catch (_) {
        return const [];
      }
    }

    return const [];
  }

  String _formatEventDate(Event event) {
    final raw = event.eventDate?.trim() ?? '';
    if (raw.isEmpty) return '';
    return raw.split(' ').first;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Event>>(
      future: _eventsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 253,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final events = snapshot.data ?? const <Event>[];
        if (events.isEmpty) {
          return SizedBox(
            height: 253,
            child: Center(child: Text(AppLocalizations.of(context)!.community_no_upcoming_events)),
          );
        }

        return SizedBox(
          height: 253,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: events.length,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final event = events[index];
              return CommunityHighlightTrackCard(
                imagePath: (event.mainImage ?? '').isNotEmpty
                    ? event.mainImage!
                    : 'assets/images/no-img.jpg',
                title: event.title,
                subtitle: _formatEventDate(event),
                iconPath: 'assets/icons/calender.png',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EventDetailsScreen(eventId: event.id),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
