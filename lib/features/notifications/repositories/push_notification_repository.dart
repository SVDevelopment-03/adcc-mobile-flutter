import 'package:dio/dio.dart';
import 'package:adcc/core/constants/api_endpoints.dart';
import 'package:adcc/core/services/api_client.dart';

class PushNotificationRepository {
  /// Register FCM token with backend
  Future<Response> registerFcmToken({
    required String token,
    required String platform,
    String? userAgent,
    String? deviceId,
    String? deviceModel,
    String? osVersion,
    String? appVersion,
    String? appBuild,
  }) async {
    try {
      final response = await ApiClient.instance.post(
        ApiEndpoints.pushNotificationsRegister,
        data: {
          'token': token,
          'platform': platform,
          if (userAgent != null) 'userAgent': userAgent,
          if (deviceId != null) 'deviceId': deviceId,
          if (deviceModel != null) 'deviceModel': deviceModel,
          if (osVersion != null) 'osVersion': osVersion,
          if (appVersion != null) 'appVersion': appVersion,
          if (appBuild != null) 'appBuild': appBuild,
        },
      );
      return response;
    } catch (e) {
      print('[PushNotificationRepository] registerFcmToken error: $e');
      rethrow;
    }
  }

  /// Unregister FCM token from backend
  Future<Response> unregisterFcmToken(String token) async {
    try {
      final response = await ApiClient.instance.post(
        ApiEndpoints.pushNotificationsUnregister,
        data: {'token': token},
      );
      return response;
    } catch (e) {
      print('[PushNotificationRepository] unregisterFcmToken error: $e');
      rethrow;
    }
  }

  /// Get notifications inbox
  Future<Response> getNotificationsInbox({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await ApiClient.instance.get(
        '${ApiEndpoints.pushNotificationsInbox}?page=$page&limit=$limit',
      );
      return response;
    } catch (e) {
      print('[PushNotificationRepository] getNotificationsInbox error: $e');
      rethrow;
    }
  }

  /// Mark single notification as read
  Future<Response> markNotificationAsRead(String notificationId) async {
    try {
      final response = await ApiClient.instance.patch(
        ApiEndpoints.pushNotificationRead(notificationId),
      );
      return response;
    } catch (e) {
      print('[PushNotificationRepository] markNotificationAsRead error: $e');
      rethrow;
    }
  }

  /// Mark all notifications as read
  Future<Response> markAllNotificationsAsRead() async {
    try {
      final response = await ApiClient.instance.patch(
        ApiEndpoints.pushNotificationsReadAll,
      );
      return response;
    } catch (e) {
      print('[PushNotificationRepository] markAllNotificationsAsRead error: $e');
      rethrow;
    }
  }
}
