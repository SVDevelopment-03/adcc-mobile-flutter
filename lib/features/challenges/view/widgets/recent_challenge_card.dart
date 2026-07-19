import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/app_colors.dart';

class RecentChallengeCard extends StatelessWidget {
  final String title;
  final String distance;
  final String duration;
  final String timeAgo;
  final VoidCallback? onTap;

  const RecentChallengeCard({
    super.key,
    required this.title,
    required this.distance,
    required this.duration,
    required this.timeAgo,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 357,
        height: 88,
        padding: const EdgeInsets.only(
          left: 12,
          right: 16,
          top: 12,
          bottom: 12,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFFFEFD7),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            /// LEFT ICON CONTAINER
            Container(
              width: 63.5945,
              height: 63.5945,
              decoration: BoxDecoration(
                color: const Color(0xFFCF9F0C),
                borderRadius: BorderRadius.circular(18.5508),
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/svg/colored_cycle.svg',
                  width: 34.4321,
                  height: 39.5838,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            const SizedBox(width: 16),

            /// TEXT CONTENT
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// TITLE
                 Text(
  title,
  maxLines: 1,
  overflow: TextOverflow.ellipsis,
  style: const TextStyle(
    fontFamily: "Outfit",
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.0, // 100% line height
    letterSpacing: 0,
    color: Color(0xFF101828),
  ),
),
                  const SizedBox(height: 5),

                  /// DETAILS
                 Text(
  "$distance·$duration·$timeAgo",
  maxLines: 1,
  overflow: TextOverflow.ellipsis,
  style: const TextStyle(
    fontFamily: "Outfit",
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.0, // 100% line height
    letterSpacing: 0,
    color: Color(0xFF4A5565),
  ),
),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}