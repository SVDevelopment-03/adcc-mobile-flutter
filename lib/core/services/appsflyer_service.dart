import 'dart:io' show Platform;

import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:flutter/foundation.dart';

/// Initializes the AppsFlyer SDK for install attribution.
class AppsFlyerService {
  AppsFlyerService._();

  static const String _devKey = 'mPqB6mmhCKQcQPN4pKNCdf';

  static AppsflyerSdk? _sdk;
  static AppsflyerSdk? get sdk => _sdk;

  static Future<void> init() async {
    if (_sdk != null) return;
    // Android only for now: iOS needs its App Store app ID (and the tracking
    // permission prompt) set up first. Remove this check when iOS is done.
    if (!Platform.isAndroid) return;
    try {
      final options = AppsFlyerOptions(
        afDevKey: _devKey,
        showDebug: kDebugMode,
      );
      final sdk = AppsflyerSdk(options);
      _sdk = sdk;
      await sdk.initSdk(
        registerConversionDataCallback: true,
        registerOnAppOpenAttributionCallback: true,
        registerOnDeepLinkingCallback: true,
      );
      debugPrint('[AppsFlyer] SDK initialized');
    } catch (e) {
      debugPrint('[AppsFlyer] Initialization failed: $e');
    }
  }
}
