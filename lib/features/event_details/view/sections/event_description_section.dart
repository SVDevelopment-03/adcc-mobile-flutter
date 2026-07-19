import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class EventDescriptionSection extends StatelessWidget {
  final String description;

  const EventDescriptionSection({
    super.key,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About this Event',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.charcoal,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppColors.charcoal,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

