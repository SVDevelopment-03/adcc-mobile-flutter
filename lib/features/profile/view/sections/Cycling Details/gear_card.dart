import 'package:adcc/core/constants/cosmatic_imgs.dart';
import 'package:adcc/core/theme/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class GearCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String price;
  final String time;
  final String postedBy;

  const GearCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.price,
    required this.time,
    required this.postedBy,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 194,
      height: 272,
      margin: const EdgeInsets.only(right: 14),
      decoration: BoxDecoration(
        image: DecorationImage(
            image: CachedNetworkImageProvider(
                ProfileImgs.profileListedGearBackground),
            fit: BoxFit.cover),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// IMAGE WITH LOCATION BADGE
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(8),
            ),
            child: Stack(
              children: [
                SizedBox(
                  height: 196,
                  width: double.infinity,
                  child: imagePath.startsWith('http')
                      ? Image.network(
                          imagePath,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Image.asset(
                            'assets/images/no-img.jpg',
                            fit: BoxFit.cover,
                          ),
                        )
                      : Image.asset(
                          imagePath,
                          fit: BoxFit.cover,
                        ),
                ),

                /// LOCATION BADGE
                Positioned(
                  top: 12,
                  left: 7,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(22.5),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 7.5,
                        sigmaY: 7.5,
                      ),
                      child: Container(
                        width: 67,
                        height: 21,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(22.5),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/images/location.png',
                              width: 10,
                              height: 10,
                              fit: BoxFit.contain,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 3),
                            const Text(
                              "Sharjah",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 9.75,
                                fontWeight: FontWeight.w500,
                                height: 1,
                                letterSpacing: 0,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),

          const SizedBox(height: 8),

          /// CONTENT
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// TITLE
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    height: 1,
                    letterSpacing: 0,
                    color: AppColors.charcoal,
                  ),
                ),

                const SizedBox(height: 2),

                /// PRICE + TIME
                Row(
                  children: [
                    Text(
                      price,
                      style: const TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        height: 1.5,
                        letterSpacing: 0,
                        color: AppColors.charcoal,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      "•",
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      time,
                      style: const TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        height: 1.1,
                        letterSpacing: 0,
                        color: Color(0xFF6B7280),
                      ),
                    )
                  ],
                ),

                const SizedBox(height: 4),

                /// POSTED BY
                Text(
                  "Posted by $postedBy",
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    height: 1,
                    letterSpacing: 0,
                    color: AppColors.charcoal.withValues(alpha: 0.5),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
