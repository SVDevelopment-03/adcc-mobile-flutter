import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:adcc/core/constants/api_endpoints.dart';
import 'package:adcc/core/services/api_client.dart';
import 'package:adcc/core/services/api_exception.dart';
import 'package:adcc/core/services/api_response.dart';
import 'package:adcc/core/services/token_storage_service.dart';
import 'package:dio/dio.dart';

/// Service for handling Google and Facebook authentication
class SocialAuthService {
  // Initialize Google Sign-In
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'profile',
    ],
  );

  /// Login with Google
  /// Returns the user info and tokens from the backend
  static Future<ApiResponse<Map<String, dynamic>>> loginWithGoogle() async {
    try {
      debugPrint('🔵 Starting Google Sign-In...');

      // Sign in with Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        debugPrint('❌ Google sign-in cancelled by user');
        throw ApiException(message: 'Google sign-in cancelled');
      }

      debugPrint('✅ Google sign-in successful: ${googleUser.email}');

      // Get authentication details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      if (googleAuth.idToken == null) {
        throw ApiException(message: 'Failed to get Google ID token');
      }

      debugPrint('📡 Sending Google ID token to backend...');

      // Send Google ID token to backend for verification
      final response = await _verifyGoogleToken(googleAuth.idToken!);

      return response;
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      debugPrint('❌ Google login error: $e');
      throw ApiException(message: e.toString());
    }
  }

  /// Login with Facebook
  /// Returns the user info and tokens from the backend
  static Future<ApiResponse<Map<String, dynamic>>> loginWithFacebook() async {
    try {
      debugPrint('🔵 Starting Facebook Login...');

      // Trigger the login user dialog
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['public_profile', 'email'],
      );

      if (result.status == LoginStatus.success) {
        debugPrint('✅ Facebook login successful');

        // Get the access token
        final accessToken = result.accessToken;

        if (accessToken == null) {
          throw ApiException(message: 'Failed to get Facebook access token');
        }

        // Get user data
        final userData = await FacebookAuth.instance.getUserData(
          fields: 'email,name,picture,id',
        );

        debugPrint('📡 Sending Facebook access token to backend...');

        // Send Facebook access token to backend for verification
        // AccessToken.toString() returns the token string
        final response =
            await _verifyFacebookToken(accessToken.toString(), userData);

        return response;
      } else if (result.status == LoginStatus.cancelled) {
        debugPrint('❌ Facebook login cancelled by user');
        throw ApiException(message: 'Facebook login cancelled');
      } else {
        debugPrint('❌ Facebook login error: ${result.message}');
        throw ApiException(message: result.message ?? 'Facebook login failed');
      }
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      debugPrint('❌ Facebook login error: $e');
      throw ApiException(message: e.toString());
    }
  }

  /// Verify Google ID token with backend
  static Future<ApiResponse<Map<String, dynamic>>> _verifyGoogleToken(
    String idToken,
  ) async {
    try {
      final response = await ApiClient.instance.post(
        ApiEndpoints.authVerify,
        data: {
          'idToken': idToken,
          'provider': 'google',
        },
      );

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromResponse(
        response.data,
      );

      if (apiResponse.success && apiResponse.data != null) {
        final data = apiResponse.data!;
        final accessToken = data['accessToken'];
        final refreshToken = data['refreshToken'];

        if (accessToken != null) {
          await TokenStorageService.saveAccessToken(accessToken.toString());
        }
        if (refreshToken != null) {
          await TokenStorageService.saveRefreshToken(refreshToken.toString());
        }
        await TokenStorageService.saveGuestUser(false);

        // Save user info for new users
        final isNewUser = data['isNewUser'] == true;
        if (!isNewUser) {
          final user = data['user'];
          if (user is Map<String, dynamic>) {
            final fullName = user['fullName']?.toString() ?? '';
            if (fullName.isNotEmpty) {
              await TokenStorageService.saveUserName(fullName);
            }
          }
        }

        debugPrint('✅ Google verification successful');
      }

      return apiResponse;
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  /// Verify Facebook access token with backend
  static Future<ApiResponse<Map<String, dynamic>>> _verifyFacebookToken(
    String accessToken,
    Map<String, dynamic> userData,
  ) async {
    try {
      final response = await ApiClient.instance.post(
        ApiEndpoints.authVerify,
        data: {
          'accessToken': accessToken,
          'provider': 'facebook',
          'userData': userData,
        },
      );

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromResponse(
        response.data,
      );

      if (apiResponse.success && apiResponse.data != null) {
        final data = apiResponse.data!;
        final backendAccessToken = data['accessToken'];
        final refreshToken = data['refreshToken'];

        if (backendAccessToken != null) {
          await TokenStorageService.saveAccessToken(
              backendAccessToken.toString());
        }
        if (refreshToken != null) {
          await TokenStorageService.saveRefreshToken(refreshToken.toString());
        }
        await TokenStorageService.saveGuestUser(false);

        // Save user info for new users
        final isNewUser = data['isNewUser'] == true;
        if (!isNewUser) {
          final user = data['user'];
          if (user is Map<String, dynamic>) {
            final fullName = user['fullName']?.toString() ?? '';
            if (fullName.isNotEmpty) {
              await TokenStorageService.saveUserName(fullName);
            }
          }
        }

        debugPrint('✅ Facebook verification successful');
      }

      return apiResponse;
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  /// Sign out from Google
  static Future<void> signOutGoogle() async {
    try {
      await _googleSignIn.signOut();
      debugPrint('✅ Google signed out');
    } catch (e) {
      debugPrint('❌ Error signing out from Google: $e');
    }
  }

  /// Sign out from Facebook
  static Future<void> signOutFacebook() async {
    try {
      await FacebookAuth.instance.logOut();
      debugPrint('✅ Facebook signed out');
    } catch (e) {
      debugPrint('❌ Error signing out from Facebook: $e');
    }
  }

  /// Check if user is signed in to Google
  static Future<bool> isGoogleSignedIn() async {
    return await _googleSignIn.isSignedIn();
  }

  /// Get current Google user
  static GoogleSignInAccount? getCurrentGoogleUser() {
    return _googleSignIn.currentUser;
  }
}
