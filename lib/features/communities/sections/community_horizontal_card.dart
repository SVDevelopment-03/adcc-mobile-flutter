import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/shared/widgets/adaptive_image.dart';
import 'package:flutter/material.dart';

class CommunityHorizontalCard extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;
  final VoidCallback onExplore;

  const CommunityHorizontalCard({
    super.key,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.onExplore,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 360,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightOliveGreen.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      maxLines: 4,               
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.4,
                        color: Colors.black.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),

                InkWell(
                  onTap: onExplore,
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.softCream,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Text(
                      'Explore Community →',
                      style: TextStyle(
                        color: AppColors.deepRed,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          /// RIGHT IMAGE
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: AdaptiveImage(
              imagePath: imagePath,
              width: 130,
              height: 220,
              fit: BoxFit.cover,
              placeholderColor: AppColors.softCream,
            ),
          ),
        ],
      ),
    );
  }
}
