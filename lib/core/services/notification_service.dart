import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';

// Top-level background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('[FCM] Background message received: ${message.messageId}');
  print('[FCM] Title: ${message.notification?.title}');
  print('[FCM] Body: ${message.notification?.body}');
  // Handle background message - store or process as needed
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  static const int _apnsMaxAttempts = 15;
  static const Duration _apnsRetryDelay = Duration(milliseconds: 500);

  factory NotificationService() => _instance;

  NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // Callbacks
  void Function(RemoteMessage)? onForegroundMessage;
  void Function(RemoteMessage)? onMessageOpenedFromTerminated;
  void Function(RemoteMessage)? onMessageOpenedFromBackground;

  /// Initialize FCM and request permissions
  Future<void> initialize() async {
    try {
      // Register background message handler
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      // Request notification permission
      final status = await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
        criticalAlert: false,
        announcement: false,
      );

      print('[FCM] Permission status: ${status.authorizationStatus}');

      // Get initial message (app opened from terminated state)
      final initialMessage = await _firebaseMessaging.getInitialMessage();
      if (initialMessage != null) {
        print('[FCM] App opened from terminated state');
        onMessageOpenedFromTerminated?.call(initialMessage);
      }

      // Handle message when app is in foreground
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('[FCM] Foreground message received: ${message.messageId}');
        print('[FCM] Title: ${message.notification?.title}');
        print('[FCM] Body: ${message.notification?.body}');
        onForegroundMessage?.call(message);
      });

      // Handle message when app is opened from background
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print('[FCM] App opened from background state');
        onMessageOpenedFromBackground?.call(message);
      });

      print('[FCM] Initialized successfully');
    } catch (e) {
      print('[FCM] Initialization error: $e');
    }
  }

  /// Get FCM device token
  Future<String?> getDeviceToken() async {
    try {
      if (Platform.isIOS) {
        final apnsToken = await _waitForApnsToken();
        if (apnsToken == null) {
          print('[FCM] APNS token is not available yet; skipping FCM token request on iOS');
          return null;
        }
        print('[FCM] APNS token is available: $apnsToken');
      }

      final token = await _firebaseMessaging.getToken();
      print('[FCM] Device token: $token');
      return token;
    } catch (e) {
      print('[FCM] Error getting token: $e');
      return null;
    }
  }

  Future<String?> _waitForApnsToken() async {
    for (int attempt = 1; attempt <= _apnsMaxAttempts; attempt++) {
      final apnsToken = await _firebaseMessaging.getAPNSToken();
      if (apnsToken != null && apnsToken.isNotEmpty) {
        return apnsToken;
      }
      await Future.delayed(_apnsRetryDelay);
    }

    return null;
  }

  /// Get device info for registration
  Map<String, dynamic> getDeviceInfo() {
    final Map<String, dynamic> info = {
      'platform': Platform.isAndroid ? 'android' : (Platform.isIOS ? 'ios' : 'web'),
      'userAgent': 'ADCC Mobile App',
    };

    if (Platform.isAndroid) {
      // Add Android-specific info if needed
    } else if (Platform.isIOS) {
      // Add iOS-specific info if needed
    }

    return info;
  }

  /// Request notification permission (iOS only)
  Future<dynamic> requestPermission() async {
    return await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  /// Check notification permission status
  Future<dynamic> checkPermissionStatus() async {
    final settings = await _firebaseMessaging.getNotificationSettings();
    return settings.authorizationStatus;
  }

  /// Delete token
  Future<void> deleteToken() async {
    try {
      await _firebaseMessaging.deleteToken();
      print('[FCM] Token deleted');
    } catch (e) {
      print('[FCM] Error deleting token: $e');
    }
  }

  /// Listen to token refresh
  void onTokenRefresh(void Function(String) callback) {
    FirebaseMessaging.instance.onTokenRefresh.listen(callback);
  }
}
