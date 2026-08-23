import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:adcc/core/constants/cosmatic_imgs.dart';
import 'package:adcc/core/utils/currency_formatter.dart';
import 'package:adcc/shared/widgets/adaptive_image.dart';
import 'package:adcc/l10n/app_localizations.dart';

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
    final height = isSmall ? 230.0 : 350.0;
    final imageHeight = isSmall ? 150.0 : 220.0;
    final titleSize = isSmall ? 14.0 : 15.0;
    final priceSize = isSmall ? 13.0 : 14.0;
    final buttonPadding = isSmall
      ? const EdgeInsets.symmetric(horizontal: 12, vertical: 6)
      : const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
    final contentPadding = isSmall
      ? const EdgeInsets.fromLTRB(12, 10, 12, 8)
      : const EdgeInsets.fromLTRB(14, 12, 14, 12);
    final titleSpacing = isSmall ? 4.0 : 6.0;
    final buttonFontSize = isSmall ? 11.0 : 12.0;
    final l10n = AppLocalizations.of(context)!;
    final buttonText = l10n.viewStore;
    final titleColor = isSmall ? const Color(0xFF1A1C20) : const Color(0xFFFFFFFF);
    final priceColor = isSmall ? const Color(0xFF1A1C20) : const Color(0xFFFFFFFF);

    return SizedBox(
      width: width,
      height: height,
      child: Container(
        decoration: BoxDecoration(
          color: isSmall ? Colors.white : null,
          image: isSmall
              ? null
              : DecorationImage(
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
                      PositionedDirectional(
                        top: 12,
                        start: 12,
                        child: _OutOfStockBadge(),
                      ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: contentPadding,
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
                        color: titleColor,
                      ),
                    ),
                    SizedBox(height: titleSpacing),
                    buildCurrencyPrice(
                      data.price,
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: priceSize,
                        fontWeight: FontWeight.w700,
                        color: priceColor,
                      ),
                    ),
                    const Spacer(),
                    Align(
                      alignment: AlignmentDirectional.bottomStart,
                      child: ElevatedButton(
                        onPressed: data.isOutOfStock ? null : onTap,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSmall ? Colors.black : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: buttonPadding,
                          minimumSize: const Size(0, 0),
                        ),
                        child: Text(
                          data.isOutOfStock ? l10n.outOfStock : buttonText,
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: buttonFontSize,
                            fontWeight: FontWeight.w600,
                            color: isSmall ? Colors.white : Colors.black,
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
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.redAccent.withOpacity(0.95),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        l10n.outOfStock,
        style: const TextStyle(
          fontFamily: 'Outfit',
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}
