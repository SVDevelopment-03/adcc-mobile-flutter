import 'package:adcc/core/constants/api_endpoints.dart';
import 'package:adcc/core/services/api_client.dart';
import 'package:adcc/core/utils/response_parser.dart';
import 'package:adcc/features/notifications/models/notification_item_model.dart';

class NotificationsRepository {
  final ApiClient _apiClient;

  NotificationsRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient.instance;

  Future<List<NotificationItemModel>> fetchInbox() async {
    try {
      final response = await _apiClient.get<dynamic>(
        ApiEndpoints.pushNotificationsInbox,
      );

      final list = ResponseParser.extractList(
        response.data,
        const ['notifications', 'items', 'results', 'data'],
      );

      return list
          .whereType<Map<String, dynamic>>()
          .map(NotificationItemModel.fromJson)
          .toList();
    } catch (_) {
      return const [];
    }
  }

  Future<bool> markAllRead() async {
    try {
      final response = await _apiClient.patch<dynamic>(
        ApiEndpoints.pushNotificationsReadAll,
      );
      return response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300;
    } catch (_) {
      return false;
    }
  }

  Future<bool> markRead(String id) async {
    try {
      final response = await _apiClient.patch<dynamic>(
        ApiEndpoints.pushNotificationRead(id),
      );
      return response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300;
    } catch (_) {
      return false;
    }
  }

  Future<bool> deleteNotification(String id) async {
    try {
      final response = await _apiClient.delete<dynamic>(
        ApiEndpoints.pushNotificationDelete(id),
      );
      return response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300;
    } catch (_) {
      return false;
    }
  }
}
