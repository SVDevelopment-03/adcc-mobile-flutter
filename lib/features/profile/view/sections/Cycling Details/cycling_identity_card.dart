import 'package:adcc/core/constants/cosmatic_imgs.dart';
import 'package:adcc/core/theme/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:adcc/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class CyclingIdentityCard extends StatelessWidget {
  final String riderLevel;
  final double progressPercent; // 0.0 - 1.0
  final String progressText;

  const CyclingIdentityCard({
    super.key,
    this.riderLevel = 'Intermediate',
    this.progressPercent = 0.0,
    this.progressText = '0% completion',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 1, right: 1),
      child: Container(
        width: double.infinity,
        height: 272,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: CachedNetworkImageProvider(
              ProfileImgs.cyclingIdentityCardBackground,
            ),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// TITLE
            Row(
              children: [
                Image.asset(
                  "assets/icons/achive.png", // apni image ka path
                  width: 22,
                  height: 22,
                  fit: BoxFit.contain,
                  color: Colors.white,
                ),
                SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context)!.your_cycling_identity,
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    height: 1.56, // 28 / 18
                    letterSpacing: 0,
                    color: Colors.white,
                  ),
                )
              ],
            ),

            const SizedBox(height: 8),

            /// DESCRIPTION
            Padding(
                padding: const EdgeInsets.only(left: 32),
                child: Text(
                  AppLocalizations.of(context)!.cycling_stats_from_events,
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    height: 1, // line-height 100%
                    letterSpacing: 0,
                    color: Colors.white,
                  ),
                )),

            const SizedBox(height: 18),

            /// PROGRESS TEXT
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.level_progress,
                  style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 13.0946,
                      fontWeight: FontWeight.w400,
                      height: 1.43,
                      letterSpacing: 0,
                      color: Colors.white),
                ),
                Text(
                  progressText,
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 13.0946,
                    fontWeight: FontWeight.w400,
                    height: 1.43, // 18.7066 / 13.0946
                    letterSpacing: 0,
                    color: Colors.white,
                  ),
                )
              ],
            ),

            const SizedBox(height: 7),

            /// PROGRESS BAR
            Container(
              width: double.infinity,
              height: 11.21,
              decoration: BoxDecoration(
                color: const Color(0xFFC2C2C2), // empty color
                borderRadius: BorderRadius.circular(100),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final progressWidth =
                      (progressPercent.clamp(0.0, 1.0)) * constraints.maxWidth;
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: progressWidth,
                      decoration: BoxDecoration(
                        color: Colors.white, // filled color
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 10),

            /// LEVELS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _LevelItem(number: "1", label: AppLocalizations.of(context)!.beginner),
                _LevelItem(number: "2", label: AppLocalizations.of(context)!.intermediate),
                _LevelItem(number: "3", label: AppLocalizations.of(context)!.advancedLevel),
                _LevelItem(number: "4", label: AppLocalizations.of(context)!.ambassador),
              ],
            ),

            const Spacer(),

            /// FOOTER TEXT
            Center(
              child: Text(
                AppLocalizations.of(context)!.keep_riding_to_level_up,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 13.0946,
                    fontWeight: FontWeight.w400,
                    height: 1.43,
                    letterSpacing: 0,
                    color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _LevelItem extends StatelessWidget {
  final String number;
  final String label;

  const _LevelItem({
    required this.number,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 40.4739,
          height: 40.4739,
          decoration: const BoxDecoration(
            color: Color(0xFFBCB0FF),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            number,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontFamily: 'Outfit',
                fontSize: 15.1777,
                fontWeight: FontWeight.w400,
                height: 1.56,
                letterSpacing: 0,
                color: Colors.white),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 8.4321,
              fontWeight: FontWeight.w400,
              height: 1.87,
              letterSpacing: 0,
              color: Colors.white),
        )
      ],
    );
  }
}
