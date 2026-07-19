import 'package:adcc/features/routes/Models/track_model.dart';
import 'package:adcc/features/routes/services/tracks_services.dart';
import 'package:adcc/features/routes/view/city_tracks_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/section_header.dart';

class ExploreByCitySection extends StatefulWidget {
  const ExploreByCitySection({super.key});

  @override
  State<ExploreByCitySection> createState() => _ExploreByCitySectionState();
}

class _ExploreByCitySectionState extends State<ExploreByCitySection> {
  static const List<String> _allCities = [
    'Al Dhafra',
    'Al Ain',
    'Rabdan',
    'AL Raha',
    'Fullgas',
    'Yasi',
    'Saraab',
    'Abu Dhabi',
  ];

  final TracksService _tracksService = TracksService();

  late Future<List<TrackModel>> _futureTracks;

  @override
  void initState() {
    super.initState();
    _futureTracks = _tracksService.getAllTracks();
  }

  Map<String, int> _groupTracksByCity(List<TrackModel> tracks) {
    final Map<String, int> cityCount = {};

    for (var track in tracks) {
      final city = track.city.trim();

      if (cityCount.containsKey(city)) {
        cityCount[city] = cityCount[city]! + 1;
      } else {
        cityCount[city] = 1;
      }
    }

    return cityCount;
  }

  String _getCityImage(String city) {
    switch (city.toLowerCase()) {
      case 'abu dhabi':
        return 'assets/svg/abu_dhabi_city_icon.svg';
      case 'al ain':
        return 'assets/svg/AI_ain_city_icon.svg';
      case 'dubai':
        return 'assets/svg/dubai_city_icon.svg';
      case 'al dhafra':
        return 'assets/svg/Al_dharfa_city_icon.svg';
      case 'yas island':
        return 'assets/svg/yas_island_city_icon.svg';
      case 'liwa':
        return 'assets/svg/Liwa_city_icon.svg';
      default:
        return 'assets/svg/abu_dhabi_city_icon.svg';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TrackModel>>(
      future: _futureTracks,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.only(top: 40),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return const SizedBox();
        }

        final tracks = snapshot.data ?? [];

        final cityMap = _groupTracksByCity(tracks);

        final cities = _allCities
            .map((city) => MapEntry(city, cityMap[city] ?? 0))
            .toList();

        if (cities.isEmpty) {
          return const SizedBox();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(
              title: 'Explore by City',
              onViewAll: () {},
              showViewAll: false,
            ),
            // const SizedBox(height: 15),
            GridView.builder(
              padding: const EdgeInsets.only(top: 30, bottom: 120),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.3,
              ),
              itemCount: cities.length,
              itemBuilder: (context, index) {
                final cityName = cities[index].key;
                final count = cities[index].value;

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CityTracksPage(
                          cityName: cityName,
                        ),
                      ),
                    );
                  },
                  child: SizedBox(
                    width: 111,
                    height: 75,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFFABEAFF),
                            Colors.white,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            cityName,
                            style: const TextStyle(
                              fontSize: 15.473,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textDark,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                count.toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textDark,
                                ),
                              ),
                              SvgPicture.asset(
                                _getCityImage(cityName),
                                width: 19,
                                height: 24.945,
                                fit: BoxFit.contain,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
