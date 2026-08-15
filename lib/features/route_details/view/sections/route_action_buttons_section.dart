import 'package:flutter/material.dart';
import 'package:adcc/l10n/app_localizations.dart';
import '../../../../shared/widgets/app_button.dart';

class RouteActionButtonsSection extends StatelessWidget {
  final VoidCallback? onOpenLinkMyRide;
  final VoidCallback? onOpenMaps;

  const RouteActionButtonsSection({
    super.key,
    this.onOpenLinkMyRide,
    this.onOpenMaps,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppButton(
            label: AppLocalizations.of(context)!.openInLinkMyRide,
            onPressed: onOpenLinkMyRide,
            type: AppButtonType.primary,
            backgroundColor: const Color(0xFF267D4E),
            suffixImage: "assets/icons/units.png",
            suffixImageColor: Colors.white,
            borderRadius: 12,
            height: 51,
          ),
          const SizedBox(height: 12),
          AppButton(
            label: AppLocalizations.of(context)!.openInMaps,
            onPressed: onOpenMaps,
            type: AppButtonType.secondary,
            borderColor: const Color(0xFF267D4E),
            textColor: const Color(0xFF267D4E),
            backgroundColor: Colors.transparent,
            suffixImage: "assets/icons/units.png",
            suffixImageColor: const Color(0xFF267D4E),
            borderRadius: 12,
            height: 51,
          ),
        ],
      ),
    );
  }
}
