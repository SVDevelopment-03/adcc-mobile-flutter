import 'package:adcc/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class LanguageCard extends StatelessWidget {
  final String image;
  final String label;
  final VoidCallback onTap;

  const LanguageCard({
    super.key, 
    required this.image,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        height: 200,
        decoration: BoxDecoration(
          color: AppColors.warmSand.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(80),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha:0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              image,
              width: 80,
              height: 80,
            ),
            const SizedBox(height: 16),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
