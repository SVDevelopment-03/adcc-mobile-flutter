import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../shared/widgets/app_button.dart';

class StoreProductInfoSection extends StatelessWidget {
  final String title;
  final String location;
  final String timePosted;
  final String currentPrice;
  final String? originalPrice;
  final bool isNegotiable;

  const StoreProductInfoSection({
    super.key,
    required this.title,
    required this.location,
    required this.timePosted,
    required this.currentPrice,
    this.originalPrice,
    this.isNegotiable = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         // Product Title
Text(
  title,
  style: const TextStyle(
    fontFamily: 'Outfit',
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.0,
    letterSpacing: 0,
    color: AppColors.textDark,
  ),
),

          const SizedBox(height: 12),

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
  location,
  style: const TextStyle(
    fontFamily: 'Outfit',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.4,
    letterSpacing: 0,
    color: Color(0xFF6B7280),
  ),
),

    const SizedBox(width: 8),

    Container(
      width: 4,
      height: 4,
      decoration: const BoxDecoration(
        color: AppColors.charcoal,
        shape: BoxShape.circle,
      ),
    ),

    const SizedBox(width: 8),

  
    Image.asset(
      "assets/icons/clock.png",
      height: 14,
      width: 14,
      color: AppColors.charcoal,
    ),

    const SizedBox(width: 4),

   Text(
  timePosted,
  style: const TextStyle(
    fontFamily: 'Outfit',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.4,
    letterSpacing: 0,
    color: Color(0xFF6B7280),
  ),
),
  ],
),

          const SizedBox(height: 16),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Current Price
                   Text(
  currentPrice,
  style: const TextStyle(
    fontFamily: 'Outfit',
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: 0,
    color: AppColors.deepRed,
  ),
),
              
                    if (originalPrice != null) ...[
                      const SizedBox(height: 4),
                     Text(
  originalPrice!,
  style: TextStyle(
    fontFamily: 'Outfit',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.0,
    letterSpacing: 0,
    color: AppColors.textDark.withOpacity(0.8),
    decoration: TextDecoration.lineThrough,
  ),
),
                    ],
                  ],
                ),
              ),
           
              if (isNegotiable)
               AppButton(
  label: 'Negotiable',
  onPressed: () {},
  type: AppButtonType.secondary,
  borderColor: AppColors.textDark,
  textColor: AppColors.textDark,
  height: 30,
  width: 120,
  borderRadius: 20,
  textStyle: const TextStyle(
    fontFamily: 'Outfit',
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.25,
    letterSpacing: 0,
    color: AppColors.textDark,
  ),
  padding: const EdgeInsets.symmetric(horizontal: 2),
),
            ],
          ),
        ],
      ),
    );
  }
}

