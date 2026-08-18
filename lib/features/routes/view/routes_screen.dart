import 'package:adcc/core/constants/api_endpoints.dart';
import 'package:adcc/core/constants/cosmatic_imgs.dart';
import 'package:adcc/core/services/language_storage_service.dart';
import 'package:adcc/core/services/lookup_service.dart';
import 'package:adcc/l10n/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'route_city_filters.dart';
import 'sections/official_cycling_tracks_section.dart';
import 'sections/tracks_near_you_section.dart';
import 'sections/explore_by_city_section.dart';

const String _routesPageBackgroundImage = TrackImgs.trackBackground;

class RoutesTab extends StatefulWidget {
  const RoutesTab({super.key});

  @override
  State<RoutesTab> createState() => _RoutesTabState();
}

class _RoutesTabState extends State<RoutesTab> {
  int selectedFilterIndex = 0;
  String searchQuery = '';

  // Display labels come from the dashboard-managed city lookup (localized).
  // English `value` is used for track filtering.
  List<String> filterPills = routeCityFilters;

  @override
  void initState() {
    super.initState();
    _loadCityPills();
  }

  Future<void> _loadCityPills() async {
    try {
      final lookups = await LookupService.instance
          .getLookups(ApiEndpoints.lookupTypeCity);
      final locale = await LanguageStorageService.getLocaleCode();
      if (!mounted) return;
      if (lookups.isNotEmpty) {
        setState(() {
          filterPills = lookups.map((l) => l.displayFor(locale)).toList();
        });
      }
    } catch (_) {
      // Keep the static fallback list.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: CachedNetworkImageProvider(_routesPageBackgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.zero,
          children: [
            _TrackHero(
              searchValue: searchQuery,
              onSearchChanged: (value) {
                setState(() => searchQuery = value);
              },
            ),
            Transform.translate(
              offset: const Offset(0, -57),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _TrackCategoryCard(
                  categories: filterPills,
                  selectedIndex: selectedFilterIndex,
                  onSelected: (index) {
                    setState(() => selectedFilterIndex = index);
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TracksNearYouSection(
                selectedStatus: filterPills[selectedFilterIndex],
                searchQuery: searchQuery,
              ),
            ),
            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: OfficialCyclingTracksSection(),
            ),
            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: ExploreByCitySection(),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class _TrackHero extends StatelessWidget {
  final String searchValue;
  final ValueChanged<String> onSearchChanged;

  const _TrackHero({
    required this.searchValue,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 329,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: CachedNetworkImageProvider(TrackImgs.trackheaderbackground),
          fit: BoxFit.cover,
        ),
        // gradient: LinearGradient(
        //   begin: Alignment.topCenter,
        //   end: Alignment.bottomCenter,
        //   stops: [0, .84, 1],
        //   colors: [
        //     Color(0xFFF09902),
        //     Color(0xFFF09902),
        //     Colors.white,
        //   ],
        // ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 86, 16, 0),
          child: Column(
            children: [
              Row(
                children: [
                  // GestureDetector(
                  //   onTap: () {
                  //     if (Navigator.canPop(context)) Navigator.pop(context);
                  //   },
                  //   child: const Icon(
                  //     Icons.arrow_back,
                  //     color: Colors.white,
                  //     size: 24,
                  //   ),
                  // ),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.find_a_track,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: "Outfit",
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        height: 1.25,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                ],
              ),
              const SizedBox(height: 18),
              Container(
                height: 38,
                padding: const EdgeInsets.fromLTRB(11, 7, 14, 7),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .27),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 23.5,
                      height: 23.5,
                      decoration: BoxDecoration(
                        color: const Color(0xFF8C8C8C).withValues(alpha: .25),
                        borderRadius: BorderRadius.circular(36),
                      ),
                      child: const Icon(
                        Icons.search,
                        size: 13,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 9),
                    Expanded(
                      child: TextField(
                        onChanged: onSearchChanged,
                        controller: TextEditingController(text: searchValue)
                          ..selection = TextSelection.collapsed(
                            offset: searchValue.length,
                          ),
                        cursorColor: Colors.black,
                        style: const TextStyle(
                          fontFamily: "Outfit",
                          fontSize: 12,
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          isCollapsed: true,
                          border: InputBorder.none,
                          hintText: AppLocalizations.of(context)!.searchHint,
                          hintStyle: const TextStyle(
                            fontFamily: "Outfit",
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TrackCategoryCard extends StatefulWidget {
  final List<String> categories;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const _TrackCategoryCard({
    required this.categories,
    required this.selectedIndex,
    required this.onSelected,
    super.key,
  });

  @override
  State<_TrackCategoryCard> createState() => _TrackCategoryCardState();
}

class _TrackCategoryCardState extends State<_TrackCategoryCard> {
  static const List<String> _providedCategoryImageUrls = [
    'https://projet-adcc-image.s3.me-central-1.amazonaws.com/content/1-1781532636129-c5cadcbfd942.jfif',
    'https://projet-adcc-image.s3.me-central-1.amazonaws.com/content/2-1781532636663-10091017b61a.jfif',
    'https://projet-adcc-image.s3.me-central-1.amazonaws.com/content/6-1781532638130-147b1aea8e78.jfif',
    'https://projet-adcc-image.s3.me-central-1.amazonaws.com/content/5-1781532637733-ed19f7a77a5c.jfif',
    'https://projet-adcc-image.s3.me-central-1.amazonaws.com/content/4-1781532637356-e8cb3e82b340.jfif',
    'https://projet-adcc-image.s3.me-central-1.amazonaws.com/content/3-1781532637019-37f4ba925dc4.jfif',
    'https://projet-adcc-image.s3.me-central-1.amazonaws.com/content/7-1781532638497-a41b59dfcca5.jfif',
    'https://projet-adcc-image.s3.me-central-1.amazonaws.com/content/8-1781532640629-601900e00d2f.jfif'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 136,
      padding: const EdgeInsets.fromLTRB(13, 10, 13, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.16),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .10),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: widget.categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final selected = widget.selectedIndex == index;
          final category = widget.categories[index];
          final imageUrl = index < _providedCategoryImageUrls.length
              ? _providedCategoryImageUrls[index]
              : null;

          return GestureDetector(
            onTap: () => widget.onSelected(index),
            child: Container(
              width: 92,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.36),
                border: Border.all(
                  color: selected
                      ? const Color(0xFF0359E8)
                      : const Color(0x800359E8),
                  width: .61,
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
                  Text(
                    category,
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
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
