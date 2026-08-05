import 'package:adcc/features/communities/sections/community_highlight_track_card.dart';
import 'package:adcc/features/event_details/view/event_details_screen.dart';
import 'package:adcc/features/routes/Models/event_model.dart';
import 'package:adcc/features/routes/services/tracks_services.dart';
import 'package:flutter/material.dart';

class CommunityEventsTab extends StatefulWidget {
  final Color cardColor;
  final String? trackId;

  const CommunityEventsTab({
    super.key,
    this.cardColor = const Color(0xFFD6F6FF),
    this.trackId,
  });

  @override
  State<CommunityEventsTab> createState() => _CommunityEventsTabState();
}

class _CommunityEventsTabState extends State<CommunityEventsTab> {
  final TracksService _tracksService = TracksService();
  late Future<List<EventModel>> _eventsFuture;

  @override
  void initState() {
    super.initState();
    _eventsFuture = _loadEvents();
  }

  Future<List<EventModel>> _loadEvents() async {
    final trackId = widget.trackId?.trim() ?? '';
    if (trackId.isEmpty) return const [];
    try {
      return await _tracksService.getTrackRelatedEvents(trackId);
    } catch (_) {
      return const [];
    }
  }

  String _formatEventDate(EventModel event) {
    return event.eventDate.toString().split(' ').first;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<EventModel>>(
      future: _eventsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 253,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final events = snapshot.data ?? const <EventModel>[];
        if (events.isEmpty) {
          return const SizedBox(
            height: 253,
            child: Center(child: Text('No upcoming events for this community')),
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
                imagePath: event.mainImage.isNotEmpty
                    ? event.mainImage
                    : 'assets/images/no-img.jpg',
                title: event.title,
                subtitle: _formatEventDate(event),
                iconPath: 'assets/icons/calender.png',
                // backgroundColor: widget.cardColor,
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
