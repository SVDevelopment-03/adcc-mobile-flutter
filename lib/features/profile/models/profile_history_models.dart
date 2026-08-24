import 'package:adcc/core/utils/response_parser.dart';

class ProfilePerformanceInsights {
  final String completionRate;
  final String averageDistance;
  final String bestCategory;

  const ProfilePerformanceInsights({
    required this.completionRate,
    required this.averageDistance,
    required this.bestCategory,
  });

  factory ProfilePerformanceInsights.fromApi(Map<String, dynamic> json) {
    return ProfilePerformanceInsights(
      completionRate: ResponseParser.asString(
        json['completionRate'] ?? json['averageCompletionRate'],
        fallback: '0%',
      ),
      averageDistance: ResponseParser.asString(
        json['averageDistance'] ?? json['avgDistance'] ?? json['distance'],
        fallback: '0 km',
      ),
      bestCategory: ResponseParser.asString(
        json['bestCategory'] ?? json['category'],
        fallback: '—',
      ),
    );
  }

  static const fallback = ProfilePerformanceInsights(
    completionRate: '0%',
    averageDistance: '0 km',
    bestCategory: '—',
  );
}

class ProfileEventHistoryItem {
  final String id;
  final String title;
  final String subtitle;
  final String date;
  final String status;
  final String distance;
  final String time;
  final String rank;
  final String image;
  final String badgeName;

  const ProfileEventHistoryItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.status,
    required this.distance,
    required this.time,
    required this.rank,
    required this.image,
    required this.badgeName,
  });

  bool get hasMeaningfulTitle {
    final normalized = title.trim();
    if (normalized.isEmpty) return false;
    final lower = normalized.toLowerCase();
    return ![
      'no event',
      'no upcoming events',
      'لا توجد أحداث',
      'لا توجد فعاليات قادمة',
    ].contains(lower);
  }

  factory ProfileEventHistoryItem.fromApi(
    Map<String, dynamic> json, {
    String locale = 'en',
  }) {
    final event = json['event'] is Map<String, dynamic>
        ? json['event'] as Map<String, dynamic>
        : json;

    final isArabic = locale.toLowerCase().startsWith('ar');
    final localizedTitle = isArabic
        ? ResponseParser.asString(
            event['titleAr'] ??
                json['titleAr'] ??
                event['title'] ??
                json['title'],
            fallback: '',
          )
        : ResponseParser.asString(
            event['title'] ?? json['title'],
            fallback: '',
          );
    final localizedCategory = isArabic
        ? ResponseParser.asString(
            event['categoryAr'] ??
                json['categoryAr'] ??
                event['category'] ??
                json['subtitle'] ??
                json['category'] ??
                json['type'],
            fallback: '',
          )
        : ResponseParser.asString(
            event['category'] ??
                json['subtitle'] ??
                json['category'] ??
                json['type'],
            fallback: '',
          );

    final completedAt = ResponseParser.asString(
      json['completedAt'] ??
          json['updatedAt'] ??
          event['eventDate'] ??
          json['date'],
    );

    final distanceValue = ResponseParser.asString(
      json['distance'] ?? event['distance'] ?? json['distanceCovered'],
      fallback: '0',
    );

    final distanceLabel =
        distanceValue.contains('km') ? distanceValue : '$distanceValue km';

    return ProfileEventHistoryItem(
      id: ResponseParser.asString(
          event['_id'] ?? event['id'] ?? json['_id'] ?? json['id']),
      title: localizedTitle,
      subtitle: localizedCategory,
      date: completedAt.isEmpty ? '—' : completedAt,
      status: 'Completed',
      distance: distanceLabel,
      time: ResponseParser.asString(
        json['time'] ?? json['duration'],
        fallback: '—',
      ),
      rank: ResponseParser.asString(
        json['rank'] ?? json['position'] ?? json['result'],
        fallback: '—',
      ),
      image: ResponseParser.asString(
        event['mainImage'] ??
            event['eventImage'] ??
            json['image'] ??
            json['mainImage'] ??
            json['eventImage'],
        fallback: 'assets/images/no-img.jpg',
      ),
      badgeName: ResponseParser.asString(event['badgeName']),
    );
  }
}

class ProfileUpcomingEventItem {
  final String id;
  final String title;
  final String date;
  final String time;
  final String distance;
  final String image;
  final String trackName;

  const ProfileUpcomingEventItem({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.distance,
    required this.image,
    this.trackName = '',
  });

  bool get hasMeaningfulTitle {
    final normalized = title.trim();
    if (normalized.isEmpty) return false;
    final lower = normalized.toLowerCase();
    return ![
      'no event',
      'no events',
      'no upcoming events',
      'no upcoming event',
      'no joined events yet',
      'لا توجد أحداث',
      'لا توجد فعاليات',
      'لا توجد فعاليات قادمة',
      'لا توجد فعالية قادمة',
      'لا توجد فعاليات منضم إليها بعد',
    ].contains(lower);
  }

  factory ProfileUpcomingEventItem.fromApi(
    Map<String, dynamic> json, {
    String locale = 'en',
  }) {
    final event = json['event'] is Map<String, dynamic>
        ? json['event'] as Map<String, dynamic>
        : json;
    final isArabic = locale.toLowerCase().startsWith('ar');

    return ProfileUpcomingEventItem(
      id: ResponseParser.asString(
          event['_id'] ?? event['id'] ?? json['_id'] ?? json['id']),
      title: isArabic
          ? ResponseParser.asString(
              event['titleAr'] ??
                  json['titleAr'] ??
                  event['title'] ??
                  json['title'],
              fallback: '',
            )
          : ResponseParser.asString(
              event['title'] ?? json['title'],
              fallback: '',
            ),
      date: ResponseParser.asString(
        event['eventDate'] ??
            json['date'] ??
            json['eventDate'] ??
            json['startsAt'],
        fallback: '—',
      ),
      time: ResponseParser.asString(
        event['eventTime'] ??
            event['time'] ??
            json['time'] ??
            json['startsAtTime'],
        fallback: '—',
      ),
      distance: ResponseParser.asString(
        event['distance'] ??
            json['distance'] ??
            json['distanceKm'] ??
            json['routeDistance'],
        fallback: '—',
      ),
      image: ResponseParser.asString(
        event['mainImage'] ??
            event['eventImage'] ??
            json['image'] ??
            json['mainImage'] ??
            json['eventImage'],
        fallback: 'assets/images/no-img.jpg',
      ),
    );
  }
}

class BadgeIconItem {
  final String key;
  final String emoji;
  final String label;

  const BadgeIconItem({
    required this.key,
    required this.emoji,
    required this.label,
  });

  factory BadgeIconItem.fromApi(Map<String, dynamic> json) {
    return BadgeIconItem(
      key: ResponseParser.asString(json['key']),
      emoji: ResponseParser.asString(json['emoji']),
      label: ResponseParser.asString(json['label']),
    );
  }
}

class ProfileBadgeItem {
  final String id;
  final String name;
  final String imageUrl;
  final String iconKey;
  final String iconEmoji;
  final bool earned;
  final DateTime? earnedAt;

  const ProfileBadgeItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.iconKey,
    required this.iconEmoji,
    required this.earned,
    required this.earnedAt,
  });

  factory ProfileBadgeItem.fromBadgeApi(
    Map<String, dynamic> json, {
    bool earned = false,
    DateTime? earnedAt,
    String iconEmoji = '',
  }) {
    return ProfileBadgeItem(
      id: ResponseParser.asString(json['_id'] ?? json['id']),
      name: ResponseParser.asString(json['name'], fallback: 'Badge'),
      imageUrl: ResponseParser.asString(
        json['image'] ?? json['badgeImage'],
      ),
      iconKey: ResponseParser.asString(json['icon']),
      iconEmoji: iconEmoji,
      earned: earned,
      earnedAt: earnedAt,
    );
  }
}
