import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'promo_card.dart';

class PromoCarousel extends StatefulWidget {
  final List<PromoData> items;
  final bool showFallback;

  const PromoCarousel({
    super.key,
    this.items = const [],
    this.showFallback = false,
  });

  @override
  State<PromoCarousel> createState() => _PromoCarouselState();
}

class _PromoCarouselState extends State<PromoCarousel> {
  static const double _viewportFraction = 0.92;

  /// Banner artwork is 1356x720 with text baked into the image, so the card
  /// height follows the card width to show the full banner without cropping.
  static const double _bannerAspectRatio = 1356 / 720;

  final PageController _controller = PageController(
    viewportFraction: _viewportFraction,
    initialPage: 1,
  );

  @override
  Widget build(BuildContext context) {
    final items = widget.items;
    if (items.isEmpty) return const SizedBox.shrink();

    if (kDebugMode) {
      for (var i = 0; i < items.length; i++) {
        final img = items[i].image;
        if (img.isEmpty) {
          debugPrint('Promo image [$i] is empty');
        } else if (RegExp(r'^https?://').hasMatch(img)) {
          debugPrint('Promo image URL [$i]: $img');
        } else {
          debugPrint('Promo image non-URL (asset/relative) [$i]: $img');
        }
      }
    }

    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Page width minus the 4px padding on each side of a card.
          final cardWidth = constraints.maxWidth * _viewportFraction - 8;
          final height = cardWidth / _bannerAspectRatio;

          return SizedBox(
            height: height,
            child: PageView.builder(
              controller: _controller,
              itemCount: items.length,
              padEnds: false,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsetsDirectional.symmetric(horizontal: 4),
                  child: PromoCard(
                    data: items[index],
                    index: index,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
