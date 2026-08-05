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
  final PageController _controller = PageController(
    viewportFraction: 0.92,
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

    return SizedBox(
      height: 190,
      child: PageView.builder(
        controller: _controller,
        itemCount: items.length,
        padEnds: false,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 7.5),
            child: PromoCard(
              data: items[index],
              index: index,
            ),
          );
        },
      ),
    );
  }
}
