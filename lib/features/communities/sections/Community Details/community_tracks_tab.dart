import 'package:adcc/features/communities/sections/community_highlight_track_card.dart';
import 'package:adcc/features/route_details/view/route_details_screen.dart';
import 'package:adcc/features/routes/Models/track_model.dart';
import 'package:adcc/features/routes/services/tracks_services.dart';
import 'package:adcc/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class CommunityTracksTab extends StatefulWidget {
  final Color cardColor;
  final String? trackId;
  final List<String>? trackIds;

  const CommunityTracksTab({
    super.key,
    this.cardColor = const Color(0xFFD6F6FF),
    this.trackId,
    this.trackIds,
  });

  @override
  State<CommunityTracksTab> createState() => _CommunityTracksTabState();
}

class _CommunityTracksTabState extends State<CommunityTracksTab> {
  final TracksService _tracksService = TracksService();
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
