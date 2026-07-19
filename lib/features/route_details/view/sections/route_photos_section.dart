import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class RoutePhotosSection extends StatelessWidget {
  final List<String> photoPaths;

  const RoutePhotosSection({
    super.key,
    required this.photoPaths,
  });

  bool _isBase64(String path) {
    return path.startsWith('data:image');
  }

  Widget _buildImage(String path, double height) {
    if (path.isEmpty) {
      return _fallbackContainer(height);
    }

    try {
      if (_isBase64(path)) {
        final base64String = path.split(',').last;
        return Image.memory(
          base64Decode(base64String),
          height: height,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _fallbackContainer(height),
        );
      } else if (path.startsWith('http')) {
        return Image.network(
          path,
          height: height,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _fallbackContainer(height),
        );
      } else {
        return Image.asset(
          path,
          height: height,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _fallbackContainer(height),
        );
      }
    } catch (_) {
      return _fallbackContainer(height);
    }
  }

  Widget _fallbackContainer(double height) {
    return Container(
      height: height,
      width: double.infinity,
      color: AppColors.softCream,
      child: const Icon(
        Icons.image,
        size: 48,
        color: AppColors.textSecondary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (photoPaths.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tracks Views & Community Photos',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left big image
              Expanded(
                flex: 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _buildImage(photoPaths[0], 200),
                ),
              ),
              const SizedBox(width: 12),

              // Right side images
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    if (photoPaths.length > 1)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: _buildImage(photoPaths[1], 94),
                      ),
                    if (photoPaths.length > 1) const SizedBox(height: 12),
                    if (photoPaths.length > 2)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: _buildImage(photoPaths[2], 94),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
