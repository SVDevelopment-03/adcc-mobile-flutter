import 'package:adcc/core/constants/api_endpoints.dart';
import 'package:adcc/core/services/api_client.dart';
import 'package:adcc/core/services/api_exception.dart';
import 'package:adcc/core/services/api_response.dart';
import 'package:adcc/core/services/token_storage_service.dart';
import 'package:dio/dio.dart';

class AuthService {
  static Future<ApiResponse<Map<String, dynamic>>> guestLogin() async {
    try {
      final response = await ApiClient.instance.post(
        ApiEndpoints.guestLogin,
      );

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromResponse(
        response.data,
      );

      if (apiResponse.success && apiResponse.data != null) {
        final accessToken = apiResponse.data!['accessToken'];
        final refreshToken = apiResponse.data!['refreshToken'];

        if (accessToken != null) {
          await TokenStorageService.saveAccessToken(accessToken);
        }

        if (refreshToken != null) {
          await TokenStorageService.saveRefreshToken(refreshToken);
        }

        await TokenStorageService.saveGuestUser(true);
      }

      return apiResponse;
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  /// Calls POST /v1/auth/verify with the Firebase ID token in the request body.
  /// Backend verifies the Firebase token and returns:
  ///   - Existing user: { user, accessToken, refreshToken }
  ///   - New user:      { isNewUser: true, uid, accessToken, refreshToken }
  /// The returned accessToken is a temporary backend JWT used to authorise /register.
  static Future<ApiResponse<Map<String, dynamic>>> verifyOtp(
      String idToken) async {
    try {
      final response = await ApiClient.instance.post(
        ApiEndpoints.authVerify,
        data: {'idToken': idToken},
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

        // Persist name immediately for returning users
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
      }

      return apiResponse;
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  /// Server-side OTP send (calls /v1/otp/send)
  static Future<ApiResponse<Map<String, dynamic>>> sendOtpToServer({
    required String recipient,
    String? sender,
    String? category,
  }) async {
    try {
      // Normalize recipient to digits only (backend expects numeric MSISDN)
      final normalizedRecipient = recipient.replaceAll(RegExp(r'[^0-9]'), '');

      // Helpful debug output during development
      // avoid importing Flutter in services layer; use plain print
      print('[AuthService] Sending OTP to normalized recipient: $normalizedRecipient');
      final response = await ApiClient.instance.post(
        ApiEndpoints.otpSend,
        data: {
          'recipient': normalizedRecipient,
          if (sender != null) 'sender': sender,
          if (category != null) 'category': category,
        },
      );

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromResponse(
        response.data,
      );

      return apiResponse;
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  /// Server-side OTP verify (calls /v1/otp/verify)
  static Future<ApiResponse<Map<String, dynamic>>> verifyOtpWithServer({
    required String recipient,
    required String code,
  }) async {
    try {
      final response = await ApiClient.instance.post(
        ApiEndpoints.otpVerify,
        data: {
          'recipient': recipient,
          'code': code,
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

        // Persist name immediately for returning users
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
      }

      return apiResponse;
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  /// Calls POST /v1/auth/register.
  /// Requires a valid backend JWT in storage (saved by verifyOtp); the API
  /// interceptor automatically attaches it as Authorization: Bearer <token>.
  static Future<ApiResponse<Map<String, dynamic>>> registerUser({
    required String fullName,
    required String gender,
    required String dob,
    String? country,
    String? city,
    String? email,
  }) async {
    try {
      final response = await ApiClient.instance.post(
        ApiEndpoints.authRegister,
        data: {
          'fullName': fullName,
          'gender': gender,
          'dob': dob,
          if (email != null) 'email': email,
          if (country != null) 'country': country,
          if (city != null) 'city': city,
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

        await TokenStorageService.saveUserName(fullName);
      }

      return apiResponse;
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  /// Ensure there is a valid access token available.
  /// If missing but a refresh token exists, attempt to refresh and save new tokens.
  /// Returns true when a usable access token is available, false otherwise.
  static Future<bool> ensureAccessToken() async {
    final access = await TokenStorageService.getAccessToken();
    if (access != null && access.isNotEmpty) return true;

    final refresh = await TokenStorageService.getRefreshToken();
    if (refresh == null || refresh.isEmpty) return false;

    try {
      final dio = ApiClient.instance;
      final response = await dio.post(ApiEndpoints.authRefresh, data: {'refreshToken': refresh});
      final payload = response.data as Map<String, dynamic>?;
      final data = payload?['data'] ?? payload;

      final accessToken = data is Map ? data['accessToken'] as String? : null;
      final refreshToken = data is Map ? data['refreshToken'] as String? : null;

      if (accessToken != null && accessToken.isNotEmpty) {
        await TokenStorageService.saveAccessToken(accessToken);
        if (refreshToken != null && refreshToken.isNotEmpty) {
          await TokenStorageService.saveRefreshToken(refreshToken);
        }
        return true;
      }
    } catch (_) {
      // ignore and return false
    }

    return false;
  }
}
