import 'package:adcc/core/utils/response_parser.dart';

class FeedPostModel {
  final String id;
  final String title;
  final String description;
  final String image;
  final String status;
  final bool reported;
  final String authorName;
  final String authorAvatar;
  final int likesCount;
  final int commentsCount;
  final bool likedByMe;
  final bool isAuthor;
  final DateTime? createdAt;
  final List<FeedCommentModel> comments;

  const FeedPostModel({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.status,
    required this.reported,
    required this.authorName,
    required this.authorAvatar,
    required this.likesCount,
    required this.commentsCount,
    required this.likedByMe,
    required this.isAuthor,
    required this.createdAt,
    required this.comments,
  });

  factory FeedPostModel.fromJson(
    Map<String, dynamic> json, {
    String? currentUserId,
    String? currentUserName,
    bool preferCurrentUserWhenAuthorMissing = false,
  }) {
    final authorData = json['createdBy'] ??
        json['created_by'] ??
        json['createdById'] ??
        json['user'] ??
        json['userId'] ??
        json['author'] ??
        json['authorId'] ??
        json['creator'] ??
        json['owner'] ??
        json['member'];

    String name = '';
    String avatar = '';
    String authorId = '';

    if (authorData is Map<String, dynamic>) {
      authorId = _extractAuthorId(authorData);
      name = _extractAuthorName(authorData);
      avatar = _extractAuthorAvatar(authorData);
    } else if (authorData is String && authorData.isNotEmpty) {
      authorId = authorData.trim();
      if (!_looksLikeId(authorData)) {
        name = authorData;
      }
    }

    if (authorId.isEmpty) {
      authorId = ResponseParser.asString(
        json['createdById'] ??
            json['created_by'] ??
            json['authorId'] ??
            json['userId'] ??
            json['memberId'],
      );
    }

    if (name.isEmpty) {
      name = ResponseParser.asString(
        json['authorName'] ??
            json['createdByName'] ??
            json['userName'] ??
            json['username'] ??
            json['fullName'] ??
            json['name'] ??
            json['riderName'] ??
            json['memberName'],
      );
    }
    if (avatar.isEmpty) {
      avatar = ResponseParser.asString(
        json['authorAvatar'] ??
            json['userImage'] ??
            json['profileImage'] ??
            json['avatar'],
      );
    }

    final currentId = currentUserId?.trim();
    final currentName = currentUserName?.trim();
    if (name.isEmpty &&
        currentName != null &&
        currentName.isNotEmpty &&
        ((currentId != null && currentId.isNotEmpty && authorId == currentId) ||
            (preferCurrentUserWhenAuthorMissing && authorId.isEmpty))) {
      name = currentName;
    }

    if (name.isEmpty) name = 'ADCC Member';

    final isAuthor =
        (currentId != null && currentId.isNotEmpty && authorId == currentId) ||
            ResponseParser.asBool(json['isAuthor'] ?? json['isMine']);

    final commentsJson = json['comments'];
    final likesJson = json['likes'];

    return FeedPostModel(
      id: ResponseParser.asString(json['_id'] ?? json['id']),
        // Prefer Arabic fields when present (server may provide `titleAr`/`descriptionAr`).
        title: ResponseParser.asString(json['titleAr'] ?? json['title'], fallback: 'Feed Post'),
        description: ResponseParser.asString(
          json['descriptionAr'] ??
            json['description'] ??
            json['body'] ??
            json['content'] ??
            json['text'],
          fallback: ''),
      image: ResponseParser.asString(json['image'] ??
          json['mainImage'] ??
          json['mediaUrl'] ??
          json['postImage']),
      status: ResponseParser.asString(json['status'], fallback: 'pending'),
      reported: ResponseParser.asBool(json['reported']),
      authorName: name,
      authorAvatar: avatar,
      likesCount: ResponseParser.asInt(
        json['likesCount'] ?? json['likeCount'] ?? json['likes'],
        fallback: likesJson is List ? likesJson.length : 0,
      ),
      commentsCount: ResponseParser.asInt(
        json['commentsCount'] ?? json['commentCount'] ?? json['comments'],
        fallback: commentsJson is List ? commentsJson.length : 0,
      ),
      likedByMe: ResponseParser.asBool(json['likedByMe']),
      isAuthor: isAuthor,
      createdAt: DateTime.tryParse(ResponseParser.asString(json['createdAt'])),
      comments: commentsJson is List
          ? commentsJson
              .whereType<Map<String, dynamic>>()
              .map((c) {
                // Prefer translated comment text when available
                final map = Map<String, dynamic>.from(c);
                if ((map['textAr'] ?? '').toString().trim().isNotEmpty) {
                  map['text'] = map['textAr'];
                }
                return FeedCommentModel.fromJson(map);
              })
              .toList()
          : const [],
    );
  }

  static String _extractAuthorName(Map<String, dynamic> source) {
    final direct = ResponseParser.asString(
      source['fullName'] ??
          source['name'] ??
          source['userName'] ??
          source['username'] ??
          source['display_name'] ??
          source['displayName'] ??
          source['authorName'] ??
          source['createdByName'],
    );
    if (direct.isNotEmpty) return direct;

    final first = ResponseParser.asString(source['firstName']);
    final last = ResponseParser.asString(source['lastName']);
    final combined = '$first $last'.trim();
    if (combined.isNotEmpty) return combined;

    for (final key in const [
      'user',
      'userId',
      'profile',
      'member',
      'memberId',
      'owner',
      'author',
      'creator',
    ]) {
      final nested = source[key];
      if (nested is Map<String, dynamic>) {
        final nestedName = _extractAuthorName(nested);
        if (nestedName.isNotEmpty) return nestedName;
      }
    }

    return '';
  }

  static String _extractAuthorAvatar(Map<String, dynamic> source) {
    final direct = ResponseParser.asString(
      source['profileImage'] ??
          source['avatar'] ??
          source['image'] ??
          source['photoUrl'] ??
          source['profile_pic'] ??
          source['profilePic'] ??
          source['authorAvatar'] ??
          source['userImage'],
    );
    if (direct.isNotEmpty) return direct;

    for (final key in const [
      'user',
      'userId',
      'profile',
      'member',
      'memberId',
      'owner',
      'author',
      'creator',
    ]) {
      final nested = source[key];
      if (nested is Map<String, dynamic>) {
        final nestedAvatar = _extractAuthorAvatar(nested);
        if (nestedAvatar.isNotEmpty) return nestedAvatar;
      }
    }

    return '';
  }

  static String _extractAuthorId(Map<String, dynamic> source) {
    final direct = ResponseParser.asString(
      source['_id'] ??
          source['id'] ??
          source['userId'] ??
          source['memberId'] ??
          source['authorId'] ??
          source['createdById'],
    );
    if (direct.isNotEmpty && _looksLikeId(direct)) return direct;

    for (final key in const [
      'user',
      'userId',
      'profile',
      'member',
      'memberId',
      'owner',
      'author',
      'creator',
    ]) {
      final nested = source[key];
      if (nested is String && nested.trim().isNotEmpty) {
        return nested.trim();
      }
      if (nested is Map<String, dynamic>) {
        final nestedId = _extractAuthorId(nested);
        if (nestedId.isNotEmpty) return nestedId;
      }
    }

    return direct;
  }

  static bool _looksLikeId(String value) {
    final normalized = value.trim();
    if (normalized.contains(' ')) return false;
    return normalized.length >= 10;
  }

  FeedPostModel copyWith({
    int? likesCount,
    bool? likedByMe,
    bool? isAuthor,
  }) {
    return FeedPostModel(
      id: id,
      title: title,
      description: description,
      image: image,
      status: status,
      reported: reported,
      authorName: authorName,
      authorAvatar: authorAvatar,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount,
      likedByMe: likedByMe ?? this.likedByMe,
      isAuthor: isAuthor ?? this.isAuthor,
      createdAt: createdAt,
      comments: comments,
    );
  }
}

class FeedCommentModel {
  final String id;
  final String text;
  final String userId;
  final String authorName;
  final String authorAvatar;
  final DateTime? createdAt;
  final bool canDeleteByMe;

  const FeedCommentModel({
    required this.id,
    required this.text,
    required this.userId,
    required this.authorName,
    required this.authorAvatar,
    required this.createdAt,
    required this.canDeleteByMe,
  });

  factory FeedCommentModel.fromJson(Map<String, dynamic> json) {
    final user =
        json['user'] ?? json['createdBy'] ?? json['author'] ?? json['creator'];
    final userMap = user is Map<String, dynamic> ? user : null;

    String name = '';
    String avatar = '';

    if (userMap != null) {
      name = ResponseParser.asString(userMap['fullName'] ??
          userMap['name'] ??
          userMap['userName'] ??
          userMap['username'] ??
          userMap['display_name']);
      avatar = ResponseParser.asString(
          userMap['profileImage'] ?? userMap['avatar'] ?? userMap['image']);
    }

    if (name.isEmpty) {
      name = ResponseParser.asString(
          json['authorName'] ?? json['userName'] ?? json['name'],
          fallback: 'Member');
    }
    if (avatar.isEmpty) {
      avatar = ResponseParser.asString(
          json['authorAvatar'] ?? json['userImage'] ?? json['avatar']);
    }

    return FeedCommentModel(
      id: ResponseParser.asString(json['_id'] ?? json['id']),
      text: ResponseParser.asString(
          json['text'] ?? json['comment'] ?? json['message']),
      userId:
          ResponseParser.asString(userMap?['_id'] ?? userMap?['id'] ?? user),
      authorName: name,
      authorAvatar: avatar,
      createdAt: DateTime.tryParse(ResponseParser.asString(json['createdAt'])),
      canDeleteByMe: ResponseParser.asBool(json['canDeleteByMe']),
    );
  }
}
