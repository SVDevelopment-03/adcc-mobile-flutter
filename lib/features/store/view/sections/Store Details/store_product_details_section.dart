import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

class StoreProductDetailsSection extends StatelessWidget {
  final List<String> details;

  const StoreProductDetailsSection({
    super.key,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         Text(
  'Product Details',
  style: const TextStyle(
    fontFamily: 'Outfit',
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.25,
    letterSpacing: 0,
    color: AppColors.textDark,
  ),
),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: details.map((detail) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.dustyRose,
                  borderRadius: BorderRadius.circular(12),
                ),
                child:Text(
  detail, // ensure string is already in Title Case
  textAlign: TextAlign.center,
  style: const TextStyle(
    fontFamily: 'Outfit',
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.0,
    letterSpacing: 0,
    color: AppColors.textDark,
  ),
),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

