import 'package:adcc/core/constants/cosmatic_imgs.dart';
import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/features/communities/models/community_model.dart';
import 'package:adcc/features/communities/view/community_type_details.dart';
import 'package:adcc/features/communities/view/view_all_communities_screen.dart';
import 'package:adcc/features/communities/view/view_all_purpose_based.dart';
import 'package:adcc/features/communities/services/communities_service.dart';
import 'package:adcc/shared/widgets/adaptive_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class CommunitiesScreen extends StatefulWidget {
  const CommunitiesScreen({super.key});

  @override
  State<CommunitiesScreen> createState() => _CommunitiesScreenState();
}

class _CommunitiesScreenState extends State<CommunitiesScreen> {
  int selectedFilterIndex = 0;
  String searchQuery = '';

  bool _isLoading = true;
  String? _errorMessage;

  final CommunitiesService _communitiesService = CommunitiesService();

  List<CommunityModel> _cityCommunities = [];
  List<CommunityModel> _groupCommunities = [];
  List<String> _communityCategories = [];
  Map<String, String> _categoryImages = {};

  List<CommunityModel> _allCommunities = [];
  String? _selectedCategory;

  static const List<String> _providedCategoryImageUrls = [
    'https://projet-adcc-image.s3.me-central-1.amazonaws.com/content/1-1781532636129-c5cadcbfd942.jfif',
    'https://projet-adcc-image.s3.me-central-1.amazonaws.com/content/2-1781532636663-10091017b61a.jfif',
    'https://projet-adcc-image.s3.me-central-1.amazonaws.com/content/6-1781532638130-147b1aea8e78.jfif',
    'https://projet-adcc-image.s3.me-central-1.amazonaws.com/content/5-1781532637733-ed19f7a77a5c.jfif',
    'https://projet-adcc-image.s3.me-central-1.amazonaws.com/content/4-1781532637356-e8cb3e82b340.jfif',
    'https://projet-adcc-image.s3.me-central-1.amazonaws.com/content/3-1781532637019-37f4ba925dc4.jfif',
    'https://projet-adcc-image.s3.me-central-1.amazonaws.com/content/7-1781532638497-a41b59dfcca5.jfif',
    'https://projet-adcc-image.s3.me-central-1.amazonaws.com/content/12-1781532644463-56ba5130bf39.jfif',
    'https://projet-adcc-image.s3.me-central-1.amazonaws.com/content/10-1781532643582-cd6b24554f61.jfif',
    'https://projet-adcc-image.s3.me-central-1.amazonaws.com/content/11-1781532644058-49ff207e67ad.jfif',
  ];

  final List<String> filterPills = const [
    'All',
    'Abu Dhabi',
    'Al Ain',
    'Western Region',
  ];

  @override
  void initState() {
    super.initState();
    _loadAllSections();
    _loadCommunityCategories();
  }

  Future<void> _loadAllSections() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await _communitiesService.getCommunities();

      if (!mounted) return;

      List<CommunityModel> parse(dynamic resData) {
        final raw = resData;

        List<dynamic> communitiesList = [];

        if (raw is Map<String, dynamic>) {
          if (raw['data'] is Map &&
              (raw['data'] as Map).containsKey('communities') &&
              (raw['data'] as Map)['communities'] is List) {
            communitiesList = (raw['data'] as Map)['communities'] as List;
          } else if (raw['communities'] is List) {
            communitiesList = raw['communities'] as List;
          }
        } else if (raw is List) {
          communitiesList = raw;
        }

        return communitiesList
            .whereType<Map<String, dynamic>>()
            .map((e) => CommunityModel.fromJson(e))
            .toList();
      }

      if (!result.success || result.data == null) {
        setState(() {
          _isLoading = false;
          _errorMessage = "Failed to load communities";
        });
        return;
      }

      final allList = parse(result.data);
      final cityList = _selectCityCommunities(allList);
      final groupList = _selectPurposeCommunities(allList);

      setState(() {
        _isLoading = false;

        _allCommunities = allList;
        _cityCommunities = cityList.isNotEmpty ? cityList : allList;
        _groupCommunities = groupList.isNotEmpty
            ? groupList
            : allList
                .where((community) => !_isCityCommunity(community))
                .toList();

        _categoryImages = _resolveCategoryImages(
          categories: _communityCategories,
          fallbackFromCommunities: _extractCategoryImagesFromCommunities(
            allList,
          ),
        );

        _errorMessage = null;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage = "Unexpected error: $e";
      });
    }
  }

  Future<void> _loadCommunityCategories() async {
    try {
      final result = await _communitiesService.getCommunityCategories();

      if (!mounted) return;

      if (result.success && (result.data?.isNotEmpty ?? false)) {
        setState(() {
          _communityCategories = result.data!;
          _categoryImages = _resolveCategoryImages(
            categories: _communityCategories,
            fallbackFromCommunities: _extractCategoryImagesFromCommunities(
              _allCommunities,
            ),
          );
        });
      }
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _communityCategories = [];
        _categoryImages = _resolveCategoryImages(
          categories: _communityCategories,
          fallbackFromCommunities: _extractCategoryImagesFromCommunities(
            _allCommunities,
          ),
        );
      });
    }
  }

  Map<String, String> _resolveCategoryImages({
    required List<String> categories,
    required Map<String, String> fallbackFromCommunities,
  }) {
    if (categories.isEmpty) return fallbackFromCommunities;

    final map = <String, String>{};

    for (var i = 0; i < categories.length; i++) {
      final category = categories[i];
      final normalized = category.trim();
      if (normalized.isEmpty) continue;

      if (i < _providedCategoryImageUrls.length) {
        map[normalized] = _providedCategoryImageUrls[i];
      } else if (fallbackFromCommunities.containsKey(normalized)) {
        map[normalized] = fallbackFromCommunities[normalized]!;
      }
    }

    return map;
  }

  Map<String, String> _extractCategoryImagesFromCommunities(
      List<CommunityModel> communities) {
    final images = <String, String>{};

    for (final community in communities) {
      final imageUrl = community.imageUrl?.trim().isNotEmpty == true
          ? community.imageUrl!
          : (community.logo?.trim().isNotEmpty == true
              ? community.logo!
              : null);
      if (imageUrl == null) continue;

      for (final category in community.category) {
        final key = category.trim();
        if (key.isEmpty || images.containsKey(key)) continue;
        images[key] = imageUrl;
      }
    }

    return images;
  }

  List<CommunityModel> _applySearch(List<CommunityModel> input) {
    if (searchQuery.trim().isEmpty) return input;

    final q = searchQuery.trim().toLowerCase();

    return input.where((c) {
      return c.title.toLowerCase().contains(q) ||
          c.description.toLowerCase().contains(q) ||
          c.category.any((cat) => cat.toLowerCase().contains(q)) ||
          c.type.toLowerCase().contains(q) ||
          (c.location ?? '').toLowerCase().contains(q) ||
          (c.trackName ?? '').toLowerCase().contains(q) ||
          (c.terrain ?? '').toLowerCase().contains(q) ||
          (c.distance?.toString() ?? '').contains(q);
    }).toList();
  }

  List<CommunityModel> _applyCityPills(List<CommunityModel> input) {
    if (selectedFilterIndex == 0) return input;

    final selected = filterPills[selectedFilterIndex].toLowerCase();

    return input.where((c) {
      return (c.location ?? '').toLowerCase().contains(selected);
    }).toList();
  }

  List<CommunityModel> _selectCityCommunities(List<CommunityModel> source) {
    final filtered = source.where(_isCityCommunity).toList();
    return filtered.take(8).toList();
  }

  List<CommunityModel> _selectPurposeCommunities(List<CommunityModel> source) {
    final filtered = source.where(_isPurposeCommunity).toList();
    return filtered.take(8).toList();
  }

  bool _isCityCommunity(CommunityModel community) {
    final values = _communitySearchValues(community);
    const cityKeys = [
      'abu dhabi',
      'al ain',
      'western region',
      'city',
      'urban',
    ];

    return cityKeys.any(values.contains);
  }

  bool _isPurposeCommunity(CommunityModel community) {
    final values = _communitySearchValues(community);
    const purposeKeys = [
      'group',
      'community',
      'ride',
      'social',
      'weekend',
      'family',
      'women',
      'she',
      'youth',
      'training',
      'clinic',
      'corporate',
      'awareness',
      'charity',
      'national',
      'education',
      'health',
      'racing',
      'performance',
    ];

    return purposeKeys.any(values.contains);
  }

  String _communitySearchValues(CommunityModel community) {
    return [
      community.title,
      community.description,
      community.type,
      community.location ?? '',
      community.city ?? '',
      community.area ?? '',
      community.trackName ?? '',
      community.terrain ?? '',
      ...community.category,
    ].join(' ').toLowerCase();
  }

  List<CommunityModel> get _filteredCityCommunities =>
      _applySearch(_applyCityPills(_cityCommunities));

  List<CommunityModel> get _filteredGroupCommunities =>
      _applySearch(_groupCommunities);

  List<CommunityModel> _applyCategoryFilter(List<CommunityModel> input) {
    final selected = _selectedCategory;
    if (selected == null || selected.isEmpty) return input;

    return input
        .where((community) => _categoryMatchesCommunity(selected, community))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: CachedNetworkImageProvider(
              CommunitiesImgs.communityBackground,
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: _isLoading
            ? const _CommunitiesLoadingUI()
            : (_errorMessage != null
                ? _CommunitiesErrorUI(
                    message: _errorMessage!,
                    onRetry: _loadAllSections,
                  )
                : _buildMainUI(context)),
      ),
    );
  }

  Widget _buildMainUI(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.zero,
      children: [
        _CommunitiesTopBlock(
          searchValue: searchQuery,
          onSearchChanged: (value) => setState(() => searchQuery = value),
          categories: _displayCategories,
          selectedCategory: _selectedCategory,
          onCategoryTap: _openCategoryCommunities,
          categoryImageBuilder: _categoryImagePath,
        ),
        const SizedBox(height: 32),
        _SectionTitleRow(
          title: 'Communities in Your City',
          onViewAll: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ViewAllCommunitiesScreen(
                  title: 'Communities in Your City',
                  communities: _filteredCityCommunities,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 22),
        _CityCommunitiesCarousel(
          communities: _displayCityCommunities,
          onExplore: (community) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CommunityCityDetails(community: community),
              ),
            );
          },
        ),
        const SizedBox(height: 47),
        _SectionTitleRow(
          title: 'Purpose-Based Communities',
          onViewAll: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ViewAllPurposeCommunitiesScreen(
                  title: "Purpose-Based Communities",
                  communities: _filteredGroupCommunities,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 25),
        _buildGroupCommunitiesSection(),
        const SizedBox(height: 105),
      ],
    );
  }

  Widget _buildGroupCommunitiesSection() {
    final groupCommunities = _displayPurposeCommunities;

    if (groupCommunities.isEmpty) {
      return const SizedBox(
        height: 120,
        child: Center(
          child: Text(
            'No community groups found',
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
          ),
        ),
      );
    }

    return SizedBox(
      height: 218,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: groupCommunities.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final community = groupCommunities[index];

          return _PurposeCommunityCard(
            defaultImagePath: CommunitiesImgs.communitycardBackground,
            community: community,
            accentColor: const Color.fromARGB(0, 196, 231, 245),
            
            // Use black text for all purpose-based cards
            foregroundColor: Colors.black,
            // Use the approved blue for button background and white for text
            buttonColor: const Color(0xFFFF78A1),
            buttonTextColor: Colors.white,
            onExplore: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CommunityCityDetails(community: community),
                ),
              );
            },
          );
        },
      ),
    );
  }

  List<CommunityModel> get _displayCityCommunities {
    // Always show filtered results from API only - no fallbacks
    return _applyCategoryFilter(_filteredCityCommunities);
  }

  List<CommunityModel> get _displayPurposeCommunities {
    // Always show filtered results from API only - no fallbacks
    return _applyCategoryFilter(_filteredGroupCommunities);
  }

  List<String> get _displayCategories {
    return _communityCategories;
  }

  String _categoryImagePath(String category) {
    return _categoryImages[category] ?? '';
  }

  void _openCategoryCommunities(String category) {
    setState(() {
      if (_selectedCategory == category) {
        _selectedCategory = null;
      } else {
        _selectedCategory = category;
      }
    });
  }

  bool _categoryMatchesCommunity(String category, CommunityModel community) {
    final selected = category.toLowerCase();

    if (community.category.any((rawCategory) {
      final normalized = _normalizeCommunityCategory(rawCategory.toString());
      return normalized?.toLowerCase() == selected;
    })) {
      return true;
    }

    final lowerTitle = community.title.toLowerCase();
    final lowerDescription = community.description.toLowerCase();
    return lowerTitle.contains(selected) || lowerDescription.contains(selected);
  }

  String? _normalizeCommunityCategory(String? rawCategory) {
    if (rawCategory == null) return null;
    final value = rawCategory.trim().toLowerCase();
    if (value.isEmpty) return null;

    if (value.contains('city communities')) return 'City Communities';
    if (value.contains('group communities')) return 'Group Communities';
    if (value.contains('family') ||
        value.contains('leisure') ||
        value.contains('kids')) {
      return 'Family & Leisure';
    }
    if (value.contains('women') || value.contains('she'))
      return 'Women (SheRides)';
    if (value.contains('youth') || value.contains('cycling')) return 'Youth';
    if (value.contains('social') || value.contains('weekend'))
      return 'Social / Weekend';
    if (value.contains('night')) return 'Night Riders';
    if (value.contains('mtb') || value.contains('trail')) return 'MTB / Trail';
    if (value.contains('training') || value.contains('clinic'))
      return 'Training & Clinics';
    if (value.contains('awareness') ||
        value.contains('special') ||
        value.contains('charity')) {
      return 'Awareness & Charity';
    }
    if (value.contains('corporate')) return 'Corporate';
    if (value.contains('education')) return 'Education';
    if (value.contains('health')) return 'Health';
    if (value.contains('racing') || value.contains('performance'))
      return 'Racing & Performance';

    return null;
  }
}

class _CommunitiesTopBlock extends StatelessWidget {
  final String searchValue;
  final ValueChanged<String> onSearchChanged;
  final List<String> categories;
  final String? selectedCategory;
  final ValueChanged<String> onCategoryTap;
  final String Function(String category) categoryImageBuilder;

  const _CommunitiesTopBlock({
    required this.searchValue,
    required this.onSearchChanged,
    required this.categories,
    required this.selectedCategory,
    required this.onCategoryTap,
    required this.categoryImageBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 358,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: _CommunitiesHero(
              searchValue: searchValue,
              onChanged: onSearchChanged,
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            top: 221,
            child: _CommunityTypeStrip(
              categories: categories,
              selectedCategory: selectedCategory,
              onCategoryTap: onCategoryTap,
              categoryImageBuilder: categoryImageBuilder,
            ),
          ),
        ],
      ),
    );
  }
}

class _CommunitiesHero extends StatelessWidget {
  final String searchValue;
  final ValueChanged<String> onChanged;

  const _CommunitiesHero({
    required this.searchValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 289,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: CachedNetworkImageProvider(
            CommunitiesImgs.communityheaderbackground,
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          //TODO: Temporarily disable back arrow navigation. Re-enable when required.
          // Positioned(
          //   top: 54,
          //   left: 16,
          //   child: IconButton(
          //     padding: EdgeInsets.zero,
          //     constraints: const BoxConstraints.tightFor(
          //       width: 24,
          //       height: 24,
          //     ),
          //     icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
          //     onPressed: () {
          //       if (kDebugMode) debugPrint('[UI] CommunitiesHero back pressed');

          //       // Prefer a regular pop if possible. If this screen is hosted
          //       // inside a nested navigator (e.g. tab navigator), fall back
          //       // to attempting a pop on the root navigator so the expected
          //       // back navigation still works.
          //       if (Navigator.canPop(context)) {
          //         Navigator.pop(context);
          //         if (kDebugMode) debugPrint('[UI] CommunitiesHero popped route');
          //       } else {
          //         Navigator.of(context, rootNavigator: true).maybePop();
          //       }
          //     },
          //   ),
          // ),

          const Positioned(
            top: 78,
            left: 0,
            right: 0,
            child: Text(
              'Communities',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 28,
                fontWeight: FontWeight.w600,
                height: 1.25,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            top: 146,
            child: _GlassSearchField(
              value: searchValue,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassSearchField extends StatefulWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const _GlassSearchField({
    required this.value,
    required this.onChanged,
  });

  @override
  State<_GlassSearchField> createState() => _GlassSearchFieldState();
}

class _GlassSearchFieldState extends State<_GlassSearchField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(covariant _GlassSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && _controller.text != widget.value) {
      _controller.text = widget.value;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 38,
        color: Colors.white.withValues(alpha: 0.21),
        padding: const EdgeInsets.symmetric(horizontal: 11),
        child: Row(
          children: [
            Container(
              width: 23.5,
              height: 23.5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.24),
              ),
              child: const Icon(Icons.search, size: 14, color: Colors.white),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: TextField(
                controller: _controller,
                onChanged: widget.onChanged,
                cursorColor: Colors.white,
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 12,
                  color: Colors.white,
                ),
                decoration: const InputDecoration(
                  hintText: 'Search events, communities, cities, or tracks...',
                  hintStyle: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    height: 1.25,
                    letterSpacing: -0.1,
                    color: Colors.white,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CommunityTypeStrip extends StatelessWidget {
  final List<String> categories;
  final String? selectedCategory;
  final ValueChanged<String> onCategoryTap;
  final String Function(String category) categoryImageBuilder;

  const _CommunityTypeStrip({
    required this.categories,
    required this.selectedCategory,
    required this.onCategoryTap,
    required this.categoryImageBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 136,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(13, 17, 0, 10),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final category = categories[index];
          return _CommunityTypeCard(
            title: category,
            imagePath: categoryImageBuilder(category),
            isSelected: category == selectedCategory,
            onTap: () => onCategoryTap(category),
          );
        },
      ),
    );
  }
}

class _CommunityTypeCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final bool isSelected;
  final VoidCallback onTap;

  const _CommunityTypeCard({
    required this.title,
    required this.imagePath,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 92,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.36),
          border: Border.all(
            color:
                isSelected ? const Color(0xFF0359E8) : const Color(0x800359E8),
            width: 0.61,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(6),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(7.36),
                child: imagePath.isNotEmpty
                    ? AdaptiveImage(
                        imagePath: imagePath,
                        width: 80,
                        height: 75,
                        fit: BoxFit.cover,
                        placeholderColor: const Color(0xFFE5E7EB),
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
                  _compactTypeTitle(title),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                    height: 1,
                    color: isSelected
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
  }
}

String _compactTypeTitle(String title) {
  final t = title.trim();
  if (t.toLowerCase().contains('women')) return 'Women\n(SheRides)';
  if (t.toLowerCase().contains('racing')) return 'Racing &\nPerformance';
  if (t.toLowerCase().contains('training')) return 'Training &\nClinics';
  if (t.toLowerCase().contains('community rides')) return 'Community\nRides';
  if (t.toLowerCase().contains('awareness')) return 'Awareness\nRides';
  return t;
}

// Community type defaults removed - now using API data only

class _SectionTitleRow extends StatelessWidget {
  final String title;
  final VoidCallback onViewAll;

  const _SectionTitleRow({
    required this.title,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Outfit',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                height: 1.25,
                color: Color(0xFF333333),
              ),
            ),
          ),
          TextButton(
            onPressed: onViewAll,
            style: TextButton.styleFrom(
              minimumSize: Size.zero,
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Row(
              children: [
                Text(
                  'View All',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF484A4D),
                  ),
                ),
                SizedBox(width: 4),
                Icon(Icons.chevron_right, size: 16, color: Color(0xFF484A4D)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CityCommunitiesCarousel extends StatelessWidget {
  final List<CommunityModel> communities;
  final ValueChanged<CommunityModel> onExplore;

  const _CityCommunitiesCarousel({
    required this.communities,
    required this.onExplore,
  });

  @override
  Widget build(BuildContext context) {
    if (communities.isEmpty) {
      return const SizedBox(
        height: 140,
        child: Center(
          child: Text(
            'No communities found',
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
          ),
        ),
      );
    }

    return SizedBox(
      height: 363,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const BouncingScrollPhysics(),
        itemCount: communities.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final community = communities[index];
          return _CityCommunityCard(
            community: community,
            onExplore: () => onExplore(community),
          );
        },
      ),
    );
  }
}

class _CityCommunityCard extends StatelessWidget {
  final CommunityModel community;
  final VoidCallback onExplore;

  const _CityCommunityCard({
    required this.community,
    required this.onExplore,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onExplore,
      child: Container(
        width: 248,
        height: 363,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: const Color(0xFFA9907E),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            AdaptiveImage(
              imagePath: community.imageUrl ?? 'assets/images/no-img.jpg',
              fit: BoxFit.cover,
              placeholderColor: const Color(0xFFA9907E),
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x00000000),
                    Color(0x00000000),
                    Color(0xCC000000),
                  ],
                  stops: [0, 0.45, 1],
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 103,
              child: Text(
                community.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  height: 1.25,
                  color: Colors.white,
                ),
              ),
            ),
            Positioned(
              left: 16,
              bottom: 73,
              child: _MetaText(
                icon: Icons.people_alt_rounded,
                text: '${_formatMembers(community.membersCount ?? 0)} Members',
                color: Colors.white,
              ),
            ),
            Positioned(
              left: 16,
              bottom: 22,
              child: SizedBox(
                width: 143,
                height: 34,
                child: ElevatedButton(
                  onPressed: onExplore,
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: const Color(0xFFFF78A1),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9.1),
                      side: const BorderSide(color: Color(0xFFFF78A1)),
                    ),
                  ),
                  child: const Text(
                    'Explore Community',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 1.28,
                    ),
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

class _PurposeCommunityCard extends StatelessWidget {
  final CommunityModel community;
  final Color accentColor;
  final Color foregroundColor;
  final Color buttonColor;
  final Color buttonTextColor;
  final VoidCallback onExplore;
  final String defaultImagePath ;

  const _PurposeCommunityCard({
    required this.community,
    required this.accentColor,
    required this.foregroundColor,
    required this.buttonColor,
    required this.buttonTextColor,
    required this.onExplore,
    required this.defaultImagePath,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onExplore,
      child: Container(
        width: 358,
        height: 218,
        decoration: BoxDecoration(
          color: accentColor,
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: CachedNetworkImageProvider(
               defaultImagePath
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 14,
              top: 18,
              width: 170,
              child: Text(
                community.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  height: 1.27,
                  color: foregroundColor,
                ),
              ),
            ),
            Positioned(
              left: 14,
              top: 116,
              child: _MetaText(
                icon: Icons.people_alt_rounded,
                text: '${_formatMembers(community.membersCount ?? 0)} members',
                color: foregroundColor,
              ),
            ),
            Positioned(
              left: 14,
              top: 141,
              child: _MetaText(
                icon: Icons.calendar_month_rounded,
                text: '${community.eventsCount ?? 0} events',
                color: foregroundColor,
              ),
            ),
            Positioned(
              left: 14,
              bottom: 15,
              child: SizedBox(
                width: 142,
                height: 29,
                child: ElevatedButton(
                  onPressed: onExplore,
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    padding: EdgeInsets.zero,
                    backgroundColor: Color(0xffFF78A1),
                    foregroundColor: buttonTextColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(17.3),
                    ),
                  ),
                  child: Text(
                    'Explore Community +',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      height: 1.25,
                      color: buttonTextColor,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 12,
              top: 12,
              child: Container(
                width: 141,
                height: 194,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: AdaptiveImage(
                  imagePath: community.imageUrl ?? 'assets/images/no-img.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetaText extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _MetaText({
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 13,
            fontWeight: FontWeight.w400,
            height: 1.23,
            color: color,
          ),
        ),
      ],
    );
  }
}

String _formatMembers(int number) {
  if (number <= 0) return '0';
  if (number >= 1000) {
    final short = number / 1000;
    if (short == short.roundToDouble()) return '${short.toInt()}K';
    return '${short.toStringAsFixed(1)}K';
  }
  return number.toString();
}

// Fallback city communities removed - now using API data only

// Fallback purpose-based communities removed - now using API data only

class _CommunitiesLoadingUI extends StatelessWidget {
  const _CommunitiesLoadingUI();

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      children: [
        const SizedBox(height: 16),

        // Banner placeholder
        Container(
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F2F4),
            borderRadius: BorderRadius.circular(18),
          ),
        ),

        const SizedBox(height: 24),

        // Section title placeholder
        Container(
          height: 18,
          width: 220,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F2F4),
            borderRadius: BorderRadius.circular(8),
          ),
        ),

        const SizedBox(height: 16),

        // Big card placeholder
        Container(
          height: 220,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F2F4),
            borderRadius: BorderRadius.circular(18),
          ),
        ),

        const SizedBox(height: 24),

        // Another section
        Container(
          height: 18,
          width: 260,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F2F4),
            borderRadius: BorderRadius.circular(8),
          ),
        ),

        const SizedBox(height: 16),

        Container(
          height: 140,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F2F4),
            borderRadius: BorderRadius.circular(18),
          ),
        ),

        const SizedBox(height: 24),

        Container(
          height: 18,
          width: 240,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F2F4),
            borderRadius: BorderRadius.circular(8),
          ),
        ),

        const SizedBox(height: 16),

        SizedBox(
          height: 250,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              return Container(
                width: 220,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F2F4),
                  borderRadius: BorderRadius.circular(18),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CommunitiesErrorUI extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _CommunitiesErrorUI({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 44, color: Colors.redAccent),
            const SizedBox(height: 14),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.goldenOchre,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                "Retry",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
