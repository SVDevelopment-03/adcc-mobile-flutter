import 'package:adcc/features/routes/Models/track_model.dart';
import 'package:adcc/features/routes/services/tracks_services.dart';
import 'package:flutter/material.dart';
import 'package:adcc/shared/widgets/section_header.dart';
import 'package:adcc/shared/widgets/track_card.dart';
import 'package:adcc/features/route_details/view/route_details_screen.dart';
import 'package:adcc/features/routes/view/track_near_you_all.dart';

class TracksNearYouSection extends StatefulWidget {
  final String selectedStatus;
  final String searchQuery;

  const TracksNearYouSection({
    super.key,
    required this.selectedStatus,
    required this.searchQuery,
  });

  @override
  State<TracksNearYouSection> createState() => _TracksNearYouSectionState();
}

class _TracksNearYouSectionState extends State<TracksNearYouSection> {
  final TracksService _tracksService = TracksService();

  late Future<List<TrackModel>> _futureTracks;

  @override
  void initState() {
    super.initState();
    _futureTracks = _tracksService.getAllTracks();
  }

  List<TrackModel> _applyFilters(List<TrackModel> tracks) {
    return tracks.where((t) {
      final bool cityMatch = widget.selectedStatus == "All" ||
          t.city.toLowerCase().trim() ==
              widget.selectedStatus.toLowerCase().trim();

      final query = widget.searchQuery.toLowerCase().trim();

      final bool searchMatch = query.isEmpty ||
          t.title.toLowerCase().contains(query) ||
          t.city.toLowerCase().contains(query) ||
          t.surfaceType.toLowerCase().contains(query) ||
          t.trackType.toLowerCase().contains(query) ||
          (t.distance?.toString().contains(query) ?? false);

      return cityMatch && searchMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: "Tracks Near You",
          onViewAll: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const TrackNearAllPage(),
              ),
            );
          },
        ),
        const SizedBox(height: 30),
        FutureBuilder<List<TrackModel>>(
          future: _futureTracks,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: 281,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (snapshot.hasError) {
              return SizedBox(
                height: 281,
                child: Center(
                  child: Text(
                    "Failed to load tracks",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              );
            }

            final allTracks = snapshot.data ?? [];
            final tracks = _applyFilters(allTracks);

            if (tracks.isEmpty) {
              return SizedBox(
                height: 281,
                child: Center(
                  child: Text(
                    "No tracks found",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              );
            }

            return SizedBox(
              height: 374,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: tracks.length,
                separatorBuilder: (_, __) => const SizedBox(width: 14),
                itemBuilder: (context, index) {
                  final t = tracks[index];

                  final subtitle =
                      "${t.trackType} • ${t.surfaceType} • ${t.facilities.join(", ")}";

                  return TrackCard(
                    width: 286,
                    height: 374,
                    routeMapStyle: true,
                    imagePath: t.image,
                    title: t.title,
                    city: t.city,
                    distance: "${t.distance ?? 0} km",
                    subtitle: subtitle,
                    difficulty: t.difficulty,
                    status: t.status,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RouteDetailsScreen(
                            routeData: {
                              "id": t.id,
                              "title": t.title,
                              "description": t.description,
                              "image": t.image,
                              "city": t.city,
                              "address": t.address,
                              "zipcode": t.zipcode,
                              "distance": t.distance,
                              "elevation": t.elevation,
                              "type": t.type,
                              "avgtime": t.avgtime,
                              "pace": t.pace,
                              "facilities": t.facilities,
                              "status": t.status,
                              "difficulty": t.difficulty,
                              "country": t.country,
                              "helmetRequired": t.helmetRequired,
                              "nightRidingAllowed": t.nightRidingAllowed,
                              "slug": t.slug,
                              "trackType": t.trackType,
                              "visibility": t.visibility,
                              "surfaceType": t.surfaceType,
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
