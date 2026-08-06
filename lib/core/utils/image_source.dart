import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

ImageProvider resolveImageProvider(String? imagePath,
    {String fallbackAsset = 'assets/images/profile.png'}) {
  final value = (imagePath ?? '').trim();

  if (value.isEmpty) {
    return AssetImage(fallbackAsset);
  }

  if (value.startsWith('assets/')) {
    return AssetImage(value);
  }

  final uri = Uri.tryParse(value);
  if (uri != null && (uri.scheme == 'http' || uri.scheme == 'https')) {
    return CachedNetworkImageProvider(value);
  }

  return AssetImage(fallbackAsset);
}
