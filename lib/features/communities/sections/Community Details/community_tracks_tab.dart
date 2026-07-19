import 'package:adcc/features/communities/sections/community_highlight_track_card.dart';
import 'package:adcc/features/route_details/view/route_details_screen.dart';
import 'package:adcc/features/routes/Models/track_model.dart';
import 'package:adcc/features/routes/services/tracks_services.dart';
import 'package:flutter/material.dart';

class CommunityTracksTab extends StatefulWidget {
  final Color cardColor;
  final String? trackId;

  const CommunityTracksTab({
    super.key,
    this.cardColor = const Color(0xFFD6F6FF),
    this.trackId,
  });

  @override
  State<CommunityTracksTab> createState() => _CommunityTracksTabState();
}

class _CommunityTracksTabState extends State<CommunityTracksTab> {
  final TracksService _tracksService = TracksService();
  late Future<TrackModel?> _trackFuture;

  @override
  void initState() {
    super.initState();
    _trackFuture = _loadTrack();
  }

  Future<TrackModel?> _loadTrack() async {
    final trackId = widget.trackId?.trim() ?? '';
    if (trackId.isEmpty) return null;
    try {
      return await _tracksService.getTrackById(trackId);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<TrackModel?>(
      future: _trackFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 253,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final track = snapshot.data;
        if (track == null) {
          return const SizedBox(
            height: 253,
            child: Center(child: Text('No track data available')),
          );
        }

        return SizedBox(
          height: 253,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: 1,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              return CommunityHighlightTrackCard(
                imagePath: track.image.isNotEmpty
                    ? track.image
                    : 'assets/images/track.png',
                title: track.title,
                subtitle: track.pace.isNotEmpty ? track.pace : track.type,
                iconPath: 'assets/icons/event_track.png',
                // backgroundColor: widget.cardColor,
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
