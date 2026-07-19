import 'package:flutter/material.dart';

class QuickActionItem extends StatelessWidget {
  final String title;
  final String imagePath;
  final double iconSize;
  final double iconOffsetY;
  final VoidCallback? onTap;

  const QuickActionItem({
    super.key,
    required this.title,
    required this.imagePath,
    this.iconSize = 32,
    this.iconOffsetY = 0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0x330359E8)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50.31,
              height: 50.31,
              decoration: const BoxDecoration(
                color: Color(0xFFD8E5FB),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Transform.translate(
                  offset: Offset(0, iconOffsetY),
                  child: Image.asset(
                    imagePath,
                    width: iconSize,
                    height: iconSize,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Outfit',
                fontSize: 10.9,
                fontWeight: FontWeight.w400,
                height: 1.15,
                letterSpacing: 0.27,
                color: Color(0xFF000000),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
