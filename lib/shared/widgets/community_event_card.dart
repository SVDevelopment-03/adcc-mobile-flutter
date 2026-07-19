import 'package:flutter/material.dart';

class CommunityEventCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final double height;
  final double borderRadius;
  final VoidCallback? onTap;

  const CommunityEventCard({
    super.key,
    required this.imagePath,
    required this.title,
    this.height = 200,
    this.borderRadius = 20,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Stack(
          children: [
            /// Background Image
            Image.asset(
              imagePath,
              height: height,
              width: double.infinity,
              fit: BoxFit.cover,
            ),

            /// Gradient Overlay
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black54,
                    ],
                  ),
                ),
              ),
            ),

            /// Title Text
            Positioned(
              left: 16,
              bottom: 16,
              right: 16,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
