import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/back_button_widget.dart';

class MyCyclingDetailsHeaderSection extends StatelessWidget {
  const MyCyclingDetailsHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top app bar with back button and title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              AppBackButton(
                backgroundColor: AppColors.paleGreen.withValues(alpha: 0.36),
                iconColor: AppColors.brand_green,
                onBack: () {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  }
                },
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),

        // Header card with image and title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                /// Background Image
                Image.asset(
                  'assets/images/community_ride.png',
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),

                /// Gradient Overlay
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black54,
                        ],
                      ),
                    ),
                  ),
                ),

                /// Title Text
                Positioned(
                  left: 16,
                  bottom: 16,
                  right: 16,
                  child: Text(
                    "My cycling details",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

