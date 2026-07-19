import 'package:adcc/core/theme/app_colors.dart';
import 'package:flutter/material.dart';


class AppBackButton extends StatelessWidget {
  final VoidCallback? onTap;

  const AppBackButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(50),
        onTap: onTap ??
            () {
              if (Navigator.of(context).canPop()) {
                Navigator.pop(context);
              }
            },
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.deepRed.withValues(alpha: 0.3),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.deepRed,
            size: 20,
          ),
        ),
      ),
    );
  }
}