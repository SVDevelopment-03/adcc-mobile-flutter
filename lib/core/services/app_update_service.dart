import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'api_client.dart';

class AppUpdateCheckResult {
  const AppUpdateCheckResult({
    required this.currentVersion,
    required this.minimumVersion,
    required this.storeUrl,
    required this.platform,
    required this.isUpdateRequired,
    required this.isForceUpdate,
    required this.message,
  });

  final String currentVersion;
  final String minimumVersion;
  final String storeUrl;
  final String platform;
  final bool isUpdateRequired;
  final bool isForceUpdate;
  final String message;
}

class AppUpdateService {
  static const String _androidPlatform = 'android';
  static const String _iosPlatform = 'ios';

  static const String _defaultAndroidStoreUrl =
      'https://play.google.com/store/apps/details?id=com.technation.adcc';
  static const String _defaultIOSStoreUrl =
      'https://apps.apple.com/ae/app/adcycling/id1481435670';

  static String get platformName {
    if (Platform.isIOS) return _iosPlatform;
    return _androidPlatform;
  }

  static Future<AppUpdateCheckResult?> checkFromRemote({Dio? dio}) async {
    try {
      final client = dio ?? ApiClient.instance.dio;
      final response = await client.get('/v1/app-config');
      final payload = response.data is Map ? response.data as Map<String, dynamic> : null;
      final config = payload != null && payload['data'] is Map
          ? Map<String, dynamic>.from(payload['data'] as Map)
          : <String, dynamic>{};
      final appConfig = config['config'] is Map
          ? Map<String, dynamic>.from(config['config'] as Map)
          : <String, dynamic>{};
      return await evaluateConfig(appConfig);
    } catch (_) {
      return null;
    }
  }

  static Future<AppUpdateCheckResult?> evaluateConfig(Map<String, dynamic>? config) async {
    final appUpdate = config != null && config['appUpdate'] is Map
        ? Map<String, dynamic>.from(config['appUpdate'] as Map)
        : <String, dynamic>{};

    final currentPlatform = platformName;
    final settings = appUpdate[currentPlatform] is Map
        ? Map<String, dynamic>.from(appUpdate[currentPlatform] as Map)
        : <String, dynamic>{};

    final minimumVersion = (settings['minimumVersion'] ?? '').toString().trim();
    final storeUrl = (settings['storeUrl'] ?? _defaultStoreUrlFor(currentPlatform)).toString().trim();
    final forceUpdate = settings['forceUpdate'] == true;
    final updateMessage = (settings['updateMessage'] ??
            (forceUpdate
                ? 'A required update is available. Please update the app to continue.'
                : 'A new version is available. Please update the app for the best experience.'))
        .toString();

    if (minimumVersion.isEmpty) {
      return null;
    }

    final currentVersion = await _currentPackageVersion();
    final isUpdateRequired = compareVersions(currentVersion, minimumVersion) < 0;

    return AppUpdateCheckResult(
      currentVersion: currentVersion,
      minimumVersion: minimumVersion,
      storeUrl: storeUrl,
      platform: currentPlatform,
      isUpdateRequired: isUpdateRequired,
      isForceUpdate: forceUpdate,
      message: updateMessage,
    );
  }

  static String _defaultStoreUrlFor(String platform) {
    return platform == _iosPlatform ? _defaultIOSStoreUrl : _defaultAndroidStoreUrl;
  }

  static Future<String> _currentPackageVersion() async {
    final info = await PackageInfo.fromPlatform();
    return info.version.isEmpty ? '0.0.0' : info.version;
  }

  static Future<void> openStore(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null || !uri.hasScheme) return;
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched) {
      debugPrint('Failed to open update URL: $url');
    }
  }

  static int compareVersions(String left, String right) {
    final leftParts = _parseVersion(left);
    final rightParts = _parseVersion(right);
    final maxLength = leftParts.length > rightParts.length ? leftParts.length : rightParts.length;

    for (var i = 0; i < maxLength; i++) {
      final a = i < leftParts.length ? leftParts[i] : 0;
      final b = i < rightParts.length ? rightParts[i] : 0;
      if (a < b) return -1;
      if (a > b) return 1;
    }

    return 0;
  }

  static List<int> _parseVersion(String version) {
    final normalized = version.trim();
    if (normalized.isEmpty) return const [0];

    final withoutBuild = normalized.split('+').first;
    final segments = withoutBuild
        .split(RegExp(r'[^0-9]+'))
        .where((segment) => segment.isNotEmpty)
        .map(int.parse)
        .toList();

    if (segments.isEmpty) return const [0];
    return segments;
  }
}
