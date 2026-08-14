import 'package:adcc/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class AcceptedThoughtsSection extends StatelessWidget {
  final TextEditingController controller;

  const AcceptedThoughtsSection({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.challenge_additional_thoughts,
          style: const TextStyle(
            fontFamily: "Outfit",
            fontSize: 20,
            fontWeight: FontWeight.w500,
            height: 1.5,
            letterSpacing: 0,
            color: AppColors.charcoal,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          height: 159,
          decoration: BoxDecoration(
            color: Color(0XFFE9E4DB),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: controller,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: l10n.challenge_thoughts_hint,
              hintStyle: TextStyle(
                fontFamily: "Outfit",
                fontSize: 16,
                fontWeight: FontWeight.w400,
                height: 1.5,
                letterSpacing: 0,
                color: AppColors.charcoal.withOpacity(0.4),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
            style: const TextStyle(
              color: AppColors.charcoal,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
