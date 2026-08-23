import 'package:adcc/core/constants/api_endpoints.dart';
import 'package:adcc/core/models/lookup_model.dart';
import 'package:adcc/core/services/language_storage_service.dart';
import 'package:adcc/core/services/lookup_service.dart';
import 'package:adcc/features/routes/Models/track_model.dart';
import 'package:adcc/features/routes/services/tracks_services.dart';
import 'package:adcc/features/routes/view/city_tracks_page.dart';
import 'package:adcc/l10n/app_localizations.dart';
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
  // Fallback city list (used only if the lookup service is unavailable).
  static const List<String> _fallbackCities = [
    'Al Dhafra',
    'Al Ain',
    'Rabdan',
    'AL Raha',
    'Fullgas',
    'Yasi',
    'Saraab',
    'Abu Dhabi',
  ];

  // Dashboard-managed cities: English `value` is used for track filtering and
  // navigation; localized `label` is displayed.
  List<LookupModel> _cityLookups = const [];
  String? _localeCode;

  final TracksService _tracksService = TracksService();

  late Future<List<TrackModel>> _futureTracks;

  @override
  void initState() {
    super.initState();
    _futureTracks = _tracksService.getAllTracks();
    _loadCities();
  }

  Future<void> _loadCities() async {
    try {
      final lookups = await LookupService.instance
          .getLookups(ApiEndpoints.lookupTypeCity);
      final locale = await LanguageStorageService.getLocaleCode();
      if (!mounted) return;
      setState(() {
        _cityLookups = lookups;
        _localeCode = locale;
      });
    } catch (_) {
      // Keep the fallback list; display unchanged.
    }
  }

  List<LookupModel> get _displayCities {
    if (_cityLookups.isNotEmpty) return _cityLookups;
    return _fallbackCities
        .map((city) => LookupModel(
              id: '',
              type: ApiEndpoints.lookupTypeCity,
              value: city,
              label: city,
              labelAr: city,
              order: 0,
              active: true,
            ))
        .toList();
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

        // Only include cities that have at least one track available.
        final cities = _displayCities
          .map((lookup) => MapEntry(lookup, cityMap[lookup.value] ?? 0))
          .where((entry) => entry.value > 0)
          .toList();

        if (cities.isEmpty) {
          return const SizedBox();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(
              title: AppLocalizations.of(context)!.exploreByCity,
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
                childAspectRatio: 1.1,
              ),
              itemCount: cities.length,
              itemBuilder: (context, index) {
                final lookup = cities[index].key;
                final cityName = lookup.displayFor(_localeCode);
                final count = cities[index].value;

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CityTracksPage(
                          // Pass the English value so track city filtering works
                          // regardless of the display locale.
                          cityName: lookup.value,
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
                            Color(0xFF3BCC7E),
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
