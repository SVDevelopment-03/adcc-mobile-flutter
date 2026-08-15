import 'package:flutter/material.dart';
import 'package:adcc/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/app_button.dart';

class AcceptedActionsSection extends StatelessWidget {
  final VoidCallback onShare;
  final VoidCallback onContinue;

  const AcceptedActionsSection({
    super.key,
    required this.onShare,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Share Your Challenge button
        AppButton(
          label: AppLocalizations.of(context)!.challenge_share_button,
          onPressed: onShare,
          type: AppButtonType.primary,
          backgroundColor: AppColors.deepRed,
          textColor: Colors.white,
          width: double.infinity,
          height: 50,
          borderRadius: 12,
          prefixImage: "assets/icons/share_2.png",
          textStyle: const TextStyle(
            fontFamily: "Outfit",
            fontSize: 14.5,
            fontWeight: FontWeight.w400,
            height: 1.5,
            letterSpacing: 0,
          ),
        ),

        const SizedBox(height: 15),

        AppButton(
          label: AppLocalizations.of(context)!.continue_button,
          onPressed: onContinue,
          type: AppButtonType.secondary,
          borderColor: AppColors.charcoal,
          textColor: AppColors.charcoal,
          backgroundColor: Colors.transparent,
          width: double.infinity,
          height: 50,
          borderRadius: 12,
          textStyle: const TextStyle(
            fontFamily: "Outfit",
            fontSize: 14.5,
            fontWeight: FontWeight.w400,
            height: 1.5,
            letterSpacing: 0,
            color: AppColors.charcoal,
          ),
        ),
      ],
    );
  }
}
