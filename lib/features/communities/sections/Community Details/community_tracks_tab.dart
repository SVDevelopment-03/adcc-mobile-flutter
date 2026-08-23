import 'package:adcc/features/communities/sections/community_highlight_track_card.dart';
import 'package:adcc/features/route_details/view/route_details_screen.dart';
import 'package:adcc/features/routes/Models/track_model.dart';
import 'package:adcc/features/routes/services/tracks_services.dart';
import 'package:adcc/features/events/services/events_service.dart';
import 'package:adcc/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class CommunityTracksTab extends StatefulWidget {
  final Color cardColor;
  final String? trackId;
  final List<String>? trackIds;
  final String? communityId;

  const CommunityTracksTab({
    super.key,
    this.cardColor = const Color(0xFFD6F6FF),
    this.trackId,
    this.trackIds,
    this.communityId,
  });

  @override
  State<CommunityTracksTab> createState() => _CommunityTracksTabState();
}

class _CommunityTracksTabState extends State<CommunityTracksTab> {
  final TracksService _tracksService = TracksService();
  final EventsService _eventsService = EventsService();
  late Future<List<TrackModel>> _tracksFuture;

  @override
  void initState() {
    super.initState();
    _tracksFuture = _loadTracks();
  }

  Future<List<TrackModel>> _loadTracks() async {
    final ids = <String>[];
    if (widget.trackIds != null) {
      ids.addAll(widget.trackIds!.where((id) => id.trim().isNotEmpty));
    }
    if (ids.isEmpty && (widget.trackId?.trim() ?? '').isNotEmpty) {
      ids.add(widget.trackId!.trim());
    }
    // If still empty or to enrich with event tracks, fetch community events
    if ((widget.trackIds == null || widget.trackIds!.isEmpty) && (widget.trackId == null || widget.trackId!.trim().isEmpty) && widget.key == null) {
      // no-op: keep existing behavior
    }

    // Also try to fetch event-associated tracks for this community (if we have an id prop)
    try {
      final communityId = widget.communityId;
      if (communityId != null && communityId.isNotEmpty) {
        final eventsResp = await _eventsService.getEvents(queryParameters: {'communityId': communityId, 'page': 1, 'limit': 200});
        if (eventsResp.success && eventsResp.data != null) {
          for (final ev in eventsResp.data!) {
            // Ensure this event belongs to the same community
            final String? evCommunityId = (ev.communityId is String) ? ev.communityId : null;
            if (evCommunityId == null || evCommunityId != communityId) continue;

            final dynamic tr = ev.trackId;
            if (tr == null) continue;
            if (tr is String && tr.trim().isNotEmpty) {
              if (!ids.contains(tr.trim())) ids.add(tr.trim());
              continue;
            }
            if (tr is Map) {
              final map = Map<String, dynamic>.from(tr);
              final idVal = map['_id'] ?? map['id'];
              final s = idVal?.toString() ?? '';
              if (s.isNotEmpty && !ids.contains(s)) ids.add(s);
            }
          }
        }
      }
    } catch (_) {
      // ignore event fetch failures
    }
    if (ids.isEmpty) return const [];

    final tracks = <TrackModel>[];
    for (final id in ids) {
      try {
        final track = await _tracksService.getTrackById(id);
        if (track != null) tracks.add(track);
      } catch (_) {
        // ignore per-track fetch errors and continue
      }
    }

    return tracks;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TrackModel>>(
      future: _tracksFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 253,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final tracks = snapshot.data ?? const <TrackModel>[];
        if (tracks.isEmpty) {
          return SizedBox(
            height: 253,
            child: Center(child: Text(AppLocalizations.of(context)!.community_no_track_data)),
          );
        }

        return SizedBox(
          height: 253,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: tracks.length,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final track = tracks[index];
              return CommunityHighlightTrackCard(
                imagePath: track.image.isNotEmpty
                    ? track.image
                    : 'assets/images/track.png',
                title: track.title,
                subtitle: track.pace.isNotEmpty ? track.pace : track.type,
                iconPath: 'assets/icons/event_track.png',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RouteDetailsScreen(
                        routeData: {'id': track.id},
                      ),
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
