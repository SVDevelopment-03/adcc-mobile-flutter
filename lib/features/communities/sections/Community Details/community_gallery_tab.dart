import 'dart:convert';

import 'package:adcc/core/constants/api_endpoints.dart';
import 'package:adcc/core/services/api_client.dart';
import 'package:adcc/core/utils/response_parser.dart';
import 'package:adcc/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class CommunityGalleryTab extends StatefulWidget {
  final String? communityId;

  const CommunityGalleryTab({super.key, this.communityId});

  @override
  State<CommunityGalleryTab> createState() => _CommunityGalleryTabState();
}

class _CommunityGalleryTabState extends State<CommunityGalleryTab> {
  late Future<List<String>> _galleryFuture;

  @override
  void initState() {
    super.initState();
    _galleryFuture = _loadGallery();
  }

  Future<List<String>> _loadGallery() async {
    final communityId = widget.communityId?.trim() ?? '';
    if (communityId.isEmpty) {
      debugPrint('CommunityGalleryTab: empty communityId; skipping gallery API');
      return const [];
    }

    try {
      debugPrint('CommunityGalleryTab: loading gallery for $communityId');
      final response = await ApiClient.instance.get<dynamic>(
        ApiEndpoints.communityGallery(communityId),
      );

      final map = ResponseParser.extractMap(response.data, const ['data']);
      final gallery =
          ResponseParser.extractList(map ?? response.data, const ['gallery']);

      return gallery
          .whereType<String>()
          .where((value) => value.trim().isNotEmpty)
          .toList();
    } catch (_) {
      return const [];
    }
  }

  ImageProvider _resolveImage(String value) {
    if (value.startsWith('http')) {
      return NetworkImage(value);
    }

    if (value.contains('base64,')) {
      try {
        final cleaned = value.split('base64,').last;
        return MemoryImage(base64Decode(cleaned));
      } catch (_) {}
    }

    return AssetImage(
        value.startsWith('assets/') ? value : 'assets/images/no-img.jpg');
  }

  Widget _galleryImageTile(String imageUrl, {double? height, double? width}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: height,
        width: width,
        child: Image(
          image: _resolveImage(imageUrl),
          fit: BoxFit.cover,
          height: height ?? double.infinity,
          width: width ?? double.infinity,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    const Color(0xFF1B1A6E).withValues(alpha: 0.7),
                  ),
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              ),
            );
          },
          errorBuilder: (_, __, ___) => Container(
            color: const Color(0xFFD6F6FF),
            child: const Center(
              child: Icon(Icons.broken_image_outlined, color: Color(0xFF1B1A6E)),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: _galleryFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 220,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final gallery = snapshot.data ?? const <String>[];

        if (gallery.isEmpty) {
          return SizedBox(
            height: 220,
            child: Center(
              child: Text(AppLocalizations.of(context)!.community_no_gallery_images),
            ),
          );
        }

        final images = gallery.take(4).toList();

        return SizedBox(
          height: 220,
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: _galleryImageTile(images.first, height: 220),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: _galleryImageTile(
                        images.length > 1 ? images[1] : images.first,
                        height: 68,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: _galleryImageTile(
                        images.length > 2 ? images[2] : images.first,
                        height: 68,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: _galleryImageTile(
                        images.length > 3 ? images[3] : images.first,
                        height: 68,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
