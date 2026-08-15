import 'package:flutter/material.dart';
import 'package:adcc/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/app_button.dart';

class EventActionButtonsSection extends StatelessWidget {
  final VoidCallback? firstButtonTab;
  final VoidCallback? secondButtonTab;

  const EventActionButtonsSection({
    super.key,
    this.firstButtonTab,
    this.secondButtonTab,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppButton(
            label: AppLocalizations.of(context)!.routeDetailsPdf,
            onPressed: firstButtonTab,
            type: AppButtonType.primary,
            backgroundColor: AppColors.deepRed,
            suffixIcon: Icons.file_download_outlined,
          ),
          const SizedBox(height: 12),
          AppButton(
            label: AppLocalizations.of(context)!.safetyGuidelinesPdf,
            onPressed: secondButtonTab,
            type: AppButtonType.secondary,
            borderColor: AppColors.deepRed,
            textColor: AppColors.deepRed,
            backgroundColor: Colors.transparent,
            suffixIcon: Icons.file_download_outlined,
          ),
        ],
      ),
    );
  }
}
