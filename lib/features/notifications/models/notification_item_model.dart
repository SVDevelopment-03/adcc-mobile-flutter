import 'dart:convert';

import 'package:adcc/core/utils/response_parser.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationItemModel {
  final String id;
  final String title;
  final String body;
  final bool isRead;
  final DateTime? createdAt;
  final String? type;
  final String? imageUrl;
  final Map<String, dynamic>? data;

  const NotificationItemModel({
    required this.id,
    required this.title,
    required this.body,
    required this.isRead,
    required this.createdAt,
    this.type,
    this.imageUrl,
    this.data,
  });

  /// Action buttons attached from the dashboard (`data.actions`), as
  /// `{title, action}` pairs. The backend stores them as a JSON string.
  List<Map<String, String>> get actions {
    dynamic raw = data?['actions'];
    if (raw is String && raw.trim().isNotEmpty) {
      try {
        raw = jsonDecode(raw);
      } catch (_) {
        return const [];
      }
    }
    if (raw is! List) return const [];

    final result = <Map<String, String>>[];
    for (final entry in raw) {
      if (entry is! Map) continue;
      final title =
          ResponseParser.asString(entry['title'], fallback: '').trim();
      final action =
          ResponseParser.asString(entry['action'], fallback: '').trim();
      if (title.isEmpty || action.isEmpty) continue;
      result.add({'title': title, 'action': action});
    }
    return result;
  }

  factory NotificationItemModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map
        ? Map<String, dynamic>.from(json['data'] as Map)
        : null;

    return NotificationItemModel(
      id: ResponseParser.asString(json['_id'] ?? json['id']),
      title: ResponseParser.asString(json['title'] ?? json['heading'],
          fallback: 'Notification'),
      body: ResponseParser.asString(
          json['body'] ?? json['message'] ?? json['description'],
          fallback: ''),
      isRead: ResponseParser.asBool(json['isRead'] ?? json['read']),
      createdAt: DateTime.tryParse(ResponseParser.asString(
          json['createdAt'] ?? json['date'],
          fallback: '')),
      type: ResponseParser.asString(json['type'], fallback: ''),
      // The backend keeps the image inside `data`, not at the top level.
      imageUrl: ResponseParser.asString(
          json['image'] ??
              json['imageUrl'] ??
              data?['image'] ??
              data?['imageUrl'],
          fallback: ''),
      data: data,
    );
  }

  factory NotificationItemModel.fromRemoteMessage(RemoteMessage message) {
    final rawData = message.data;
    final dataMap = rawData.isNotEmpty
        ? Map<String, dynamic>.from(rawData)
        : const <String, dynamic>{};

    final title = message.notification?.title ??
        ResponseParser.asString(dataMap['title'] ?? dataMap['heading'],
            fallback: 'Notification');
    final body = message.notification?.body ??
        ResponseParser.asString(
            dataMap['body'] ?? dataMap['message'] ?? dataMap['description'],
            fallback: '');
    final type = ResponseParser.asString(dataMap['type'], fallback: '');
    // Try to extract image URL from notification payload or data
    String? imageUrl;
    try {
      imageUrl = message.notification?.android?.imageUrl?.toString() ??
          message.notification?.apple?.imageUrl?.toString();
    } catch (_) {
      imageUrl = null;
    }

    if ((imageUrl == null || imageUrl.isEmpty) && dataMap.isNotEmpty) {
      imageUrl = ResponseParser.asString(
          dataMap['image'] ?? dataMap['imageUrl'],
          fallback: '');
      if (imageUrl.isEmpty) imageUrl = null;
    }

    return NotificationItemModel(
      id: message.messageId ?? 'local-${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      body: body,
      isRead: false,
      createdAt: DateTime.now(),
      type: type.isEmpty ? null : type,
      imageUrl: imageUrl,
      data: dataMap.isEmpty ? null : dataMap,
    );
  }
}
