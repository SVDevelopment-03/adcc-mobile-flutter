import 'dart:async';

import 'package:flutter/material.dart';
import 'package:adcc/features/club_store/repositories/club_store_repository.dart';
import 'package:adcc/features/store/models/store_item_model.dart';
import 'package:adcc/features/club_store/view/product_card.dart';
import 'package:adcc/shared/widgets/adaptive_image.dart';
import 'details_screen.dart';

class ClubStoreAllProductsScreen extends StatefulWidget {
  const ClubStoreAllProductsScreen({super.key});

  @override
  State<ClubStoreAllProductsScreen> createState() => _ClubStoreAllProductsScreenState();
}

class _ClubStoreAllProductsScreenState extends State<ClubStoreAllProductsScreen> {
  static const _allCategoryImage = 'assets/images/club-category.png';

  final ClubStoreRepository _repository = ClubStoreRepository();
  final TextEditingController _searchController = TextEditingController();

  bool isGridView = true;
  bool isLoading = true;
  bool isLoadingMore = false;
  bool hasMore = true;
  String? errorMessage;
  String searchText = '';
  int selectedCategoryIndex = 0;
  int page = 1;
  final int limit = 20;

  final List<StoreItemModel> _products = [];
  final List<MerchandiseCategory> _categories = [
    MerchandiseCategory(name: 'All', image: _allCategoryImage),
  ];

  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _loadProducts(page: 1);
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
        _categories
          ..clear()
          ..add(MerchandiseCategory(name: 'All', image: _allCategoryImage))
          ..addAll(categories);
      });
    } catch (_) {
      // ignore
    }
  }

  Future<void> _loadProducts({required int page, bool append = false}) async {
    if (append) {
      setState(() {
        isLoadingMore = true;
      });
    } else {
      setState(() {
        isLoading = true;
        errorMessage = null;
        hasMore = true;
      });
    }

    try {
      final category = selectedCategoryIndex > 0 ? _categories[selectedCategoryIndex].name : null;
      final items = await _repository.fetchMerchandise(
        search: searchText,
        category: category,
        page: page,
        limit: limit,
      );

      setState(() {
        if (append) {
          _products.addAll(items);
        } else {
          _products
            ..clear()
            ..addAll(items);
        }
        this.page = page;
        hasMore = items.length == limit;
        isLoading = false;
        isLoadingMore = false;
      });
    } catch (error) {
      setState(() {
        errorMessage = 'Failed to load products. Please try again.';
        isLoading = false;
        isLoadingMore = false;
      });
    }
  }

  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();
    searchText = value;
    _searchDebounce = Timer(const Duration(milliseconds: 400), () {
      _loadProducts(page: 1);
    });
  }

  void _onCategorySelected(int index) {
    setState(() => selectedCategoryIndex = index);
    _loadProducts(page: 1);
  }

  void _toggleViewMode() {
    setState(() {
      isGridView = !isGridView;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBF4FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF435974),
        title: const Text('All Products', style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.w700, color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(isGridView ? Icons.list : Icons.grid_view),
            onPressed: _toggleViewMode,
            color: Colors.white,
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search, color: Color(0xFF435974)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          SizedBox(
            height: 96,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final category = _categories[index];
                final selected = selectedCategoryIndex == index;
                return GestureDetector(
                  onTap: () => _onCategorySelected(index),
                  child: Container(
                    width: 96,
                    decoration: BoxDecoration(
                      color: selected ? const Color(0xFFD5E2F2) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selected ? const Color(0xFF435974) : const Color(0xFFE5E7EB),
                        width: selected ? 1.5 : 1,
                      ),
                      boxShadow: [
                        if (!selected)
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                      ],
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xFFD5E2F2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: category.image != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: AdaptiveImage(
                                      imagePath: category.image!,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                      placeholderColor: const Color(0xFFD5E2F2),
                                      errorWidget: const Center(
                                        child: Icon(
                                          Icons.image_not_supported,
                                          color: Color(0xFF9CA3AF),
                                          size: 24,
                                        ),
                                      ),
                                    ),
                                  )
                                : const Center(
                                    child: Icon(
                                      Icons.image,
                                      color: Color(0xFF9CA3AF),
                                      size: 26,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          category.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: selected ? const Color(0xFF435974) : const Color(0xFF374151),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemCount: _categories.length,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: _buildBody(),
            ),
          ),
          if (hasMore && !isLoading && !isLoadingMore)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => _loadProducts(page: page + 1, append: true),
                  child: const Text('Load more'),
                ),
              ),
            ),
          if (isLoadingMore)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(child: Text(errorMessage!, style: const TextStyle(color: Color(0xFF435974))));
    }

    if (_products.isEmpty) {
      return const Center(
        child: Text(
          'No products found.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xFF435974)),
        ),
      );
    }

    if (isGridView) {
      return GridView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: _products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.66,
        ),
        itemBuilder: (context, index) {
          final item = _products[index];
          return ProductCard(
            data: ProductCardData(
              title: item.title,
              price: item.price,
              image: item.image,
              color: _colorForItem(index),
              isOutOfStock: item.isOutOfStock,
            ),
            isSmall: true,
            onTap: () => _openDetails(item),
          );
        },
      );
    }

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemCount: _products.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = _products[index];
        return _buildListTile(item, index);
      },
    );
  }

  Widget _buildListTile(StoreItemModel item, int index) {
    return Material(
      borderRadius: BorderRadius.circular(16),
      color: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _openDetails(item),
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  item.image,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 100,
                    height: 100,
                    color: const Color(0xFFE5E7EB),
                    child: const Icon(Icons.image_not_supported, color: Color(0xFF9CA3AF)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.category,
                      style: const TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.price,
                      style: const TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF01634A),
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

  void _openDetails(StoreItemModel item) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ClubStoreDetailsScreen(item: item),
      ),
    );
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
}
