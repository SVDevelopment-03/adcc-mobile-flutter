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

  factory NotificationItemModel.fromJson(Map<String, dynamic> json) {
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
      imageUrl: ResponseParser.asString(json['image'] ?? json['imageUrl'], fallback: ''),
      data: json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : null,
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
      imageUrl = ResponseParser.asString(dataMap['image'] ?? dataMap['imageUrl'], fallback: '');
      if (imageUrl != null && imageUrl.isEmpty) imageUrl = null;
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
