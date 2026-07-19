import 'dart:ui';

import 'package:adcc/core/constants/cosmatic_imgs.dart';
import 'package:adcc/features/store/viewmodels/store_view_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:intl/intl.dart'; // Import for DateFormat
import '../../../../core/theme/app_colors.dart';
import 'store_details_screen.dart';
import '../sell_product_screen.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  String _searchQuery = '';
  String _sortOption = 'Newest';
  final TextEditingController _searchController = TextEditingController();
  final StoreViewModel _viewModel = StoreViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.addListener(_onVmChanged);
    _viewModel.loadItems();
  }

  void _onVmChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onVmChanged);
    _viewModel.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final products = _getFilteredProducts();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Color(0xFFedfffe),
        body: ListView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.zero,
          children: [
            _buildHeroSection(),
            const SizedBox(height: 36),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: _buildResultsHeader(products.length),
            ),
            const SizedBox(height: 20),
            if (_viewModel.isLoading)
              const SizedBox(
                height: 120,
                child: Center(child: CircularProgressIndicator()),
              )
            else
              _buildProductCarousel(products),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return SizedBox(
      height: 305,
      child: Stack(
        children: [
          Container(
            height: 261,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: CachedNetworkImageProvider(
                      MarketplaceImges.marketplaceheaderbackground),
                  fit: BoxFit.cover),
              // gradient: LinearGradient(
              //   begin: Alignment.topCenter,
              //   end: Alignment.bottomCenter,
              //   stops: [0.8362, 1],
              //   colors: [
              //     Color(0xFF129995),
              //     Colors.white,
              //   ],
              // ),
            ),
          ),
          Positioned(
            left: 16,
            top: 59,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              iconSize: 24,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints.tightFor(
                width: 40,
                height: 40,
              ),
              style: IconButton.styleFrom(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ),
          const Positioned(
            left: 16,
            right: 16,
            top: 111,
            child: Text(
              'Cycling Marketplace',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 28,
                fontWeight: FontWeight.w600,
                height: 35 / 28,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            top: 163,
            child: _buildSearchBox(),
          ),
          Positioned(
            left: 16,
            right: 16,
            top: 221,
            child: _buildSellCard(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBox() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          height: 38,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.21),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const SizedBox(width: 11),
              Container(
                height: 23.5,
                width: 23.5,
                padding: const EdgeInsets.fromLTRB(
                  5.42,
                  5.06,
                  5.06,
                  4.21,
                ),
                decoration: BoxDecoration(
                  // color: const Color(0xFF333333),
                  color: const Color.fromRGBO(140, 140, 140, 0.25),
                  borderRadius: BorderRadius.circular(36.1539),
                ),
                child: const Icon(
                  Icons.search,
                  color: Colors.white,
                  size: 12.05,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  cursorColor: Colors.white,
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    height: 15 / 12,
                    color: Colors.white,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Search marketplace...',
                    hintStyle: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      height: 15 / 12,
                      color: Colors.white,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              const SizedBox(width: 14),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSellCard() {
    return Container(
      height: 84,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
          width: 1.16585,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 2,
            offset: const Offset(0, 1),
            spreadRadius: -1,
          ),
        ],
      ),
      child: SizedBox.expand(
        child: ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const SellProductScreen(),
              ),
            );
          },
          icon: const Icon(Icons.add, size: 20),
          label: const Text('Sell your product'),
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: const Color(0xFF139893),
            foregroundColor: Color.fromARGB(255, 255, 255, 255),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              height: 24 / 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductCarousel(List<Map<String, dynamic>> products) {
    return SizedBox(
      height: 456,
      child: ListView.separated(
        padding: const EdgeInsets.only(left: 15, right: 15),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: products.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final product = products[index];

          return _FigmaStoreProductCard(
            product: product,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => StoreDetailsScreen(
                    productId: product['id'],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildResultsHeader(int resultCount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Showing $resultCount Result${resultCount != 1 ? 's' : ''}',
          style: const TextStyle(
            fontFamily: 'Outfit',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            height: 25 / 20,
            letterSpacing: 0,
            color: AppColors.textDark,
          ),
        ),
        GestureDetector(
          onTap: () => _showFilterSheet(context),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.tune,
                color: AppColors.textDark,
                size: 18,
              ),
              SizedBox(width: 7),
              Text(
                'Filter',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Satoshi',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 19 / 14,
                  letterSpacing: 0,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showFilterSheet(BuildContext context) {
    String tempCity = '';
    String tempMin = '';
    String tempMax = '';
    String tempSort = _sortOption;

    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Text('Filters',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration:
                          const InputDecoration(labelText: 'Min price (AED)'),
                      keyboardType: TextInputType.number,
                      onChanged: (v) => tempMin = v,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      decoration:
                          const InputDecoration(labelText: 'Max price (AED)'),
                      keyboardType: TextInputType.number,
                      onChanged: (v) => tempMax = v,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: const InputDecoration(labelText: 'City (optional)'),
                onChanged: (v) => tempCity = v,
              ),
              const SizedBox(height: 12),
              DropdownButton<String>(
                value: tempSort,
                isExpanded: true,
                items: const [
                  DropdownMenuItem(value: 'Newest', child: Text('Newest')),
                  DropdownMenuItem(
                      value: 'Price: Low to High',
                      child: Text('Price: Low to High')),
                  DropdownMenuItem(
                      value: 'Price: High to Low',
                      child: Text('Price: High to Low')),
                ],
                onChanged: (v) => tempSort = v ?? tempSort,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        final min = double.tryParse(tempMin);
                        final max = double.tryParse(tempMax);
                        setState(() {
                          _sortOption = tempSort;
                        });
                        _viewModel.loadItems(
                          city: tempCity.isEmpty ? null : tempCity,
                          minPrice: min,
                          maxPrice: max,
                          search: _searchQuery.isEmpty ? null : _searchQuery,
                        );
                        Navigator.pop(context);
                      },
                      child: const Text('Apply'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  List<Map<String, dynamic>> _getFilteredProducts() {
    final apiProducts = _viewModel
        .filterItems(category: 'All', search: _searchQuery)
        .map((e) => e.toUiMap())
        .toList();

    List<Map<String, dynamic>> filtered = List.from(apiProducts);

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((product) {
        final title = (product['title'] as String).toLowerCase();
        final postedBy = (product['postedBy'] as String).toLowerCase();
        final query = _searchQuery.toLowerCase();
        return title.contains(query) || postedBy.contains(query);
      }).toList();
    }

    // Apply client-side sorting if requested
    if (_sortOption == 'Price: Low to High') {
      filtered.sort((a, b) {
        final pa = double.tryParse((a['price'] ?? '0')
                .toString()
                .replaceAll(RegExp(r'[^0-9.]'), '')) ??
            0;
        final pb = double.tryParse((b['price'] ?? '0')
                .toString()
                .replaceAll(RegExp(r'[^0-9.]'), '')) ??
            0;
        return pa.compareTo(pb);
      });
    } else if (_sortOption == 'Price: High to Low') {
      filtered.sort((a, b) {
        final pa = double.tryParse((a['price'] ?? '0')
                .toString()
                .replaceAll(RegExp(r'[^0-9.]'), '')) ??
            0;
        final pb = double.tryParse((b['price'] ?? '0')
                .toString()
                .replaceAll(RegExp(r'[^0-9.]'), '')) ??
            0;
        return pb.compareTo(pa);
      });
    }

    return filtered;
  }
}

class _FigmaStoreProductCard extends StatelessWidget {
  const _FigmaStoreProductCard({
    required this.product,
    required this.onTap,
  });

  final Map<String, dynamic> product;
  final VoidCallback onTap;

  static const Color _brandOrange = Color(0xFF129995);
  static const Color _cardPeach = Color.fromARGB(255, 255, 255, 255);

  @override
  Widget build(BuildContext context) {
    final postedBy = (product['postedBy'] ?? '').toString();
    final location = (product['location'] ?? '').toString();
    final sellerLocation = [
      if (postedBy.isNotEmpty) postedBy,
      if (location.isNotEmpty) location,
    ].join(', ');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 314,
        height: 456,
        decoration: BoxDecoration(
          color: _cardPeach,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 12,
              top: 12,
              child: Container(
                width: 290,
                height: 351,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                clipBehavior: Clip.antiAlias,
                child: _buildProductImage(product['image']?.toString() ?? ''),
              ),
            ),
            Positioned(
              left: 12,
              right: 112,
              top: 373,
              child: Text(
                product['title']?.toString() ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 21 / 14,
                  color: AppColors.textDark,
                ),
              ),
            ),
            Positioned(
              left: 12,
              top: 394,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    product['price']?.toString() ?? '',
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      height: 24 / 16,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(width: 9),
                  Container(
                    width: 3,
                    height: 3,
                    decoration: const BoxDecoration(
                      color: Color(0xFF6B7280),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 9),
                  Text(
                    _formatTimeAgo(product['timePosted']?.toString()),
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      height: 11 / 10,
                      color: AppColors.textDark.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 209,
              top: 390,
              child: SizedBox(
                width: 93,
                height: 30,
                child: ElevatedButton(
                  onPressed: onTap,
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    padding: EdgeInsets.zero,
                    backgroundColor: _brandOrange,
                    foregroundColor: const Color(0xFFFFF4E3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9.11628),
                    ),
                    textStyle: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      height: 16 / 13,
                    ),
                  ),
                  child: const Text('View Details'),
                ),
              ),
            ),
            Positioned(
              left: 12,
              top: 423,
              child: Icon(
                Icons.location_on,
                size: 13,
                color: AppColors.textDark.withValues(alpha: 0.5),
              ),
            ),
            Positioned(
              left: 30,
              right: 12,
              top: 422,
              child: Text(
                sellerLocation,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  height: 14 / 11,
                  color: AppColors.textDark.withValues(alpha: 0.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage(String image) {
    if (image.startsWith('http')) {
      return Image.network(
        image,
        width: 290,
        height: 351,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _fallbackImage(),
      );
    }

    return Image.asset(
      image.isEmpty ? 'assets/images/no-img.jpg' : image,
      width: 290,
      height: 351,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _fallbackImage(),
    );
  }

  Widget _fallbackImage() {
    return Image.asset(
      'assets/images/no-img.jpg',
      width: 290,
      height: 351,
      fit: BoxFit.cover,
    );
  }

  String _formatTimeAgo(String? dateTimeString) {
    if (dateTimeString == null || dateTimeString.isEmpty) {
      return ''; // Return empty string if no date is provided
    }

    try {
      final dateTime = DateTime.parse(dateTimeString);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inMinutes < 1) {
        return 'Just now';
      } else if (difference.inHours < 1) {
        return '${difference.inMinutes} minutes ago';
      } else if (difference.inDays < 1) {
        return '${difference.inHours} hours ago';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} days ago';
      } else {
        return DateFormat('MMM dd, yyyy')
            .format(dateTime); // e.g., "May 31, 2026"
      }
    } catch (e) {
      return dateTimeString; // Fallback to original string on parsing error
    }
  }
}
