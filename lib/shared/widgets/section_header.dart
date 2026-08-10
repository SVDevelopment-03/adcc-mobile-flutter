import 'package:adcc/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onViewAll;
  final bool showViewAll;

  const SectionHeader({
    super.key,
    required this.title,
    this.onViewAll,
    this.showViewAll = true,
  });

  @override
  Widget build(BuildContext context) {
    final headerRow = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: Text(
          title,
          style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              height: 1,
              letterSpacing: 0,
              color: AppColors.charcoal),
        )),
        if (showViewAll)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'View All',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1.43,
                    letterSpacing: 0,
                    color: AppColors.charcoal),
              ),

              ///TODO: Add onTap to this text and navigate to the full list screen
              const SizedBox(width: 6),
              Image.asset(
                "assets/icons/right_arrow.png",
                height: 12,
                width: 12,
                fit: BoxFit.contain,
              ),
            ],
          ),
      ],
    );

    if (onViewAll != null) {
      return InkWell(
        onTap: onViewAll,
        child: headerRow,
      );
    }

    return headerRow;
  }
}
