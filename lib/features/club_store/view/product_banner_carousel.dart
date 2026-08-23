import 'package:adcc/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:adcc/features/club_store/repositories/club_store_repository.dart';
import 'package:adcc/features/challenges/view/challenges_screen.dart';
import 'package:adcc/features/challenges/view/leaderboard_screen.dart';
import 'package:adcc/features/club_store/view/club_store_screen.dart';
import 'package:adcc/features/home/view/home_screen.dart';
import 'package:adcc/core/navigation/club_store_details_loader.dart';

class ProductBannerData {
  final String? title;
  final String? subtitle;
  final String? imageUrl;
  final String? targetScreen;
  final String? key;

  const ProductBannerData({
    this.title,
    this.subtitle,
    this.imageUrl,
    this.targetScreen,
    this.key,
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
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _items = widget.items;
    if (_items.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _loadProductBanners();
      });
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
    setState(() => _loading = true);
    try {
      final locale = Localizations.localeOf(context).languageCode;
      final banners = await _repository.fetchProductBanners(lang: locale);
      if (banners.isNotEmpty) {
        // Debug: print fetched banners and their targetScreen values
        for (final b in banners) {
          debugPrint('fetchProductBanners: banner key=${b.key} targetScreen=${b.targetScreen}');
        }
        setState(() {
          _items = banners
              .map(
                (banner) => ProductBannerData(
                  key: banner.key,
                  title: banner.title,
                  subtitle: banner.label,
                  imageUrl: banner.image,
                  targetScreen: banner.targetScreen,
                ),
              )
              .toList();
        });
      }
    } catch (_) {
      // Ignore loading failures and fall back to static defaults.
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // Prefer runtime-provided banners; if none were provided/fetched,
    // hide the entire banner section (no fallback placeholders).
    final items = _items.isNotEmpty ? _items : (widget.items.isNotEmpty ? widget.items : []);

    if (items.isEmpty && !_loading) {
      // Nothing to show for this locale (e.g. Arabic banner missing) — hide.
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 220,
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
                  onTap: () => _handleTap(item, index),
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
            bottom: 8,
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
          if (_loading)
            Positioned.fill(
              child: Container(
                alignment: Alignment.center,
                color: Colors.black.withOpacity(0.25),
                child: const CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  void _handleTap(ProductBannerData item, int index) {
    debugPrint('ProductBanner tapped at index=$index image=${item.imageUrl}');
    final target = (item.targetScreen ?? '').trim();
    debugPrint('ProductBanner tapped: key=${item.key} target="$target"');
    if (target.isEmpty) {
      debugPrint('ProductBanner: no targetScreen set — ignoring tap.');
      return;
    }

    final normalized = target.replaceAll('-', '_').replaceAll(RegExp(r'\s+'), '').toLowerCase();
    debugPrint('ProductBanner: normalized target="$normalized"');

    // If the target contains a 24-char hex id (Mongo ObjectId), open product details
    final idMatch = RegExp(r'[a-f0-9]{24}').firstMatch(normalized)?.group(0);
    debugPrint('ProductBanner: idMatch=$idMatch');
    if (idMatch != null) {
      debugPrint('ProductBanner: navigating to product details $idMatch');
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => ClubStoreDetailsLoaderScreen(itemId: idMatch),
      ));
      return;
    }

    // Debug-only visual feedback removed; keep console logs only.

    switch (normalized) {
      case 'events':
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => HomeScreen(initialIndex: 1)),
        );
        return;
      case 'communities':
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => HomeScreen(initialIndex: 2)),
        );
        return;
      case 'routes':
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => HomeScreen(initialIndex: 3)),
        );
        return;
      case 'profile':
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => HomeScreen(initialIndex: 4)),
        );
        return;
      case 'club_store':
      case 'clubstore':
      case 'merchandise':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const ClubStoreScreen()),
        );
        return;
      case 'challenges':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const ChallengesScreen()),
        );
        return;
      case 'leaderboard':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const LeaderboardScreen()),
        );
        return;
      case 'home':
      default:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
    }
  }
}
