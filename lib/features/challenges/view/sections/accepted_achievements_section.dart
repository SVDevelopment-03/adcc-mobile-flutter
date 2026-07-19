import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class AcceptedAchievementsSection extends StatelessWidget {
  final String challengeTitle;

  const AcceptedAchievementsSection({
    super.key,
    required this.challengeTitle,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      Text(
  'Achievements Unlocked',
  style: TextStyle(
    fontFamily: "Outfit",
    fontSize: 20,
    fontWeight: FontWeight.w500,
    height: 1.5,
    letterSpacing: 0,
    color: AppColors.textDark,
  ),
),

        SizedBox(height: 20),

        _AchievementCard(
          title: 'Distance Champion Badge',
          subtitle: 'Earned today',
          imagePath: 'assets/icons/trophy.png',
        ),

        SizedBox(height: 12),

        _AchievementCard(
          title: '+100 Reward Points',
          subtitle: 'Added to your account',
          imagePath: 'assets/icons/gain.png',
        ),
      ],
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;

  const _AchievementCard({
    required this.imagePath,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 357,
      height: 88,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.dustyRose,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.goldenOchre,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Center(
              child: Image.asset(
                imagePath,
                width: 32,
                height: 32,
                fit: BoxFit.contain,
              ),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               Text(
  title,
  style: const TextStyle(
    fontFamily: "Outfit",
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1,
    letterSpacing: 0,
    color: Color(0XFF101828),
  ),
),

                const SizedBox(height: 4),

             Text(
  subtitle,
  style: const TextStyle(
    fontFamily: "Outfit",
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1,
    letterSpacing: 0,
    color: Color(0xFF4A5565),
  ),
),
              ],
            ),
          ),
        ],
      ),
    );
  }
}