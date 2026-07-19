import 'package:adcc/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class InfoTile extends StatelessWidget {
  final IconData? icon;
  final String label;
  final String value;

  const InfoTile({
    super.key,
     this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.dustyRose, // soft cream
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
         mainAxisSize: MainAxisSize.min,
        children: [
          if(icon != null)
          Icon(
            icon,
            size: 20,
            color: const Color(0xFFE53935), // red icon
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
