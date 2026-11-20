import 'dart:io' show Platform;

import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:flutter/foundation.dart';

/// Initializes the AppsFlyer SDK for install attribution (Android and iOS).
class AppsFlyerService {
  AppsFlyerService._();

  static const String _devKey = 'mPqB6mmhCKQcQPN4pKNCdf';

  /// App Store app ID (numeric, without the "id" prefix). Used on iOS only.
  static const String _iosAppId = '1481435670';

  static AppsflyerSdk? _sdk;
  static AppsflyerSdk? get sdk => _sdk;

  static Future<void> init() async {
    if (_sdk != null) return;
    if (!Platform.isAndroid && !Platform.isIOS) return;
    try {
      final options = AppsFlyerOptions(
        afDevKey: _devKey,
        appId: Platform.isIOS ? _iosAppId : '',
        // iOS: wait up to 60s for the user's answer to the tracking (ATT)
        // prompt, so the install is reported with the right consent status.
        timeToWaitForATTUserAuthorization: Platform.isIOS ? 60 : null,
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
