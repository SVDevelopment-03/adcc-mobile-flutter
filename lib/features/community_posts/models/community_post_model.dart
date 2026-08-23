import 'package:adcc/core/utils/response_parser.dart';

class CommunityPostModel {
  final String id;
  final String title;
  final String description;
  final String image;
  final String status;
  final bool reported;
  final String? createdByName;

  const CommunityPostModel({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.status,
    required this.reported,
    this.createdByName,
  });

  factory CommunityPostModel.fromJson(Map<String, dynamic> json) {
    final createdBy = json['createdBy'];
    final createdByMap = createdBy is Map<String, dynamic>
        ? createdBy
        : (createdBy is Map ? Map<String, dynamic>.from(createdBy) : <String, dynamic>{});

    return CommunityPostModel(
      id: ResponseParser.asString(json['_id'] ?? json['id']),
      title: ResponseParser.asString(json['title'], fallback: 'Post'),
      description: ResponseParser.asString(
        json['caption'] ?? json['description'] ?? json['body'],
        fallback: '',
      ),
      image: ResponseParser.asString(json['image'] ?? json['mainImage'],
          fallback: 'assets/images/no-img.jpg'),
      status: ResponseParser.asString(
        json['postType'] ?? json['status'],
        fallback: 'pending',
      ),
      reported: ResponseParser.asBool(json['reported']),
      createdByName: ResponseParser.asString(
        createdByMap['fullName'] ?? createdByMap['name'] ?? json['createdByName'],
      ),
    );
  }
}
