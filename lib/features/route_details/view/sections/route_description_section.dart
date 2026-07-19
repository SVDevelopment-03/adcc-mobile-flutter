import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class RouteDescriptionSection extends StatelessWidget {
  final String description;

  const RouteDescriptionSection({
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
            'Tracks Description',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: "Outfit",
              color: AppColors.charcoal,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              fontFamily: "Outfit",
              color: AppColors.textDark,
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }
}
