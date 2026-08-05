import 'package:flutter/material.dart';
import '../../../core/services/language_storage_service.dart';
import '../../../core/services/token_storage_service.dart';
import '../../../features/languageOption/view/languageSelectionScreen.dart';
import '../../../features/onboarding/view/onboarding_screen.dart';
import '../../../features/home/view/home_screen.dart';

/// Wrapper widget that checks authentication status and routes accordingly
/// This widget runs every time the app starts to check if user is logged in
class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isLoading = true;
  bool _isAuthenticated = false;
  bool _hasSelectedLanguage = false;
  bool _isGuestUser = false;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  /// Check authentication status on app start/restart
  Future<void> _checkAuthStatus() async {
    debugPrint(' [AuthWrapper] Checking authentication status...');

    try {
      final hasSelectedLanguage = await LanguageStorageService.hasLocaleCode();
      final isGuestUser = await TokenStorageService.isGuestUser();
      final accessToken = await TokenStorageService.getAccessToken();
      final firebaseToken = await TokenStorageService.getFirebaseToken();

      debugPrint(
        ' [AuthWrapper] Access token exists: ${accessToken != null && accessToken.isNotEmpty}',
      );
      debugPrint(
        ' [AuthWrapper] Firebase token exists: ${firebaseToken != null && firebaseToken.isNotEmpty}',
      );

      final hasValidAccessToken = await TokenStorageService.hasValidAccessToken();
      final isAuthenticated = await TokenStorageService.isAuthenticated();

      if (accessToken != null && accessToken.isNotEmpty && !hasValidAccessToken) {
        final expiry = await TokenStorageService.getTokenExpiry();
        if (expiry != null) {
          await TokenStorageService.clearTokens();
          debugPrint(' [AuthWrapper] User is NOT authenticated (token expired)');
        } else {
          debugPrint(' [AuthWrapper] Access token exists but expiry is missing; keeping token.');
        }
      }

      if (mounted) {
        setState(() {
          _isAuthenticated = isAuthenticated;
          _hasSelectedLanguage = hasSelectedLanguage;
          _isGuestUser = isGuestUser;
          _isLoading = false;
        });

        debugPrint(
          ' [AuthWrapper] Routing to: ${isAuthenticated ? "HomeScreen" : "OnboardingScreen"}',
        );
      }
    } catch (e) {
      // On error, assume not authenticated for security
      debugPrint(' [AuthWrapper] Auth status check failed: $e');
      if (mounted) {
        setState(() {
          _isAuthenticated = false;
          _hasSelectedLanguage = false;
          _isGuestUser = false;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      // Show loading screen while checking auth status
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (!_hasSelectedLanguage) {
      debugPrint(' [AuthWrapper] Locale missing - showing LanguageSelectionScreen');
      return const LanguageSelectionScreen();
    }

    if (_isAuthenticated) {
      return HomeScreen(fromGuest: _isGuestUser);
    } else {
      debugPrint(
          ' [AuthWrapper] User not authenticated - showing OnboardingScreen');
      return const OnboardingScreen();
    }
  }
}
