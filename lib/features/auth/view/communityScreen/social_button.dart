import 'package:flutter/material.dart';

class SocialButton extends StatelessWidget {
  final String imagePath;
  final VoidCallback? onTap;

  const SocialButton({
    super.key,
    required this.imagePath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 6,
            ),
          ],
        ),
        child: Center(
          child: Image.asset(
            imagePath,
            width: 26,
            height: 26,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
