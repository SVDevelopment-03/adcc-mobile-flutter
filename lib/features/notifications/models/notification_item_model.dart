import 'package:adcc/core/utils/response_parser.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationItemModel {
  final String id;
  final String title;
  final String body;
  final bool isRead;
  final DateTime? createdAt;
  final String? type;
  final Map<String, dynamic>? data;

  const NotificationItemModel({
    required this.id,
    required this.title,
    required this.body,
    required this.isRead,
    required this.createdAt,
    this.type,
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

    return NotificationItemModel(
      id: message.messageId ?? 'local-${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      body: body,
      isRead: false,
      createdAt: DateTime.now(),
      type: type.isEmpty ? null : type,
      data: dataMap.isEmpty ? null : dataMap,
    );
  }
}
