import 'package:adcc/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class StoreItemCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String postedBy;
  final String price;
  final String? timePosted;
  final String? location;
  final VoidCallback? onTap;

  const StoreItemCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.postedBy,
    required this.price,
    this.timePosted,
    this.location,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    imagePath,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        color: AppColors.softCream,
                        child: const Icon(Icons.image, size: 50),
                      );
                    },
                  ),
                ),

                if (location != null)
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Colors.white,
                            size: 12,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            location!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 8),

            // Title
            Text(
              title,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 6),

          
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  price,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.deepRed,
                    fontSize: 16,
                  ),
                ),
                if (timePosted != null) ...[
                  const SizedBox(width: 6),
                  Container(
                    width: 4,
                    height: 4,
                    decoration: const BoxDecoration(
                      color: AppColors.deepRed,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    timePosted!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.charcoal.withValues(alpha: 0.5),
                      fontSize: 10,
                    ),
                  ),
                ],
              ],
            ),

            const SizedBox(height: 4),

            // Posted by
            Text(
              'Posted by $postedBy',
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.charcoal.withValues(alpha: 0.5),
                fontSize: 12,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
