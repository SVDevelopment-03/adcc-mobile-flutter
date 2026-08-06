import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:adcc/core/constants/cosmatic_imgs.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PurposeBasedEventCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String date;
  final String groupName;
  final VoidCallback? onTap;
  final double width;

  const PurposeBasedEventCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.date,
    required this.groupName,
    this.onTap,
    this.width = 358,
  });

  bool get _isNetworkImage =>
      imagePath.startsWith('http://') || imagePath.startsWith('https://');

  bool get _isBase64Image => imagePath.startsWith('data:image/');

  Uint8List _base64Decode(String dataUri) {
    final base64String =
        dataUri.contains(',') ? dataUri.split(',')[1] : dataUri;
    return base64Decode(base64String);
  }

  Widget _buildImage() {
    if (_isBase64Image) {
      try {
        return Image.memory(
          _base64Decode(imagePath),
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        );
      } catch (_) {
        return _imageFallback();
      }
    }

    if (_isNetworkImage) {
      return Image.network(
        imagePath,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Container(
            color: Colors.grey[200],
            child: const Center(child: CircularProgressIndicator()),
          );
        },
        errorBuilder: (_, __, ___) => _imageFallback(),
      );
    }

    return Image.asset(
      imagePath,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (_, __, ___) => _imageFallback(),
    );
  }

  Widget _imageFallback() {
    return Container(
      color: const Color(0xFFFFC9C9),
      child: const Icon(Icons.error_outline, size: 48, color: Colors.grey),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width,
        height: 275,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            fit: StackFit.expand,
            children: [
              _buildImage(),
              Positioned(
                top: 13,
                left: 12,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 180),
                      height: 24,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1C20).withValues(alpha: 0.33),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        groupName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          color: Color(0xFFFFEFD7),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          height: 1.33,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 15,
                right: 15,
                bottom: 25,
                child: Container(
                  height: 80,
                  padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    image: const DecorationImage(
                      image: CachedNetworkImageProvider(
                        EventsImgs.EventCardDetailBackground,
                      ),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          height: 1.15,
                          color: Colors.black,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 7),
                      Row(
                        children: [
                          Image.asset(
                            'assets/icons/calender.png',
                            height: 14,
                            width: 14,
                            color: Colors.black,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              date,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 12.91,
                                fontWeight: FontWeight.w400,
                                height: 1.42,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
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
