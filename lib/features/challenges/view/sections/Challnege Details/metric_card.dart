import 'package:adcc/core/theme/app_colors.dart';
import 'package:flutter/material.dart';


class MetricCard extends StatelessWidget {
  final String imagePath;
  final String label;
  final String value;

  const MetricCard({
    super.key,
    required this.imagePath,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 105,
      height: 71,
      decoration: BoxDecoration(
        color: const Color(0xFFFFEFD7),
        borderRadius: BorderRadius.circular(9.9496),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          /// ICON + LABEL
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  imagePath,
                  width: 18,
                  height: 18,
                  fit: BoxFit.contain,
                  color: AppColors.charcoal,
                ),
            
                const SizedBox(width: 6),
            
Text(
  label,
  textAlign: TextAlign.center,
  style: const TextStyle(
    fontFamily: "Outfit",
    fontSize: 12.44,
    fontWeight: FontWeight.w400,
    height: 1.0, // 100% line height
    letterSpacing: 0,
    color: AppColors.charcoal,
  ),
),
              ],
            ),
          ),

          const SizedBox(height: 4),

          /// VALUE
Text(
  value,
  textAlign: TextAlign.center,
  style: const TextStyle(
    fontFamily: "Outfit",
    fontSize: 15.8,
    fontWeight: FontWeight.w500,
    height: 1.43, // 22.56px line height
    letterSpacing: 0,
    color: AppColors.charcoal,
  ),
),
        ],
      ),
    );
  }
}