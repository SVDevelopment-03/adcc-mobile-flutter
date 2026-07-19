import 'dart:async';

import 'package:adcc/core/constants/cosmatic_imgs.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:adcc/features/club_store/models/cart_item_model.dart';
import 'package:adcc/features/club_store/repositories/cart_repository.dart';
import 'package:adcc/features/club_store/view/cart_screen.dart';
import 'package:adcc/features/club_store/repositories/club_store_repository.dart';
import 'package:adcc/features/club_store/view/view_all_products_screen.dart';
import 'package:adcc/features/store/models/store_item_model.dart';
import 'package:adcc/shared/widgets/adaptive_image.dart';

import 'product_banner_carousel.dart';
import 'product_card.dart';
import 'details_screen.dart';

class ClubStoreMarchindiesScreen extends StatefulWidget {
  const ClubStoreMarchindiesScreen({super.key});

  @override
  State<ClubStoreMarchindiesScreen> createState() =>
      _ClubStoreMarchindiesScreenState();
}

class _ClubStoreMarchindiesScreenState
    extends State<ClubStoreMarchindiesScreen> {
  int selectedCategoryIndex = 0;
  String searchText = '';
  bool isLoading = true;
  String? errorMessage;

  final ClubStoreRepository _repository = ClubStoreRepository();
  final TextEditingController _searchController = TextEditingController();
  final List<StoreItemModel> _merchandise = [];
  static const _allCategoryImage = 'assets/images/club-category.png';

  final List<MerchandiseCategory> categoryChips = [
    MerchandiseCategory(name: 'All', image: _allCategoryImage),
  ];
  final List<ProductBannerModel> _productBanners = [];

  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _loadMerchandise();
    _loadProductBanners();
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await _repository.fetchMerchandiseCategories();
      setState(() {
        categoryChips
          ..clear()
          ..add(MerchandiseCategory(name: 'All', image: _allCategoryImage))
          ..addAll(categories);
      });
    } catch (_) {
      // Ignore category load failure, fall back to extracted categories.
    }
  }

  Future<void> _loadMerchandise() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final items = await _repository.fetchMerchandise(
        search: searchText,
        category: selectedCategoryIndex > 0
            ? categoryChips[selectedCategoryIndex].name
            : null,
        page: 1,
        limit: 20,
      );

      setState(() {
        _merchandise
          ..clear()
          ..addAll(items);
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        errorMessage = 'Failed to load merchandise. Please try again.';
        isLoading = false;
      });
    }
  }

  Future<void> _loadProductBanners() async {
    try {
      final banners = await _repository.fetchProductBanners();
      setState(() {
        _productBanners
          ..clear()
          ..addAll(banners);
      });
    } catch (_) {
      // Ignore banner load failure.
    }
  }

  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();
    searchText = value;
    _searchDebounce =
        Timer(const Duration(milliseconds: 400), _loadMerchandise);
  }

  void _onCategorySelected(int index) {
    setState(() => selectedCategoryIndex = index);
    _loadMerchandise();
  }

  Color _colorForItem(int index) {
    const colors = [
      Color(0xFF5A738E),
      Color(0xFF7E8FA3),
      Color(0xFF37475A),
      Color(0xFF215D8E),
      Color(0xFF4B6478),
    ];
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBF4FF),
      floatingActionButton: ValueListenableBuilder<List<CartItemModel>>(
        valueListenable: ClubStoreCartRepository.instance.items,
        builder: (context, items, _) {
          return FloatingActionButton.extended(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ClubStoreCartScreen()),
              );
            },
            backgroundColor: const Color(0xFF455A78),
            label: Row(
              children: [
                const Icon(Icons.shopping_cart_outlined,
                    size: 20, color: Colors.white),
                if (items.isNotEmpty) ...[
                  const SizedBox(width: 8),
                  Text('${items.length}',
                      style:
                          const TextStyle(color: Colors.white, fontSize: 14)),
                ],
              ],
            ),
          );
        },
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 377,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                _ClubStoreHero(
                  searchController: _searchController,
                  onSearchChanged: _onSearchChanged,
                ),
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 0,
                  child: _MerchandiseCategoryCard(
                    categories: categoryChips,
                    selectedCategoryIndex: selectedCategoryIndex,
                    onCategorySelected: _onCategorySelected,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ProductBannerCarousel(
              items: _productBanners.isNotEmpty
                  ? _productBanners
                      .map(
                        (banner) => ProductBannerData(
                          imageUrl: banner.image,
                        ),
                      )
                      .toList()
                  : const [],
            ),
          ),
          const SizedBox(height: 18),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Latest Products',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1C20),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ClubStoreAllProductsScreen(),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    foregroundColor: const Color(0xFF435974),
                  ),
                  child: const Text(
                    'View all',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isLoading)
                  const SizedBox(
                    height: 260,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (errorMessage != null)
                  SizedBox(
                    height: 260,
                    child: Center(
                      child: Text(
                        errorMessage!,
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 14,
                          color: Color(0xFF7B8794),
                        ),
                      ),
                    ),
                  )
                else if (_merchandise.isEmpty)
                  const SizedBox(
                    height: 260,
                    child: Center(
                      child: Text(
                        'No club merchandise found.',
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 14,
                          color: Color(0xFF7B8794),
                        ),
                      ),
                    ),
                  )
                else
                  SizedBox(
                    height: 339,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: _merchandise.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final item = _merchandise[index];
                        return ProductCard(
                          data: ProductCardData(
                            title: item.title,
                            price: item.price,
                            image: item.image,
                            color: _colorForItem(index),
                            isOutOfStock: item.isOutOfStock,
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    ClubStoreDetailsScreen(item: item),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Featured Products',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1C20),
                  ),
                ),
                const SizedBox(height: 12),
                Builder(
                  builder: (context) {
                    final featuredItems =
                        _merchandise.where((item) => item.featured).toList();
                    if (featuredItems.isEmpty) {
                      return const SizedBox(
                        height: 120,
                        child: Center(
                          child: Text(
                            'No featured products available.',
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 14,
                              color: Color(0xFF7B8794),
                            ),
                          ),
                        ),
                      );
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.only(top: 12),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.67,
                      ),
                      itemCount: featuredItems.length,
                      itemBuilder: (context, index) {
                        final item = featuredItems[index];
                        return ProductCard(
                          data: ProductCardData(
                            title: item.title,
                            price: item.price,
                            image: item.image,
                            color: _colorForItem(index),
                            isOutOfStock: item.isOutOfStock,
                          ),
                          isSmall: true,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    ClubStoreDetailsScreen(item: item),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Merchandise coming soon',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1C20),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Use the search bar and category chips above to explore club store items.',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF4B5563),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

class _ClubStoreHero extends StatelessWidget {
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;

  const _ClubStoreHero({
    required this.searchController,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 289,
      decoration: const BoxDecoration(
          image: DecorationImage(
        image:
            CachedNetworkImageProvider(rideFeedImgs.rideFeedheaderbackground),
        fit: BoxFit.cover,
        colorFilter: ColorFilter.mode(
          Color(0xFF435974),
          BlendMode.dstOver, // or multiply, overlay, modulate, etc.
        ),
      )),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (Navigator.canPop(context)) Navigator.pop(context);
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'Club Merchandise',
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
                  const SizedBox(width: 36),
                ],
              ),
              const SizedBox(height: 54),
              Container(
                height: 38,
                padding: const EdgeInsets.fromLTRB(11, 7, 14, 7),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.21),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 23.5,
                      height: 23.5,
                      decoration: BoxDecoration(
                        color: const Color(0xFF8C8C8C).withOpacity(.25),
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
                        controller: searchController,
                        cursorColor: Colors.white,
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 12,
                          color: Colors.white,
                        ),
                        decoration: const InputDecoration(
                          isCollapsed: true,
                          border: InputBorder.none,
                          hintText: 'Search cloths, gears, tools, or equpi...',
                          hintStyle: TextStyle(
                            fontFamily: 'Outfit',
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

class _MerchandiseCategoryCard extends StatelessWidget {
  final List<MerchandiseCategory> categories;
  final int selectedCategoryIndex;
  final ValueChanged<int> onCategorySelected;

  const _MerchandiseCategoryCard({
    Key? key,
    required this.categories,
    required this.selectedCategoryIndex,
    required this.onCategorySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 136,
      padding: const EdgeInsets.fromLTRB(13, 17, 0, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.16),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.10),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: [
            const SizedBox(width: 7),
            ...List.generate(categories.length, (index) {
              final selected = selectedCategoryIndex == index;
              final category = categories[index];
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: GestureDetector(
                  onTap: () => onCategorySelected(index),
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
                            child: Container(
                              width: 80,
                              height: 75,
                              color: const Color(0xFFE5E7EB),
                              child: category.image != null
                                  ? AdaptiveImage(
                                      imagePath: category.image!,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                      placeholderColor: const Color(0xFFE5E7EB),
                                      errorWidget: const Center(
                                        child: Icon(
                                          Icons.image_not_supported,
                                          color: Color(0xFF9CA3AF),
                                          size: 24,
                                        ),
                                      ),
                                    )
                                  : const Center(
                                      child: Icon(
                                        Icons.image,
                                        color: Color(0xFF9CA3AF),
                                        size: 28,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        Text(
                          category.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Outfit',
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
                ),
              );
            }),
            const SizedBox(width: 7),
          ],
        ),
      ),
    );
  }
}
