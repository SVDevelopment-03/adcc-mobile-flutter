import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../shared/widgets/app_button.dart';

class StoreActionButtonsSection extends StatelessWidget {
  final VoidCallback onWhatsApp;
  final VoidCallback onCall;

  const StoreActionButtonsSection({
    super.key,
    required this.onWhatsApp,
    required this.onCall,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // WhatsApp Button
          AppButton(
            label: 'WhatsApp Seller',
            onPressed: onWhatsApp,
            type: AppButtonType.primary,
            backgroundColor: AppColors.deepRed,
            textColor: Colors.white,
            height: 50,
            borderRadius: 12,
           textStyle: const TextStyle(
  fontFamily: 'Outfit',
  fontSize: 16,
  fontWeight: FontWeight.w500,
  height: 1.5,
  letterSpacing: 0,
),
            // prefixIcon: Icons.chat,
          ),
          const SizedBox(height: 15),
          // Call Button
          AppButton(
            label: 'Call',
            onPressed: onCall,
            type: AppButtonType.secondary,
            backgroundColor: Colors.white,
            textColor: AppColors.deepRed,
            borderColor: AppColors.deepRed,
            height: 50,
            borderRadius: 12,
           textStyle: const TextStyle(
  fontFamily: 'Outfit',
  fontSize: 16,
  fontWeight: FontWeight.w500,
  height: 1.5,
  letterSpacing: 0,
),
            // prefixIcon: Icons.phone,
          ),
        ],
      ),
    );
  }
}

