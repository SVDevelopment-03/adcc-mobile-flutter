import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

class StoreDescriptionSection extends StatelessWidget {
  final String description;

  const StoreDescriptionSection({
    super.key,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
  'Description',
  style: const TextStyle(
    fontFamily: 'Outfit',
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.25,
    letterSpacing: 0,
    color: AppColors.textDark,
  ),
),
          const SizedBox(height: 12),
        Text(
  description,
  style: TextStyle(
    fontFamily: 'Outfit',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.0,
    letterSpacing: 0,
    color: AppColors.textDark.withOpacity(0.7),
  ),
),
        ],
      ),
    );
  }
}

