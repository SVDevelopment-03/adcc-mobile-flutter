import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class AppBackButton extends StatelessWidget {
  final VoidCallback? onBack;
  final Color? backgroundColor;
  final Color? iconColor;
  final String? iconPath;

  const AppBackButton({
    super.key,
    this.onBack,
    this.backgroundColor,
    this.iconColor,
    this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onBack ?? () {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.paleGreen.withValues(alpha: 0.36),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        // child: iconPath != null
        //     ? Image.asset(
        //         iconPath!,
        //         height: 20,
        //         width: 20,
        //         fit: BoxFit.contain,
        //         errorBuilder: (context, error, stackTrace) {
        //           return Icon(
        //             Icons.arrow_back_ios,
        //             color: iconColor ?? Colors.white,
        //             size: 20,
        //           );
        //         },
        //       )
        //     : Icon(
        //         Icons.arrow_back_ios,
        //         color: iconColor ?? Colors.white,
        //         size: 20,
        //       ),
        child: Icon(
          Icons.arrow_back,
          color: iconColor ?? AppColors.brand_green,
          size: 20,
        ),
      ),
    );
  }
}

