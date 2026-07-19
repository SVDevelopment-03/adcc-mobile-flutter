import 'package:adcc/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class RideInfoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final String? svgPath;

  const RideInfoCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.svgPath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(13.2955),
      onTap: onTap,
      child: Container(
        width: 358,
        height: 70,
        padding: const EdgeInsets.only(
          top: 6,
        
        
          left: 19,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFFFDA9B),
          borderRadius: BorderRadius.circular(13.2955),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (svgPath != null) ...[
              const Icon(
                Icons.directions_bike,
                size: 28,
              ),
              const SizedBox(width: 2),
            ],

            /// TEXT SECTION
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
  title,
  style: theme.textTheme.bodyLarge?.copyWith(
    fontFamily: 'Outfit',
    fontWeight: FontWeight.w500,
    fontSize: 15,
    height: 0.97,
    letterSpacing: 0,
    color: AppColors.textDark,
  ),
),
                const SizedBox(height: 4),
               Text(
  subtitle,
  style: theme.textTheme.bodyMedium?.copyWith(
    fontFamily: 'Outfit',
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.51,
    letterSpacing: 0,
    color: AppColors.textDark.withOpacity(0.8),
  ),
),
              ],
            ),
          ],
        ),
      ),
    );
  }
}