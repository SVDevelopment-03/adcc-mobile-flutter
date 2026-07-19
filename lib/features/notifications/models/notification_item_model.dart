import 'package:adcc/core/utils/response_parser.dart';

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
      title: ResponseParser.asString(json['title'] ?? json['heading'], fallback: 'Notification'),
      body: ResponseParser.asString(json['body'] ?? json['message'] ?? json['description'], fallback: ''),
      isRead: ResponseParser.asBool(json['isRead'] ?? json['read']),
      createdAt: DateTime.tryParse(ResponseParser.asString(json['createdAt'] ?? json['date'], fallback: '')),
      type: ResponseParser.asString(json['type'], fallback: ''),
      data: json['data'] is Map<String, dynamic> ? json['data'] as Map<String, dynamic> : null,
    );
  }
}
