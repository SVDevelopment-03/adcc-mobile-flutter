import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:adcc/core/constants/cosmatic_imgs.dart';
import 'package:adcc/shared/widgets/adaptive_image.dart';

class ProductCardData {
  final String title;
  final String price;
  final String image;
  final Color color;
  final bool isOutOfStock;

  const ProductCardData({
    required this.title,
    required this.price,
    required this.image,
    required this.color,
    this.isOutOfStock = false,
  });
}

class ProductCard extends StatelessWidget {
  final ProductCardData data;
  final bool isSmall;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.data,
    this.isSmall = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * (isSmall ? 0.46 : 0.62);
    final height = isSmall ? 230.0 : 290.0;
    final imageHeight = isSmall ? 150.0 : 220.0;
    final titleSize = isSmall ? 14.0 : 15.0;
    final priceSize = isSmall ? 13.0 : 14.0;
    final buttonPadding = isSmall
        ? const EdgeInsets.symmetric(horizontal: 12, vertical: 7)
        : const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
    final buttonText = isSmall ? 'View store' : 'View Store';

    return SizedBox(
      width: width,
      height: height,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: CachedNetworkImageProvider(
                ClubMerchImgs.clubMerchCardBackground),
            fit: BoxFit.cover,
            
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(18),
                bottom: Radius.circular(18),
              ),
              child: Container(
                height: imageHeight,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(
                      ClubMerchImgs.clubMerchCardBackground,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (data.image.isNotEmpty)
                      AdaptiveImage(
                        imagePath: data.image,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: imageHeight,
                        placeholderColor: data.color.withOpacity(0.35),
                        errorWidget: const Center(
                          child: Icon(
                            Icons.broken_image,
                            color: Colors.white70,
                            size: 44,
                          ),
                        ),
                      )
                    else
                      const Center(
                        child: Icon(
                          Icons.image_not_supported,
                          color: Colors.white70,
                          size: 44,
                        ),
                      ),
                    if (data.isOutOfStock)
                      Container(
                        color: Colors.black54,
                      ),
                    if (data.isOutOfStock)
                      const Positioned(
                        top: 12,
                        left: 12,
                        child: _OutOfStockBadge(),
                      ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: titleSize,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFFFFFFF),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      data.price,
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: priceSize,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFFFFFFF),
                      ),
                    ),
                    const Spacer(),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: ElevatedButton(
                        onPressed: data.isOutOfStock ? null : onTap,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: buttonPadding,
                          minimumSize: const Size(0, 0),
                        ),
                        child: Text(
                          data.isOutOfStock ? 'Out of stock' : buttonText,
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OutOfStockBadge extends StatelessWidget {
  const _OutOfStockBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.redAccent.withOpacity(0.95),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        'Out of stock',
        style: TextStyle(
          fontFamily: 'Outfit',
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}
