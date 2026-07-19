import 'dart:async';
import 'package:adcc/l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/navigation/app_navigation.dart';
import 'core/navigation/app_routes.dart';
import 'core/navigation/deep_link_service.dart';
import 'core/navigation/route_generator.dart';
import 'core/services/language_storage_service.dart';
import 'core/services/notification_service.dart';
import 'core/theme/app_theme.dart';
import 'features/splash/view/splash_screen.dart';
import 'package:adcc/features/notifications/repositories/push_notification_repository.dart';

bool _isSystemContextMenuConnectionAssertion(FlutterErrorDetails details) {
  final exceptionText = details.exceptionAsString();
  return exceptionText.contains(
    'Currently, the system context menu can only be shown for an active text input connection',
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final previousOnError = FlutterError.onError;
  FlutterError.onError = (FlutterErrorDetails details) {
    // Workaround for a known Flutter framework issue where SystemContextMenu
    // may build while no active text input connection exists.
    if (_isSystemContextMenuConnectionAssertion(details)) {
      debugPrint('[Flutter] Ignored SystemContextMenu active connection assertion');
      return;
    }

    if (previousOnError != null) {
      previousOnError(details);
      return;
    }
    FlutterError.presentError(details);
  };

  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp().timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          print('[Firebase] Initialization timeout');
          throw TimeoutException('Firebase initialization timed out');
        },
      );
      print('[Firebase] Initialized successfully from Dart');
      await FirebaseAuth.instance.setSettings(
        appVerificationDisabledForTesting: false,
      );
    }

    // Initialize FCM
    await _initializeFCM();
  } catch (e) {
    print('[Firebase] Initialization failed: $e');
  }

  runApp(const MyApp());
}

Future<void> _initializeFCM() async {
  try {
    final notificationService = NotificationService();
    await notificationService.initialize();

    // Get FCM token and register with backend
    final token = await notificationService.getDeviceToken();
    if (token != null) {
      final deviceInfo = notificationService.getDeviceInfo();
      final repository = PushNotificationRepository();

      try {
        await repository.registerFcmToken(
          token: token,
          platform: deviceInfo['platform'],
          userAgent: deviceInfo['userAgent'],
        );
        print('[FCM] Token registered with backend');
      } catch (e) {
        print('[FCM] Token registration failed: $e');
      }
    }

    // Listen to token refresh
    notificationService.onTokenRefresh((newToken) async {
      print('[FCM] Token refreshed: $newToken');
      final deviceInfo = notificationService.getDeviceInfo();
      final repository = PushNotificationRepository();
      try {
        await repository.registerFcmToken(
          token: newToken,
          platform: deviceInfo['platform'],
          userAgent: deviceInfo['userAgent'],
        );
        print('[FCM] New token registered with backend');
      } catch (e) {
        print('[FCM] New token registration failed: $e');
      }
    });

    // Handle notification callbacks
    notificationService.onForegroundMessage = (RemoteMessage message) {
      print('[FCM] Foreground notification: ${message.notification?.title}');
      // Show notification UI/snackbar in foreground if desired
    };

    notificationService.onMessageOpenedFromBackground = (RemoteMessage message) {
      print('[FCM] Opened from background: ${message.notification?.title}');
      _handleNotificationTap(message);
    };

    notificationService.onMessageOpenedFromTerminated = (RemoteMessage message) {
      print('[FCM] Opened from terminated: ${message.notification?.title}');
      _handleNotificationTap(message);
    };
  } catch (e) {
    print('[FCM] Initialization error: $e');
  }
}

void _handleNotificationTap(RemoteMessage message) {
  final title = message.notification?.title?.trim().toLowerCase() ?? '';
  final body = message.notification?.body?.trim();

  if (!title.contains('rejected')) {
    return;
  }

  final rejectionMessage =
      (body != null && body.isNotEmpty)
          ? body
          : 'Your feed post was rejected. Please check the moderation details.';

  void openMyPosts() {
    // TODO: Implement navigation to MyFeedPostsScreen once the file is created
    debugPrint('[FCM] Post rejected: $rejectionMessage');
    // appNavigatorKey.currentState?.push(
    //   MaterialPageRoute(builder: (_) => MyFeedPostsScreen(rejectionMessage: rejectionMessage)));
  }

  if (appNavigatorKey.currentState == null) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      openMyPosts();
    });
    return;
  }

  openMyPosts();
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static void setLocale(BuildContext context, Locale locale) {
    final state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(locale);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en');

  @override
  void initState() {
    super.initState();
    _loadSavedLocale();
    DeepLinkService.instance.initialize();
  }

  @override
  void dispose() {
    DeepLinkService.instance.dispose();
    super.dispose();
  }

  Future<void> _loadSavedLocale() async {
    final saved = await LanguageStorageService.getLocaleCode();
    if (!mounted) return;
    if (saved == null) return;
    setState(() {
      _locale = Locale(saved);
    });
  }

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ADCC Mobile App',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      navigatorKey: appNavigatorKey,

      locale: _locale,

      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      supportedLocales: const [Locale('en'), Locale('ar')],

      initialRoute: AppRoutes.splash,
      onGenerateRoute: RouteGenerator.generateRoute,
      onUnknownRoute: (settings) => MaterialPageRoute(builder: (_) => const SplashScreen()),
    );
  }
}
