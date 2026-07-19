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

      // Get token to check if it exists
      final token = await TokenStorageService.getAccessToken();
      debugPrint(
          ' [AuthWrapper] Token exists: ${token != null && token.isNotEmpty}');

      if (token != null && token.isNotEmpty) {
     
        final isExpired = await TokenStorageService.isTokenExpired();

        if (isExpired) {
    
          await TokenStorageService.clearTokens();
          debugPrint(
              ' [AuthWrapper] User is NOT authenticated (token expired)');
        } else {
        
        }

        final isAuthenticated = !isExpired;

        if (mounted) {
          setState(() {
            _isAuthenticated = isAuthenticated;
            _hasSelectedLanguage = hasSelectedLanguage;
            _isGuestUser = isGuestUser;
            _isLoading = false;
          });

          debugPrint(
              ' [AuthWrapper] Routing to: ${isAuthenticated ? "HomeScreen" : "OnboardingScreen"}');
        }
      } else {
        debugPrint(
            '[AuthWrapper] No token found, user is NOT authenticated');
        if (mounted) {
          setState(() {
            _isAuthenticated = false;
            _hasSelectedLanguage = hasSelectedLanguage;
            _isGuestUser = false;
            _isLoading = false;
          });
          debugPrint(' [AuthWrapper] Routing to: OnboardingScreen');
        }
      }
    } catch (e) {
  
      // On error, assume not authenticated for security
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
