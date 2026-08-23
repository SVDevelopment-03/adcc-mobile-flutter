import 'dart:async';

import 'package:adcc/core/constants/api_endpoints.dart';
import 'package:adcc/core/services/api_client.dart';
import 'package:adcc/core/utils/response_parser.dart';
import 'package:adcc/features/notifications/models/notification_item_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationsRepository {
  static final NotificationsRepository _instance = NotificationsRepository._internal();

  factory NotificationsRepository() => _instance;

  NotificationsRepository._internal({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient.instance;

  final ApiClient _apiClient;
  final List<NotificationItemModel> _localInbox = <NotificationItemModel>[];
  final StreamController<List<NotificationItemModel>> _inboxController =
      StreamController<List<NotificationItemModel>>.broadcast();

  Stream<List<NotificationItemModel>> get inboxStream => _inboxController.stream;

  void addIncomingNotification(RemoteMessage message) {
    final item = NotificationItemModel.fromRemoteMessage(message);
    final existingIndex = _localInbox.indexWhere((element) => element.id == item.id);
    if (existingIndex >= 0) {
      _localInbox[existingIndex] = item;
    } else {
      _localInbox.insert(0, item);
    }
    _notifyListeners();
  }

  void _notifyListeners() {
    final merged = _buildMergedInbox(_localInbox, const <NotificationItemModel>[]);
    if (!_inboxController.isClosed) {
      _inboxController.add(merged);
    }
  }

  Future<List<NotificationItemModel>> fetchInbox() async {
    try {
      final response = await _apiClient.get<dynamic>(
        ApiEndpoints.pushNotificationsInbox,
      );

      final list = ResponseParser.extractList(
        response.data,
        const ['notifications', 'items', 'results', 'data'],
      );

      final remoteItems = list
          .whereType<Map<String, dynamic>>()
          .map(NotificationItemModel.fromJson)
          .toList();

      final merged = _buildMergedInbox(_localInbox, remoteItems);
      return merged;
    } catch (_) {
      return _buildMergedInbox(_localInbox, const <NotificationItemModel>[]);
    }
  }

  List<NotificationItemModel> _buildMergedInbox(
    List<NotificationItemModel> local,
    List<NotificationItemModel> remote,
  ) {
    final all = <NotificationItemModel>[...local, ...remote];
    final byId = <String, NotificationItemModel>{};

    for (final item in all) {
      final key = item.id.trim();
      if (key.isEmpty) continue;
      final existing = byId[key];
      if (existing == null ||
          (item.createdAt != null &&
              (existing.createdAt == null || item.createdAt!.isAfter(existing.createdAt!)))) {
        byId[key] = item;
      }
    }

    final merged = byId.values.toList();
    merged.sort((a, b) {
      final aTime = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bTime = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bTime.compareTo(aTime);
    });

    return merged;
  }

  Future<bool> markAllRead() async {
    try {
      final response = await _apiClient.patch<dynamic>(
        ApiEndpoints.pushNotificationsReadAll,
      );
      return response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300;
    } catch (_) {
      return false;
    }
  }

  Future<bool> markRead(String id) async {
    try {
      final response = await _apiClient.patch<dynamic>(
        ApiEndpoints.pushNotificationRead(id),
      );
      return response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300;
    } catch (_) {
      return false;
    }
  }

  Future<bool> deleteNotification(String id) async {
    try {
      final response = await _apiClient.delete<dynamic>(
        ApiEndpoints.pushNotificationDelete(id),
      );
      return response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300;
    } catch (_) {
      return false;
    }
  }
}

