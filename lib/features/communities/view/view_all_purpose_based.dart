import 'package:adcc/core/constants/cosmatic_imgs.dart';
import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/features/communities/constants/community_categories.dart';
import 'package:adcc/features/communities/models/community_model.dart';
import 'package:adcc/features/communities/sections/community_list_card.dart';
import 'package:adcc/features/communities/view/community_type_details.dart';
import 'package:adcc/shared/widgets/adaptive_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ViewAllPurposeCommunitiesScreen extends StatefulWidget {
  final String title;
  final List<CommunityModel> communities;

  const ViewAllPurposeCommunitiesScreen({
    super.key,
    required this.title,
    required this.communities,
  });

  @override
  State<ViewAllPurposeCommunitiesScreen> createState() =>
      _ViewAllPurposeCommunitiesScreenState();
}

class _ViewAllPurposeCommunitiesScreenState
    extends State<ViewAllPurposeCommunitiesScreen> {
  int selectedIndex = 0;
  bool _hasTypeSelection = false;

  List<String> get _purposeCategories {
    final seen = <String>{};

    for (final community in widget.communities) {
      for (final rawCategory in community.category) {
        final normalized = _normalizeCommunityCategory(rawCategory.toString());
        if (normalized == null) continue;
        seen.add(normalized);
      }
    }

    return purposeBasedCommunityCategories
        .where(seen.contains)
        .toList(growable: false);
  }

  List<String> get _categoryFilters {
    return ['All', ..._purposeCategories];
  }

  Map<String, String> get _categoryImages {
    final images = <String, String>{};

    for (final community in widget.communities) {
      final imageUrl = community.imageUrl?.trim().isNotEmpty == true
          ? community.imageUrl!
          : (community.logo?.trim().isNotEmpty == true ? community.logo! : null);
      if (imageUrl == null) continue;

      for (final rawCategory in community.category) {
        final normalized = _normalizeCommunityCategory(rawCategory.toString());
        if (normalized == null || !purposeBasedCommunityCategories.contains(normalized) ||
            images.containsKey(normalized)) continue;
        images[normalized] = imageUrl;
      }
    }

    return images;
  }

  List<CommunityModel> get filteredList {
    final all = widget.communities;
    if (all.isEmpty) return [];
    if (selectedIndex == 0) return all;

    final selectedCategory = _categoryFilters[selectedIndex];

    final filtered = all.where((community) {
      return community.category
          .map((category) => _normalizeCommunityCategory(category.toString()))
          .contains(selectedCategory);
    }).toList();

    if (filtered.isEmpty) return all;
    return filtered;
  }

  String _categoryImagePath(String category) {
    if (category.toLowerCase() == 'all') {
      return 'assets/images/purpose-based-communities.png';
    }

    return _categoryImages[category] ??
        purposeBasedCommunityCategoryImages[category] ??
        'assets/images/community_ride.png';
  }

  String? _normalizeCommunityCategory(String? rawCategory) {
    if (rawCategory == null) return null;
    final value = rawCategory.trim().toLowerCase();
    if (value.isEmpty) return null;

    if (value.contains('city communities')) return 'City Communities';
    if (value.contains('group communities')) return 'Group Communities';
    if (value.contains('family') || value.contains('leisure') || value.contains('kids')) {
      return 'Family & Leisure';
    }
    if (value.contains('women') || value.contains('she')) return 'Women (SheRides)';
    if (value.contains('youth') || value.contains('cycling')) return 'Youth';
    if (value.contains('social') || value.contains('weekend')) return 'Social / Weekend';
    if (value.contains('night')) return 'Night Riders';
    if (value.contains('mtb') || value.contains('trail')) return 'MTB / Trail';
    if (value.contains('training') || value.contains('clinic')) return 'Training & Clinics';
    if (value.contains('awareness') || value.contains('special') || value.contains('charity')) {
      return 'Awareness & Charity';
    }
    if (value.contains('corporate')) return 'Corporate';
    if (value.contains('education')) return 'Education';
    if (value.contains('health')) return 'Health';
    if (value.contains('racing') || value.contains('performance')) return 'Racing & Performance';

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
     
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: CachedNetworkImageProvider(
              CommunitiesImgs.AllcommunityBackground,
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              sliver: SliverToBoxAdapter(
                child: _PurposeCommunitiesHero(
                  imagePath: 'assets/images/purpose-based-communities.png',
                  title: widget.title,
                  subtitle: 'Communities based on purpose and goals',
                  onBackTap: () => Navigator.pop(context),
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.zero,
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 30),
                  _PurposeCategoryStrip(
                    categories: _categoryFilters,
                    selectedIndex: selectedIndex,
                    categoryImageBuilder: _categoryImagePath,
                    onSelected: (index) {
                      setState(() {
                        _hasTypeSelection = index != 0;
                        selectedIndex = index;
                      });
                    },
                  ),
                  const SizedBox(height: 26),
                  _buildHeader(),
                  const SizedBox(height: 24),
                ]),
              ),
            ),
            _buildList(),
          ],
        ),
      ),
    ),);
  }

  Widget _buildHeader() {
    final list = filteredList;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _hasTypeSelection
                ? '${list.length} communities found'
                : 'Explore Communities',
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 15,
              fontWeight: FontWeight.w500,
              height: 1.25,
              letterSpacing: 0,
              color: AppColors.charcoal,
            ),
          ),
          Text(
            _categoryFilters[selectedIndex],
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 15,
              fontWeight: FontWeight.w500,
              height: 1.25,
              letterSpacing: 0,
              color: Color(0XFFCF9F0C),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList() {
    final list = filteredList;

    if (list.isEmpty) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Text(
            'No communities found',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final community = list[index];
            return Padding(
              padding: EdgeInsets.only(
                bottom: index < list.length - 1 ? 25 : 84,
              ),
              child: CommunityListCard(
                community: community,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CommunityCityDetails(community: community),
                    ),
                  );
                },
              ),
            );
          },
          childCount: list.length,
        ),
      ),
    );
  }
}

class _PurposeCommunitiesHero extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final VoidCallback onBackTap;

  const _PurposeCommunitiesHero({
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.onBackTap,
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
            AdaptiveImage(
              imagePath: imagePath,
              fit: BoxFit.cover,
            ),
            const Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 96,
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
                    color: Color(0xFF02A2CF),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 10,
              right: 10,
              bottom: 43,
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
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
              bottom: 20,
              child: Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Satoshi',
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

class _PurposeCategoryStrip extends StatelessWidget {
  final List<String> categories;
  final int selectedIndex;
  final String Function(String category) categoryImageBuilder;
  final ValueChanged<int> onSelected;

  const _PurposeCategoryStrip({
    required this.categories,
    required this.selectedIndex,
    required this.categoryImageBuilder,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 119,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final category = categories[index];
          final selected = selectedIndex == index;
          return GestureDetector(
            onTap: () => onSelected(index),
            child: Container(
              width: 92,
              height: 109.17,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.36),
                border: Border.all(
                  color: selected ? Colors.black : const Color(0xFFD7D7D7),
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
                        imagePath: categoryImageBuilder(category),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 18,
                    child: Center(
                      child: Text(
                        category,
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
        },
      ),
    );
  }

}
