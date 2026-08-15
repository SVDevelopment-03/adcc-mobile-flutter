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
    if (communityId.isEmpty) return const [];

    try {
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
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image(
                    image: _resolveImage(images.first),
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: double.infinity,
                    errorBuilder: (_, __, ___) => Container(
                      color: const Color(0xFFD6F6FF),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image(
                          image: _resolveImage(
                              images.length > 1 ? images[1] : images.first),
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (_, __, ___) => Container(
                            color: const Color(0xFFD6F6FF),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image(
                          image: _resolveImage(
                              images.length > 2 ? images[2] : images.first),
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (_, __, ___) => Container(
                            color: const Color(0xFFD6F6FF),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image(
                          image: _resolveImage(
                              images.length > 3 ? images[3] : images.first),
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (_, __, ___) => Container(
                            color: const Color(0xFFD6F6FF),
                          ),
                        ),
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
