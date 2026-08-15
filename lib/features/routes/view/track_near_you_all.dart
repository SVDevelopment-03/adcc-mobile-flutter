import 'package:adcc/core/constants/cosmatic_imgs.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:adcc/shared/widgets/track_card.dart';
import 'package:adcc/features/route_details/view/route_details_screen.dart';
import 'package:adcc/features/routes/services/tracks_services.dart';
import 'package:adcc/features/routes/Models/track_model.dart';
import 'package:adcc/l10n/app_localizations.dart';

class TrackNearAllPage extends StatefulWidget {
  const TrackNearAllPage({super.key});

  @override
  State<TrackNearAllPage> createState() => _TrackNearAllPageState();
}

class _TrackNearAllPageState extends State<TrackNearAllPage> {
  static const String _pageBackgroundImage = TrackImgs.trackBackground;

  final TracksService _tracksService = TracksService();

  late Future<List<TrackModel>> _futureTracks;

  int selectedFilterIndex = -1;

  final List<String> filters = const [
    'Al Dhafra',
    'Al Ain',
    'Rabdan',
    'AL Raha',
    'Fullgas',
    'Yasi',
    'Saraab',
  ];

  @override
  void initState() {
    super.initState();
    _futureTracks = _tracksService.getAllTracks();
  }

  List<TrackModel> _applyFilter(List<TrackModel> tracks) {
    if (selectedFilterIndex < 0) return tracks;

    final selectedCity = filters[selectedFilterIndex];
    return tracks
        .where((t) =>
            t.city.toLowerCase().trim() == selectedCity.toLowerCase().trim())
        .toList();
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
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text(AppLocalizations.of(context)!.failedToLoadTracks),
                );
              }

              final allTracks = snapshot.data ?? [];
              final tracks = _applyFilter(allTracks);

              return ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                children: [
                  const _TracksNearHero(),
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
                    '${tracks.length} communities found',
                    style: const TextStyle(
                      fontFamily: "Outfit",
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 17),
                  if (tracks.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: Text(
                          "No tracks found",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ...tracks.map((t) {
                    final subtitle =
                        "${t.trackType} • ${t.surfaceType} • ${t.facilities.join(", ")}";

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: TrackCard(
                        width: double.infinity,
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
                      ),
                    );
                  }),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _TracksNearHero extends StatelessWidget {
  const _TracksNearHero();

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
            const Positioned(
              left: 16,
              right: 16,
              bottom: 27,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Tracks Near You",
                    style: TextStyle(
                      fontFamily: "Outfit",
                      fontSize: 20.1125,
                      fontWeight: FontWeight.w600,
                      height: 1.1,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Cycling tracks closest to your current location",
                    style: TextStyle(
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

class NearbyCityStrip extends StatelessWidget {
  final List<String> categories;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const NearbyCityStrip({
    required this.categories,
    required this.selectedIndex,
    required this.onSelected,
  });

  static const List<String> _providedCategoryImageUrls = [
    'https://projet-adcc-image.s3.me-central-1.amazonaws.com/content/1-1781532636129-c5cadcbfd942.jfif',
    'https://projet-adcc-image.s3.me-central-1.amazonaws.com/content/2-1781532636663-10091017b61a.jfif',
    'https://projet-adcc-image.s3.me-central-1.amazonaws.com/content/6-1781532638130-147b1aea8e78.jfif',
    'https://projet-adcc-image.s3.me-central-1.amazonaws.com/content/5-1781532637733-ed19f7a77a5c.jfif',
    'https://projet-adcc-image.s3.me-central-1.amazonaws.com/content/4-1781532637356-e8cb3e82b340.jfif',
    'https://projet-adcc-image.s3.me-central-1.amazonaws.com/content/3-1781532637019-37f4ba925dc4.jfif',
    'https://projet-adcc-image.s3.me-central-1.amazonaws.com/content/7-1781532638497-a41b59dfcca5.jfif',
    'https://projet-adcc-image.s3.me-central-1.amazonaws.com/content/12-1781532644463-56ba5130bf39.jfif',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 118,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final selected = selectedIndex == index;
          final imageUrl = index < _providedCategoryImageUrls.length
              ? _providedCategoryImageUrls[index]
              : null;

          return GestureDetector(
            onTap: () => onSelected(index),
            child: Container(
              width: 92,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.36),
                border: Border.all(
                  color: selected
                      ? const Color(0xFF0359E8)
                      : const Color(0x800359E8),
                  width: 0.61,
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(6),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(7.36),
                      child: imageUrl != null
                          ? Image.network(
                              imageUrl,
                              width: 80,
                              height: 75,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 80,
                                height: 75,
                                color: const Color(0xFFE5E7EB),
                                child: const Icon(
                                  Icons.image_not_supported,
                                  color: Color(0xFF9CA3AF),
                                  size: 24,
                                ),
                              ),
                            )
                          : Container(
                              width: 80,
                              height: 75,
                              color: const Color(0xFFE5E7EB),
                              child: const Icon(
                                Icons.image_not_supported,
                                color: Color(0xFF9CA3AF),
                                size: 24,
                              ),
                            ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        categories[index],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "Outfit",
                          fontSize: 9,
                          fontWeight: FontWeight.w500,
                          height: 1,
                          color: selected
                              ? const Color(0xFF0359E8)
                              : const Color(0x800359E8),
                        ),
                      ),
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
