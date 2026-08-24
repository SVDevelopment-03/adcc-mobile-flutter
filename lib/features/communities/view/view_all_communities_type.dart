import 'package:adcc/core/constants/api_endpoints.dart';
import 'package:adcc/core/models/lookup_model.dart';
import 'package:adcc/core/services/language_storage_service.dart';
import 'package:adcc/core/services/lookup_service.dart';
import 'package:adcc/features/communities/constants/community_categories.dart';
import 'package:adcc/features/communities/models/community_model.dart';
import 'package:adcc/features/communities/view/community_type_details.dart';
import 'package:adcc/l10n/app_localizations.dart';
import 'package:adcc/shared/widgets/adaptive_image.dart';
import 'package:flutter/material.dart';

class CommunityTypeScreen extends StatefulWidget {
  final String title;
  final List<CommunityModel> communities;

  const CommunityTypeScreen({
    super.key,
    required this.title,
    required this.communities,
  });

  @override
  State<CommunityTypeScreen> createState() => _CommunityTypeScreenState();
}

class _CommunityTypeScreenState extends State<CommunityTypeScreen> {
  int selectedFilterIndex = 0;
  List<CommunityCategoryCatalog> _catalog = const [];

  @override
  void initState() {
    super.initState();
    _loadCatalog();
  }

  Future<void> _loadCatalog() async {
    try {
      final lookups = await LookupService.instance
          .getLookups(ApiEndpoints.lookupTypeCommunityCategory);
      final locale = await LanguageStorageService.getLocaleCode();

      if (!mounted) return;

      final catalog = CommunityCategoryCatalog.fromLookups(lookups, locale);
      final title = widget.title.toLowerCase();
      final matchedIndex = catalog.indexWhere((filter) {
        final label = filter.label.toLowerCase();
        return title.contains(label) ||
            filter.searchKeys.any((key) => title.contains(key));
      });

      setState(() {
        _catalog = catalog;
        if (matchedIndex != -1) selectedFilterIndex = matchedIndex;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _catalog = const [];
      });
    }
  }

  List<_CommunityTypeFilter> get filters {
    if (_catalog.isEmpty) {
      return const [];
    }

    return _catalog
        .map((item) => _CommunityTypeFilter(
              label: item.label,
              imagePath: item.lookup.icon?.isNotEmpty == true
                  ? item.lookup.icon!
                  : 'assets/images/community_ride.png',
              keys: item.searchKeys,
            ))
        .toList(growable: false);
  }

  List<CommunityModel> get filteredCommunities {
    final source = widget.communities.isEmpty
        ? _fallbackEliteCommunities
        : widget.communities;

    if (filters.isEmpty) {
      return source.take(6).toList();
    }

    final selected = filters[selectedFilterIndex.clamp(0, filters.length - 1)];

    bool containsAny(String value) {
      final lower = value.toLowerCase();
      return selected.keys.any((key) => lower.contains(key));
    }

    final filtered = source.where((community) {
      return containsAny(community.type) ||
          containsAny(community.title) ||
          containsAny(community.description) ||
          community.category.any(containsAny);
    }).toList();

    if (filtered.isEmpty && selected.label == 'Elite Community') {
      return _fallbackEliteCommunities;
    }

    if (filtered.isEmpty) return source.take(6).toList();
    return filtered.take(8).toList();
  }

  String get _sectionTitle => filters.isEmpty ? widget.title : filters[selectedFilterIndex.clamp(0, filters.length - 1)].label;

  @override
  Widget build(BuildContext context) {
    final list = filteredCommunities;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          physics: const BouncingScrollPhysics(),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 26, 16, 0),
              child: _CommunityTypesHero(
                onBackTap: () => Navigator.pop(context),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              height: 119,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: filters.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  return _CommunityTypeCard(
                    filter: filters[index],
                    isSelected: selectedFilterIndex == index,
                    onTap: () => setState(() => selectedFilterIndex = index),
                  );
                },
              ),
            ),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                _sectionTitle,
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 20,
                  height: 1.25,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                ),
              ),
            ),
            const SizedBox(height: 17),
            ...List.generate(list.length, (index) {
              final community = list[index];
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 25),
                child: _EliteCommunityCard(
                  community: community,
                  imagePath: _cardImage(index, community),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            CommunityCityDetails(community: community),
                      ),
                    );
                  },
                ),
              );
            }),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  static String _cardImage(int index, CommunityModel community) {
    if ((community.imageUrl ?? '').isNotEmpty) return community.imageUrl!;
    const images = [
      'assets/images/community_ride.png',
      'assets/images/racing.png',
      'assets/images/ride_events.png',
      'assets/images/no-img.jpg',
    ];
    return images[index % images.length];
  }
}

class _CommunityTypesHero extends StatelessWidget {
  final VoidCallback onBackTap;

  const _CommunityTypesHero({required this.onBackTap});

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
            const AdaptiveImage(
              imagePath: 'assets/images/community_ride.png',
              fit: BoxFit.cover,
            ),
            Container(color: const Color(0x1A000000)),
            const Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 113,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0x00000000),
                      Color(0xFF000000),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 15,
              top: 18,
              child: GestureDetector(
                onTap: onBackTap,
                child: Container(
                  width: 35,
                  height: 35,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    size: 18,
                    color: Color(0xFFC12D32),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 10,
              right: 10,
              bottom: 44,
              child: Text(
                AppLocalizations.of(context)!.community_types,
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 20.1,
                  height: 1.1,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            Positioned(
              left: 10,
              right: 10,
              bottom: 21,
              child: Text(
                AppLocalizations.of(context)!.choose_communities_subtitle,
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 12,
                  height: 1.33,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CommunityTypeCard extends StatelessWidget {
  final _CommunityTypeFilter filter;
  final bool isSelected;
  final VoidCallback onTap;

  const _CommunityTypeCard({
    required this.filter,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 92,
        height: 109.17,
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : const Color(0x1202A1CE),
          borderRadius: BorderRadius.circular(10.36),
          border: Border.all(
            color: isSelected ? Colors.black : const Color(0xFFD7D7D7),
            width: 0.61,
          ),
        ),
        padding: const EdgeInsets.fromLTRB(6, 6, 6, 8),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(7.36),
              child: SizedBox(
                width: 79.73,
                height: 74.83,
                child: AdaptiveImage(
                  imagePath: filter.imagePath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              height: 18,
              child: Center(
                child: Text(
                  filter.label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 9,
                    height: 1.003,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EliteCommunityCard extends StatelessWidget {
  final CommunityModel community;
  final String imagePath;
  final VoidCallback onTap;

  const _EliteCommunityCard({
    required this.community,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final members = community.membersCount ?? 860;
    final events = community.eventsCount ?? 3;
    final extraMembers = members > 3 ? members - 3 : 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 286,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFD6F6FF),
          borderRadius: BorderRadius.circular(11.59),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.46),
              child: SizedBox(
                height: 1278.66,
                width: double.infinity,
                child: AdaptiveImage(
                  imagePath: imagePath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              left: 12,
              top: 13,
              child: Container(
                width: 107,
                height: 24,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0x541A1C20),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  AppLocalizations.of(context)!.elite_community,
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 12,
                    height: 1.33,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFFFFEFD7),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 14,
              right: 14,
              top: 191.73,
              child: Text(
                community.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 16,
                  height: 1.25,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1C20),
                ),
              ),
            ),
            Positioned(
              left: 14,
              right: 14,
              top: 216.73,
              child: Text(
                community.description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 12,
                  height: 1.16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xB31A1C20),
                ),
              ),
            ),
            Positioned(
              left: 14,
              right: 17,
              top: 244,
              child: SizedBox(
                height: 25,
                child: Row(
                  children: [
                    const Icon(
                      Icons.people_alt_rounded,
                      size: 13,
                      color: Color(0xFF484A4D),
                    ),
                    const SizedBox(width: 5.17),
                    Text(
                      '${_formatNumber(members)} members',
                      style: _metaStyle,
                    ),
                    const SizedBox(width: 25),
                    const Icon(
                      Icons.calendar_month_rounded,
                      size: 13,
                      color: Color(0xFF595959),
                    ),
                    const SizedBox(width: 5.17),
                    Text('$events events', style: _metaStyle),
                    const Spacer(),
                    const _AvatarStack(),
                    const SizedBox(width: 5),
                    Text('+$extraMembers', style: _metaStyle),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static const TextStyle _metaStyle = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 12,
    height: 1.42,
    fontWeight: FontWeight.w400,
    color: Color(0xFF484A4D),
  );
}

class _AvatarStack extends StatelessWidget {
  const _AvatarStack();

  @override
  Widget build(BuildContext context) {
    const colors = [
      Color(0xFF1A1C20),
      Color(0xFFC12D32),
      Color(0xFFFFC300),
      Color(0xFF02A1CE),
    ];

    return SizedBox(
      width: 55,
      height: 25,
      child: Stack(
        children: List.generate(colors.length, (index) {
          return Positioned(
            left: (index * 10).toDouble(),
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: colors[index],
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.3),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _CommunityTypeFilter {
  final String label;
  final String imagePath;
  final List<String> keys;

  const _CommunityTypeFilter({
    required this.label,
    required this.imagePath,
    required this.keys,
  });
}

String _formatNumber(int value) {
  final source = value.toString();
  if (source.length <= 3) return source;

  final buffer = StringBuffer();
  for (var i = 0; i < source.length; i++) {
    if (i > 0 && (source.length - i) % 3 == 0) buffer.write(',');
    buffer.write(source[i]);
  }
  return buffer.toString();
}

final List<CommunityModel> _fallbackEliteCommunities = [
  CommunityModel(
    id: 'elite-awareness',
    title: 'Awareness Rides Community',
    description: 'Safe, family-friendly cycling group',
    type: 'Elite Community',
    category: const ['awareness', 'charity'],
    imageUrl: 'assets/images/community_ride.png',
    membersCount: 860,
    eventsCount: 3,
  ),
  CommunityModel(
    id: 'elite-national',
    title: 'UAE National Events Riders',
    description: 'Official UAE celebration rides',
    type: 'Elite Community',
    category: const ['national', 'events'],
    imageUrl: 'assets/images/racing.png',
    membersCount: 1420,
    eventsCount: 4,
  ),
  CommunityModel(
    id: 'elite-breast-cancer',
    title: 'Breast Cancer Awareness Riders',
    description: 'Annual pink rides & fundraising',
    type: 'Elite Community',
    category: const ['awareness', 'health', 'fundraising'],
    imageUrl: 'assets/images/ride_events.png',
    membersCount: 530,
    eventsCount: 2,
  ),
];
