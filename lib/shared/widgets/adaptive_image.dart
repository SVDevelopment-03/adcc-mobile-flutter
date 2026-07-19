import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:adcc/core/services/api_client.dart';

/// A widget that can display images from assets, network URLs, or base64 data URIs
class AdaptiveImage extends StatelessWidget {
  final String imagePath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? errorWidget;
  final Color? placeholderColor;

  const AdaptiveImage({
    super.key,
    required this.imagePath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.errorWidget,
    this.placeholderColor,
  });

  bool get _isNetworkImage {
    return imagePath.startsWith('http://') ||
        imagePath.startsWith('https://') ||
        imagePath.startsWith('www.');
  }

  bool get _isRelativeNetworkImage {
    return imagePath.startsWith('/uploads/') ||
        imagePath.startsWith('/media/') ||
        imagePath.startsWith('uploads/') ||
        imagePath.startsWith('media/');
  }

  bool get _isFileImage {
    if (imagePath.startsWith('file://')) return true;
    if (!imagePath.startsWith('/')) return false;

    try {
      return File(imagePath).existsSync();
    } catch (_) {
      return false;
    }
  }

  bool get _isBase64Image {
    return imagePath.startsWith('data:image/');
  }

  @override
  Widget build(BuildContext context) {
    if (_isBase64Image) {
      return _buildBase64Image();
    } else if (_isFileImage) {
      return _buildFileImage();
    } else if (_isNetworkImage || _isRelativeNetworkImage) {
      return _buildNetworkImage();
    } else {
      return _buildAssetImage();
    }
  }

  Widget _buildFileImage() {
    try {
      final filePath = imagePath.startsWith('file://')
          ? Uri.parse(imagePath).toFilePath()
          : imagePath;
      final file = File(filePath);
      return Image.file(
        file,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return errorWidget ?? _defaultErrorWidget();
        },
      );
    } catch (e) {
      return errorWidget ?? _defaultErrorWidget();
    }
  }

  Widget _buildBase64Image() {
    try {
      // Remove data URI prefix (e.g., "data:image/png;base64,")
      final base64String = imagePath.contains(',') 
          ? imagePath.split(',')[1] 
          : imagePath;
      final bytes = base64Decode(base64String);
      
      return Image.memory(
        bytes,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return errorWidget ?? _defaultErrorWidget();
        },
      );
    } catch (e) {
      return errorWidget ?? _defaultErrorWidget();
    }
  }

  Widget _buildNetworkImage() {
    final resolvedUrl = _resolveNetworkUrl(imagePath);
    return Image.network(
      resolvedUrl,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          width: width,
          height: height,
          color: placeholderColor ?? Colors.grey[200],
          child: Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return errorWidget ?? _defaultErrorWidget();
      },
    );
  }

  Widget _buildAssetImage() {
    return Image.asset(
      imagePath,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return errorWidget ?? _defaultErrorWidget();
      },
    );
  }

  String _resolveNetworkUrl(String rawPath) {
    final path = rawPath.trim();
    if (path.startsWith('http://') || path.startsWith('https://')) return path;
    if (path.startsWith('www.')) return 'https://$path';
    if (path.startsWith('/')) {
      final baseUrl = ApiConfig.baseUrl.replaceAll(RegExp(r'/+?$'), '');
      return '$baseUrl$path';
    }
    if (!path.contains('://')) {
      final baseUrl = ApiConfig.baseUrl.replaceAll(RegExp(r'/+?$'), '');
      return '$baseUrl/$path';
    }
    return path;
  }

  Widget _defaultErrorWidget() {
    return Container(
      width: width,
      height: height,
      color: placeholderColor ?? Colors.grey[200],
      child: const Icon(
        Icons.error_outline,
        size: 48,
        color: Colors.grey,
      ),
    );
  }
}
