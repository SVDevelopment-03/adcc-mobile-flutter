import 'dart:ui';

import 'package:adcc/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class MyChallengeCardData {
  const MyChallengeCardData({
    required this.status,
    required this.title,
    required this.description,
    required this.progressLabel,
    required this.progress,
    required this.daysLeft,
    required this.participants,
    required this.imagePath,
    this.rewardPoints,
  });

  final String status;
  final String title;
  final String description;
  final String progressLabel;
  final double progress;
  final int? rewardPoints;
  final int daysLeft;
  final int participants;
  final String imagePath;
}

class MyChallengeCard extends StatelessWidget {
  const MyChallengeCard({
    super.key,
    required this.data,
    this.onTap,
  });

  final MyChallengeCardData data;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.dustyRose,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CardImageHeader(data: data),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Text(
                data.description,
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 31 / 2,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                  color: Color(0xFF343434),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Progress',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 31 / 2,
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                      color: Color(0xFF5B5B5B),
                    ),
                  ),
                  Text(
                    data.progressLabel,
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 31 / 2,
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                      color: AppColors.charcoal,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: data.progress.clamp(0.0, 1.0),
                  minHeight: 8.84,
                  backgroundColor: const Color(0xFFF9FAFB),
                  valueColor:
                      const AlwaysStoppedAnimation(AppColors.goldenOchre),
                ),
              ),
            ),
            if (data.rewardPoints != null) ...[
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _RewardBox(points: data.rewardPoints!),
              ),
              const SizedBox(height: 14),
            ] else
              const SizedBox(height: 12),
            Container(
              height: 1,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              color: data.rewardPoints != null
                  ? const Color(0xFFE9DAC4)
                  : const Color(0xFFE5E7EB),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
              child: Row(
                children: [
                  Icon(
                    Icons.schedule_outlined,
                    size: 16,
                    color: AppColors.deepRed.withValues(alpha: 0.75),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${data.daysLeft} days left',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 31 / 2,
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                      color: AppColors.textDark.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(
                    Icons.group_outlined,
                    size: 16,
                    color: AppColors.deepRed.withValues(alpha: 0.75),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${data.participants}',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 31 / 2,
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                      color: AppColors.textDark.withValues(alpha: 0.6),
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.chevron_right,
                    size: 20,
                    color: AppColors.textDark.withValues(alpha: 0.6),
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

class _CardImageHeader extends StatelessWidget {
  const _CardImageHeader({required this.data});

  final MyChallengeCardData data;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
      child: SizedBox(
        height: 142,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              data.imagePath,
              fit: BoxFit.cover,
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x00000000),
                    Color(0x4D000000),
                    Color(0xB3000000),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 12,
              left: 12,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1C20).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      data.status,
                      style: const TextStyle(
                        fontFamily: 'Segoe UI',
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: Text(
                data.title,
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 40 / 2,
                  fontWeight: FontWeight.w600,
                  height: 1.35,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RewardBox extends StatelessWidget {
  const _RewardBox({required this.points});

  final int points;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.softCream,
        border: Border.all(
          color: AppColors.goldenOchre,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: AppColors.goldenOchre,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.military_tech_outlined,
              size: 19,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Reward Earned',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  height: 1.33,
                  color: Color(0xFF4A5565),
                ),
              ),
              Text(
                '$points Points',
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  height: 1.43,
                  color: Color(0xFF101828),
                ),
              ),
            ],
          ),
          const Spacer(),
          const Icon(
            Icons.card_giftcard_rounded,
            color: Color(0xFFC267FF),
            size: 26,
          ),
        ],
      ),
    );
  }
}
