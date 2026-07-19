import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'package:adcc/features/notifications/view/notifications_screen.dart';

class BannerHeadder extends StatelessWidget {
  final String? imagePath; // Asset image
  final String? base64Image; // API base64 image
  final String title;
  final double height;
  final String subtitle;
  final bool showNotificationIcon;
  final VoidCallback? onBackTap;
  final bool centerTitle;
  const BannerHeadder({
    super.key,
    this.imagePath,
    this.base64Image,
    required this.title,
    this.height = 220,
    this.showNotificationIcon = false,
    required this.subtitle,
    this.onBackTap,
    this.centerTitle = false,
  });

  ImageProvider _buildImage() {
    final resolvedImagePath = imagePath?.trim() ?? '';
    final resolvedBase64Image = base64Image?.trim() ?? '';

    if (resolvedBase64Image.isNotEmpty && resolvedBase64Image.contains(',')) {
      try {
        final base64String = resolvedBase64Image.split(',').last;
        Uint8List bytes = base64Decode(base64String);
        return MemoryImage(bytes);
      } catch (e) {
        return const AssetImage('assets/images/no-img.jpg');
      }
    }

    if (resolvedImagePath.isNotEmpty) {
      if (resolvedImagePath.startsWith('http')) {
        return NetworkImage(resolvedImagePath);
      }
      return AssetImage(resolvedImagePath);
    }

    return const AssetImage('assets/images/no-img.jpg');
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: Stack(
          children: [
            /// Background Image
            Positioned.fill(
              child: Image(
                image: _buildImage(),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppColors.softCream,
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.image,
                      size: 34,
                      color: Colors.black45,
                    ),
                  );
                },
              ),
            ),

            /// Gradient Overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.05),
                      Colors.black.withValues(alpha: 0.35),
                      Colors.black.withValues(alpha: 0.85),
                    ],
                  ),
                ),
              ),
            ),

            /// Back Button
            Positioned(
              left: 14,
              top: 14,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onBackTap ?? () => Navigator.pop(context),
                  borderRadius: BorderRadius.circular(999),
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back_rounded,
                      color: Color(0xFFB93A3A),
                      size: 22,
                    ),
                  ),
                ),
              ),
            ),

            // notifocation Button (top-right)
            if (showNotificationIcon)
              Positioned(
                right: 14,
                top: 14,
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(999),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const NotificationsScreen(),
                          ),
                        );
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.paleGreen.withValues(alpha: 0.36),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.notifications,
                          color: AppColors.deepRed,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            if (centerTitle)
              Positioned(
                bottom: 21,
                left: 0,
                right: 0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Outfit',
                        fontWeight: FontWeight.w600,
                        fontSize: 22,
                        height: 1,
                        letterSpacing: 0,
                        color: Colors.white,
                      ),
                    ),
                    if (subtitle.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          height: 1,
                          color: Colors.white,
                        ),
                      ),
                    ]
                  ],
                ),
              )
            else
              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
