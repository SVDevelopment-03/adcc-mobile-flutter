import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class EventTitleSection extends StatelessWidget {
  final String title;
  final VoidCallback? onShare;

  const EventTitleSection({
    super.key,
    required this.title,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: AppColors.deepRed,
              ),
            ),
          ),
          if (onShare != null)
            GestureDetector(
              onTap: onShare,
              child: Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  color: AppColors.paleGreen.withValues(alpha: 0.36),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.share,
                  color: AppColors.deepRed,
                  size: 18,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

