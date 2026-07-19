import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class RouteHeaderSection extends StatelessWidget {
  final String imagePath;
  final VoidCallback onBack;

  const RouteHeaderSection({
    super.key,
    required this.imagePath,
    required this.onBack,
  });

  bool _isBase64(String path) {
    return path.startsWith('data:image');
  }

  Widget _buildImage() {
    if (imagePath.isEmpty) {
      return _fallback();
    }

    try {
      if (_isBase64(imagePath)) {
        final base64String = imagePath.split(',').last;
        return Image.memory(
          base64Decode(base64String),
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (_, __, ___) => _fallback(),
        );
      } else if (imagePath.startsWith('http')) {
        return Image.network(
          imagePath,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (_, __, ___) => _fallback(),
        );
      } else {
        return Image.asset(
          imagePath,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (_, __, ___) => _fallback(),
        );
      }
    } catch (_) {
      return _fallback();
    }
  }

  Widget _fallback() {
    return Container(
      color: AppColors.softCream,
      alignment: Alignment.center,
      child: const Icon(
        Icons.image,
        size: 40,
        color: Colors.black45,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          height: 414,
          width: double.infinity,
          child: Stack(
            children: [
              Positioned.fill(child: _buildImage()),
              Positioned.fill(
                child: Container(
                  color: Colors.black.withValues(alpha: 0.03),
                ),
              ),
              Positioned(
                left: -35,
                bottom: -35,
                child: Image.asset(
                  'assets/images/frame_1.png',
                  width: 160,
                  height: 160,
                  fit: BoxFit.contain,
                ),
              ),
              Positioned(
                left: 14,
                top: 14,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onBack,
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
                        color: Color(0xFFF09902),
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
