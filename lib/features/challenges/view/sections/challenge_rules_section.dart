import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class ChallengeRulesSection extends StatelessWidget {
  final List<String> rules;

  const ChallengeRulesSection({
    super.key,
    required this.rules,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
  'Challenge Rules',
  style: const TextStyle(
    fontFamily: "Outfit",
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.0, // 100% line height
    letterSpacing: 0,
    color: AppColors.charcoal,
  ),
),
          const SizedBox(height: 24),
          ...rules.map((rule) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 19,
                      height: 19,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.deepRed,
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.check,
                        color: AppColors.deepRed,
                        size: 14,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child:Text(
  rule,
  style: const TextStyle(
    fontFamily: "Outfit",
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.0, // 100% line height
    letterSpacing: 0,
    color: Color(0xFF525252),
  ),
),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

