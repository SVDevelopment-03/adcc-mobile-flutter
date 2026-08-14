import 'dart:ui';
import 'package:adcc/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class ChallengeCard extends StatelessWidget {
  final String imagePath;
  final String difficulty;
  final String title;
  final String description;
  final int progress;
  final int target;
  final String unit;
  final int daysLeft;
  final int participants;
  final VoidCallback? onTap;

  const ChallengeCard({
    super.key,
    required this.imagePath,
    required this.difficulty,
    required this.title,
    required this.description,
    required this.progress,
    required this.target,
    required this.unit,
    required this.daysLeft,
    required this.participants,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final progressPercentage = (progress / target).clamp(0.0, 1.0);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 358,
        constraints: const BoxConstraints(
          minHeight: 308,
        ),
        decoration: BoxDecoration(
          color: AppColors.dustyRose,
          borderRadius: BorderRadius.circular(18.1252),
          border: Border.all(
            color: const Color(0xffFFEFD7),
            width: 1.28,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// IMAGE SECTION
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(18.1252),
              ),
              child: Stack(
                children: [
                  imagePath.startsWith('http')
                      ? Image.network(
                          imagePath,
                          height: 141.45,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Image.asset(
                            'assets/images/no-img.jpg',
                            height: 141.45,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Image.asset(
                          imagePath,
                          height: 141.45,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),

                  /// gradient
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.7),
                          ],
                        ),
                      ),
                    ),
                  ),

                  /// difficulty tag
                  Positioned(
                    top: 17,
                    left: 14,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 10,
                          sigmaY: 10,
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A1C20).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            difficulty,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: "Outfit",
                              fontSize: 13.26,
                              fontWeight: FontWeight.w400,
                              height: 1.3, // 17.241px line height
                              letterSpacing: 0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  /// title
                  Positioned(
                    bottom: 12,
                    left: 16,
                    right: 16,
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontFamily: "Outfit",
                        fontSize: 19.9,
                        fontWeight: FontWeight.w600,
                        height: 1.4, // 27.85px line height
                        letterSpacing: 0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// CONTENT
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    description,
                    style: const TextStyle(
                      fontFamily: "Outfit",
                      fontSize: 15.47,
                      fontWeight: FontWeight.w500,
                      height: 1.4, // 21.66px line height
                      letterSpacing: 0,
                      color: Color(0xFF343434),
                    ),
                  ),

                  const SizedBox(height: 19),

                  /// progress
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.challenge_progress,
                        style: const TextStyle(
                          fontFamily: "Outfit",
                          fontSize: 15.47,
                          fontWeight: FontWeight.w400,
                          height: 1.4, // 21.66px line height
                          letterSpacing: 0,
                          color: Color(0xFF5B5B5B),
                        ),
                      ),
                      Text(
                        "$progress / $target $unit",
                        style: const TextStyle(
                          fontFamily: "Outfit",
                          fontSize: 15.47,
                          fontWeight: FontWeight.w500,
                          height: 1.4, // 21.66px line height
                          letterSpacing: 0,
                          color: AppColors.charcoal,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 9),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progressPercentage,
                      minHeight: 8,
                      backgroundColor: AppColors.softCream,
                      valueColor: AlwaysStoppedAnimation(
                        AppColors.goldenOchre,
                      ),
                    ),
                  ),

                  const SizedBox(height: 21),

                  /// bottom row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          /// CLOCK IMAGE
                          Row(
                            children: [
                              Image.asset(
                                "assets/icons/clock.png",
                                width: 16,
                                height: 16,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                AppLocalizations.of(context)!
                                    .challenge_days_left(daysLeft),
                                style: const TextStyle(
                                  fontFamily: "Outfit",
                                  fontSize: 15.47,
                                  fontWeight: FontWeight.w400,
                                  height: 1.4, // 21.66px line height
                                  letterSpacing: 0,
                                  color: AppColors.textDark,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(width: 16),

                          /// PERSON IMAGE
                          Row(
                            children: [
                              Image.asset(
                                "assets/icons/red_people.png",
                                width: 16,
                                height: 16,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                "$participants",
                                style: const TextStyle(
                                  fontFamily: "Outfit",
                                  fontSize: 15.47,
                                  fontWeight: FontWeight.w400,
                                  height: 1.4, // 21.66px line height
                                  letterSpacing: 0,
                                  color: AppColors.textDark,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: AppColors.textDark,
                      ),
                    ],
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
