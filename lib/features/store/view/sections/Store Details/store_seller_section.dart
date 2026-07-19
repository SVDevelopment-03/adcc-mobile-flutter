import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

class StoreSellerSection extends StatelessWidget {
  final String sellerName;
  final String sellerImage;
  final String sellerLocation;
  final int listingCount;
  final double rating;

  const StoreSellerSection({
    super.key,
    required this.sellerName,
    required this.sellerImage,
    required this.sellerLocation,
    required this.listingCount,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.buttonGuest,
          borderRadius: BorderRadius.circular(16),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Seller Profile Picture
              CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage(sellerImage),
                onBackgroundImageError: (_, __) {},
              ),
              const SizedBox(width: 12),
              // Seller Info - Centered vertically with avatar
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                   Text(
  sellerName,
  style: const TextStyle(
    fontFamily: 'Outfit',
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.0,
    letterSpacing: 0,
    color: AppColors.textDark,
  ),
),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Image.asset(
      "assets/icons/location.png",
      height: 16,
      width: 16,
      color: AppColors.charcoal,
    ),

                        const SizedBox(width: 4),
                       Text(
  sellerLocation,
  style: TextStyle(
    fontFamily: 'Outfit',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.0,
    letterSpacing: 0,
    color: AppColors.textDark.withOpacity(0.6),
  ),
),
                        const SizedBox(width: 8),
                        Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppColors.textDark.withValues(alpha: 0.6),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '$listingCount listings',
                         style: TextStyle(
    fontFamily: 'Outfit',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.0,
    letterSpacing: 0,
    color: AppColors.textDark.withOpacity(0.6),
  ),

                        ),
                      ],
                    ),
                  ],
                ),
              ),
       
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.charcoal,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.star,
                        color: Color(0XFFFFD502),
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                     Text(
  rating.toStringAsFixed(1),
  style: const TextStyle(
    fontFamily: 'Outfit',
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.0,
    letterSpacing: 0,
    color: Colors.white,
  ),
),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

