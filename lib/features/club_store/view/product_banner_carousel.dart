import 'package:adcc/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:adcc/features/club_store/repositories/club_store_repository.dart';

class ProductBannerData {
  final String? title;
  final String? subtitle;
  final String? imageUrl;

  const ProductBannerData({
    this.title,
    this.subtitle,
    this.imageUrl,
  });
}

class ProductBannerCarousel extends StatefulWidget {
  final List<ProductBannerData> items;

  const ProductBannerCarousel({
    super.key,
    this.items = const [],
  });

  @override
  State<ProductBannerCarousel> createState() => _ProductBannerCarouselState();
}

class _ProductBannerCarouselState extends State<ProductBannerCarousel> {
  final PageController _pageController = PageController(viewportFraction: 0.96);
  final ClubStoreRepository _repository = ClubStoreRepository();
  List<ProductBannerData> _items = [];
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _items = widget.items;
    if (_items.isEmpty) {
      _loadProductBanners();
    }
  }

  @override
  void didUpdateWidget(covariant ProductBannerCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.items != oldWidget.items) {
      setState(() {
        _items = widget.items;
      });
    }
  }

  Future<void> _loadProductBanners() async {
    try {
      final banners = await _repository.fetchProductBanners();
      if (banners.isNotEmpty) {
        setState(() {
          _items = banners
              .map(
                (banner) => ProductBannerData(
                  imageUrl: banner.image,
                ),
              )
              .toList();
        });
      }
    } catch (_) {
      // Ignore loading failures and fall back to static defaults.
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final items = _items.isNotEmpty
        ? _items
        : [
            ProductBannerData(
              title: l10n.club_tees,
              subtitle: l10n.club_tees_sub,
              // color: Color(0xFF435873),
            ),
            ProductBannerData(
              title: l10n.ride_gear,
              subtitle: l10n.ride_gear_sub,
              // color: Color(0xFF5A738E),
            ),
            ProductBannerData(
              title: l10n.bike_tools,
              subtitle: l10n.bike_tools_sub,
              // color: Color(0xFF7E8FA3),
            ),
          ];

    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: items.length,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemBuilder: (context, index) {
              final item = items[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: GestureDetector(
                  onTap: () {
                    // Placeholder tap action for product banner
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(18),
                      image: item.imageUrl != null
                          ? DecorationImage(
                              image: NetworkImage(item.imageUrl!),
                              fit: BoxFit.contain,
                            )
                          : null,
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: Colors.black.withOpacity(0.12),
                      //     blurRadius: 12,
                      //     // offset: const Offset(0, 8),
                      //   ),
                      // ],
                    ),
                    padding: EdgeInsets.zero,
                    child: const SizedBox.expand(),
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                items.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 18 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? Colors.white
                        : Colors.white.withOpacity(0.45),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
