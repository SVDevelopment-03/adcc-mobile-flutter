import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class StoreSafetySection extends StatelessWidget {
  const StoreSafetySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: 358,
        height: 81,
        decoration: BoxDecoration(
          color: const Color(0xFFF0DDAF),
          borderRadius: BorderRadius.circular(16.4),
          border: Border.all(
            color: const Color(0xFFE2C984),
            width: 1.1659,
          ),
        ),
        child: Stack(
          children: [
            const Positioned(
              left: 16,
              top: 20,
              child: Image(
                image: AssetImage("assets/icons/safety_shield.png"),
                height: 24,
                width: 24,
              ),
            ),

            /// Heading
            Positioned(
              left: 47,
              top: 15,
              child: Text(
                AppLocalizations.of(context)!.safety_tips,
                style: const TextStyle(
                  fontFamily: "Outfit",
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 1.0,
                  letterSpacing: 0,
                  color: AppColors.charcoal,
                ),
              ),
            ),

            Positioned(
              left: 47,
              top: 39,
              child: SizedBox(
                width: 276,
                child: Text(
                  AppLocalizations.of(context)!.meet_the_seller_tip,
                  style: TextStyle(
                    fontFamily: "Outfit",
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    height: 1.0,
                    letterSpacing: 0,
                    color: AppColors.textDark.withOpacity(0.7),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
