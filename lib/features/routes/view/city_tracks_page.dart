import 'package:adcc/core/constants/cosmatic_imgs.dart';
import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/features/route_details/view/route_details_screen.dart';
import 'package:adcc/features/routes/Models/track_model.dart';
import 'package:adcc/features/routes/services/tracks_services.dart';
import 'package:adcc/features/routes/view/track_near_you_all.dart';
import 'package:adcc/shared/widgets/track_card.dart';
import 'package:adcc/l10n/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CityTracksPage extends StatefulWidget {
  final String cityName;

  const CityTracksPage({
    super.key,
    required this.cityName,
  });

  @override
  State<CityTracksPage> createState() => _CityTracksPageState();
}

class _CityTracksPageState extends State<CityTracksPage> {
  static const String _pageBackgroundImage = TrackImgs.trackBackground;

  final TracksService _tracksService = TracksService();

  late Future<List<TrackModel>> _futureTracks;

  int selectedFilterIndex = 0;

  final List<String> filters = const ['All', 'Open', 'Limited', 'Closed'];

  @override
  void initState() {
    super.initState();
    _futureTracks = _tracksService.getAllTracks();
  }

  List<TrackModel> _applyFilters(List<TrackModel> tracks) {
    return tracks.where((t) {
      final cityMatch =
          t.city.toLowerCase().trim() == widget.cityName.toLowerCase().trim();

      final statusMatch = selectedFilterIndex == 0 ||
          t.status.toLowerCase() == filters[selectedFilterIndex].toLowerCase();

      return cityMatch && statusMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: CachedNetworkImageProvider(_pageBackgroundImage),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        child: FutureBuilder<List<TrackModel>>(
          future: _futureTracks,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text(AppLocalizations.of(context)!.failedToLoadTracks));
            }

            final allTracks = snapshot.data ?? [];

            final tracks = _applyFilters(allTracks);

            return ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 20),
              children: [
                const SizedBox(height: 6),
                CityTracksHero(cityName: widget.cityName),
                const SizedBox(height: 30),
                NearbyCityStrip(
                  categories: filters,
                  selectedIndex: selectedFilterIndex,
                  onSelected: (index) {
                    setState(() {
                      selectedFilterIndex = index;
                    });
                  },
                ),
                const SizedBox(height: 24),
                Text(
                  AppLocalizations.of(context)!.tracks_found(tracks.length),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppColors.charcoal,
                  ),
                ),
                const SizedBox(height: 24),
                if (tracks.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context)!.noTracksFound,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ...tracks.map(
                  (t) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: TrackCard(
                      width: double.infinity,
                      height: 374,
                      routeMapStyle: true,
                      imagePath: t.image,
                      title: t.title,
                      city: t.city,
                      distance: "${t.distance ?? 0} km",
                      subtitle:
                          "${t.trackType} • ${t.surfaceType} • ${t.facilities.join(", ")}",
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
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            );
          },
        ),
      ),
    ));
  }
}

class CityTracksHero extends StatelessWidget {
  final String cityName;

  const CityTracksHero({
    required this.cityName,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        height: 299,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/tracks-near-you-bg.png',
              fit: BoxFit.cover,
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: .02),
                      Colors.black.withValues(alpha: .72),
                    ],
                    stops: const [.58, 1],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 18,
              left: 15,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 35,
                  height: 35,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    size: 16,
                    color: Color(0xFFF09902),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 27,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.tracks_in_city(cityName),
                    style: const TextStyle(
                      fontFamily: "Outfit",
                      fontSize: 20.1125,
                      fontWeight: FontWeight.w600,
                      height: 1.1,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    AppLocalizations.of(context)!.cycling_tracks_in_city(cityName),
                    style: const TextStyle(
                      fontFamily: "Outfit",
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      height: 1.33,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
