import 'package:flutter/material.dart';
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
            label: 'Open in Link My Ride',
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
            label: 'Open in Maps',
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
