import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class EventImageBanner extends StatelessWidget {
  final String? imagePath;
  final String? base64Image;
  final VoidCallback? onBackTap;

  const EventImageBanner({
    super.key,
    this.imagePath,
    this.base64Image,
    this.onBackTap,
  });

  Widget _buildImage() {
    final image = (base64Image?.trim().isNotEmpty == true
            ? base64Image
            : imagePath)
        ?.trim();

    if (image == null || image.isEmpty) {
      return _imagePlaceholder();
    }

    if (image.startsWith('http://') || image.startsWith('https://')) {
      return Image.network(
        image,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _imagePlaceholder(),
      );
    }

    if (image.startsWith('assets/')) {
      return Image.asset(
        image,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _imagePlaceholder(),
      );
    }

    try {
      final base64String = image.contains(',') ? image.split(',').last : image;
      final Uint8List bytes = base64Decode(base64String);
      return Image.memory(
        bytes,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _imagePlaceholder(),
      );
    } catch (_) {
      return _imagePlaceholder();
    }
  }

  Widget _imagePlaceholder() {
    return Container(
      color: const Color(0xFFE6E8EF),
      alignment: Alignment.center,
      child: const Icon(
        Icons.image_outlined,
        color: Colors.black38,
        size: 42,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        height: 414,
        width: double.infinity,
        child: Stack(
          children: [
            Positioned.fill(
              child: _buildImage(),
            ),

            /// Back Button
            Positioned(
              left: 16,
              top: 16,
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
          ],
        ),
      ),
    );
  }
}
