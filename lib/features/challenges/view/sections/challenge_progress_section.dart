import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class ChallengeProgressSection extends StatelessWidget {
  final int progress;
  final int target;
  final String unit;
  final int percentage;
  final int remaining;

  const ChallengeProgressSection({
    super.key,
    required this.progress,
    required this.target,
    required this.unit,
    required this.percentage,
    required this.remaining,
  });

  @override
  Widget build(BuildContext context) {
    final progressPercentage = (progress / target).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: 358,
        height: 158,
        padding: const EdgeInsets.fromLTRB(19, 16, 19, 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF0DDAF),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// TITLE ROW
            Row(
              children: [
                Image.asset(
                  "assets/icons/achive.png",
                  width: 19.99,
                  height: 19.99,
                  color: AppColors.charcoal,
                ),

                const SizedBox(width: 8),

               Text(
  "Your Progress",
  style: const TextStyle(
    fontFamily: "Outfit",
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.56, // 28px line height
    letterSpacing: 0,
    color: AppColors.charcoal,
  ),
),
              ],
            ),

            const SizedBox(height: 17),

            /// PROGRESS LABEL + VALUE
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
  "Your Progress",
  style: const TextStyle(
    fontFamily: "Outfit",
    fontSize: 13.09,
    fontWeight: FontWeight.w400,
    height: 1.43, // 18.7px line height
    letterSpacing: 0,
    color: AppColors.charcoal,
  ),
),
              Text(
  "$progress / $target $unit",
  textAlign: TextAlign.right,
  style: const TextStyle(
    fontFamily: "Outfit",
    fontSize: 13.09,
    fontWeight: FontWeight.w400,
    height: 1.43, // 18.7px line height
    letterSpacing: 0,
    color: AppColors.charcoal,
  ),
),
              ],
            ),

            const SizedBox(height: 12),

            /// PROGRESS BAR
            ClipRRect(
  borderRadius: BorderRadius.circular(50), // pill shape
  child: LinearProgressIndicator(
    value: progressPercentage,
    minHeight: 11.2,
    backgroundColor: Colors.white.withValues(alpha: 0.7),
    valueColor: const AlwaysStoppedAnimation(
      Color(0xFFD6AC2C),
    ),
  ),
),

            const SizedBox(height: 12),

            /// REMAINING TEXT
           Text(
  "$percentage% to go • $remaining $unit remaining",
  style: const TextStyle(
    fontFamily: "Outfit",
    fontSize: 13.09,
    fontWeight: FontWeight.w400,
    height: 1.43, // 18.7px line height
    letterSpacing: 0,
    color: AppColors.charcoal,
  ),
),
          ],
        ),
      ),
    );
  }
}