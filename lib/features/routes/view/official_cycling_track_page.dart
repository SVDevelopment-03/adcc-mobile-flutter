import 'package:adcc/core/constants/cosmatic_imgs.dart';
import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/l10n/app_localizations.dart';
import 'package:adcc/features/route_details/view/route_details_screen.dart';
import 'package:adcc/features/routes/Models/track_model.dart';
import 'package:adcc/features/routes/services/tracks_services.dart';
import 'package:adcc/features/routes/view/route_city_filters.dart';
import 'package:adcc/features/routes/view/track_near_you_all.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:adcc/shared/widgets/track_card.dart';

class OfficialCyclingTracksPage extends StatefulWidget {
  const OfficialCyclingTracksPage({super.key});

  @override
  State<OfficialCyclingTracksPage> createState() =>
      _OfficialCyclingTracksPageState();
}

class _OfficialCyclingTracksPageState extends State<OfficialCyclingTracksPage> {
  static const String _pageBackgroundImage = TrackImgs.trackBackground;

  int selectedFilterIndex = -1;

  final List<String> filters = routeCityFilters;

  final TracksService _tracksService = TracksService();
  late Future<List<TrackModel>> _futureTracks;

  static const Map<String, String> _cityFilterAliases = {
    'al dhafra': 'al dhafra',
    'al ain': 'al ain',
    'rabdan': 'rabdan',
    'al raha': 'al raha',
    'fullgas': 'fullgas',
    'yasi': 'yas',
    'saraab': 'saraab',
  };

  @override
  void initState() {
    super.initState();
    _futureTracks = _tracksService.getAllTracks();
  }

  List<TrackModel> _applyFilter(List<TrackModel> tracks) {
    if (selectedFilterIndex < 0) {
      return tracks;
    }

    final selectedCity = filters[selectedFilterIndex].toLowerCase().trim();
    final searchTerm = _cityFilterAliases[selectedCity] ?? selectedCity;

    return tracks.where((t) {
      final searchable = [
        t.city,
        t.title,
        t.address,
        t.area,
        t.type,
        t.trackType,
        t.description,
        t.facilities.join(' '),
      ].join(' ').toLowerCase();

      return searchable.contains(searchTerm);
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
              final tracks = snapshot.data ?? [];
              final filteredTracks = _applyFilter(tracks);

              return ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 20),
                children: [
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      height: 310,
                      width: double.infinity,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(
                            'assets/images/official-cycling-tracks-bg.jpg',
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
                                  AppLocalizations.of(context)!.official_cycling_tracks_title,
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
                                  AppLocalizations.of(context)!.cycling_tracks_closest,
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
                  ),
                  const SizedBox(height: 21),
                  NearbyCityStrip(
                    categories: filters,
                    selectedIndex: selectedFilterIndex,
                    onSelected: (index) {
                      setState(() {
                        selectedFilterIndex = index;
                      });
                    },
                  ),
                  const SizedBox(height: 35),
                  if (snapshot.connectionState == ConnectionState.waiting)
                    const Center(child: CircularProgressIndicator())
                  else if (snapshot.hasError)
                    Center(
                      child: Text(
                        AppLocalizations.of(context)!.failedToLoadTracks,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    )
                  else ...[
                    Text(
                      AppLocalizations.of(context)!.tracks_found(filteredTracks.length),
                      style: const TextStyle(
                        fontFamily: "Outfit",
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        height: 1,
                        letterSpacing: 0,
                        color: AppColors.charcoal,
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (filteredTracks.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context)!.noTracksFound,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    ...filteredTracks.map(
                      (t) => Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: TrackCard(
                          width: double.infinity,
                          height: 281,
                          imagePath: t.image.isNotEmpty
                              ? t.image
                              : 'assets/images/no-img.jpg',
                          title: t.title,
                          city: t.city,
                          distance: "${t.distance ?? 0} km",
                          subtitle:
                              "${t.trackType.isNotEmpty ? t.trackType : AppLocalizations.of(context)!.track} • ${t.surfaceType.isNotEmpty ? t.surfaceType : AppLocalizations.of(context)!.route} • ${t.facilities.join(", ")}",
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
                  ],
                  const SizedBox(height: 20),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
