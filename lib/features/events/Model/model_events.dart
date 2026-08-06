import 'package:adcc/core/utils/response_parser.dart';
import 'package:intl/intl.dart';

/// Event model (Fully Synced With Backend)
class Event {
  final String id;
  final String title;
  final String? description;

  final String? mainImage;

  final String? eventDate;
  final String? eventTime;
  final String? address;

  final int? maxParticipants;
  final int? currentParticipants;

  final int? minAge;
  final int? maxAge;

  final String? youtubeLink;
  final String? status;

  final Map<String, dynamic>? createdBy;

  final bool? allowCancellation;
  final List<String>? amenities;
  final String? category;
  final String? city;
  final String? communityId;
  final String? difficulty;
  final int? distance;
  final List<Map<String, dynamic>>? eligibility;
  final List<Map<String, dynamic>>? requiredGear;
  final List<String>? galleryImages;
  final bool? isFeatured;
  final List<Map<String, dynamic>>? schedule;
  final String? slug;
  final String? trackId;

  final Map<String, dynamic>? additionalData;

  final String? derivedCategory;

  Event({
    required this.id,
    required this.title,
    this.description,
    this.mainImage,
    this.eventDate,
    this.eventTime,
    this.address,
    this.maxParticipants,
    this.currentParticipants,
    this.minAge,
    this.maxAge,
    this.youtubeLink,
    this.status,
    this.createdBy,
    this.allowCancellation,
    this.amenities,
    this.category,
    this.city,
    this.communityId,
    this.difficulty,
    this.distance,
    this.eligibility,
    this.requiredGear,
    this.galleryImages,
    this.isFeatured,
    this.schedule,
    this.slug,
    this.trackId,
    this.additionalData,
    this.derivedCategory,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    final title = json['title']?.toString() ?? '';

    return Event(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      title: title,
      description: json['description']?.toString(),
      mainImage: json['mainImage']?.toString(),
      eventDate: json['eventDate']?.toString(),
      eventTime: json['eventTime']?.toString(),
      address: json['address']?.toString(),
      maxParticipants: json['maxParticipants'] is int
          ? json['maxParticipants']
          : int.tryParse(json['maxParticipants']?.toString() ?? ''),
      currentParticipants: json['currentParticipants'] is int
          ? json['currentParticipants']
          : int.tryParse(json['currentParticipants']?.toString() ?? ''),
      minAge: json['minAge'] is int
          ? json['minAge']
          : int.tryParse(json['minAge']?.toString() ?? ''),
      maxAge: json['maxAge'] is int
          ? json['maxAge']
          : int.tryParse(json['maxAge']?.toString() ?? ''),
      youtubeLink: json['youtubeLink']?.toString(),
      status: json['status']?.toString(),
      createdBy:
          json['createdBy'] is Map<String, dynamic> ? json['createdBy'] : null,
      allowCancellation: json['allowCancellation'] as bool?,
      amenities:
          (json['amenities'] as List?)?.map((e) => e.toString()).toList(),
      category: (() {
        final val = json['category'];
        if (val == null) return null;
        if (val is Map<String, dynamic>) {
          return val['name']?.toString() ??
              val['title']?.toString() ??
              val['label']?.toString();
        }
        return val.toString();
      })(),
      city: json['city']?.toString(),
      communityId: json['communityId']?.toString(),
      difficulty: json['difficulty']?.toString(),
      distance: json['distance'] is int
          ? json['distance']
          : int.tryParse(json['distance']?.toString() ?? ''),
      eligibility: (json['eligibility'] as List?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      requiredGear: (() {
        final raw = json['requiredGear'] ??
            json['required_gear'] ??
            json['requiredGearItems'] ??
            json['required_gear_items'];

        if (raw is List) {
          return raw.map((item) {
            if (item is Map<String, dynamic>) return item;
            if (item is Map) {
              return Map<String, dynamic>.from(item);
            }
            return <String, dynamic>{'label': item.toString()};
          }).toList();
        }

        return null;
      })(),
      galleryImages:
          (json['galleryImages'] as List?)?.map((e) => e.toString()).toList(),
      isFeatured: json['isFeatured'] as bool?,
      schedule: (json['schedule'] as List?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      slug: json['slug']?.toString(),
      trackId: json['trackId']?.toString(),
      additionalData: json,
      derivedCategory: (() {
        // Prefer explicit derivedCategory if provided, then readable category name, else fallback derive from title
        final provided = json['derivedCategory'] ??
            json['derived_category'] ??
            json['derived'];
        if (provided != null) return provided.toString();

        final cat = json['category'];
        if (cat is Map<String, dynamic>) {
          final name = cat['name']?.toString() ??
              cat['title']?.toString() ??
              cat['label']?.toString();
          if (name != null && name.isNotEmpty) return name;
        }
        if (cat is String && cat.isNotEmpty) return cat;

        return _deriveCategoryFromTitle(title);
      })(),
    );
  }

  static String _deriveCategoryFromTitle(String title) {
    final t = title.toLowerCase();

    if (t.contains('family') || t.contains('kids')) return 'Family & Kids';
    if (t.contains('shop')) return 'Shop';
    if (t.contains('community') || t.contains('ride')) return 'Community Ride';

    return 'Community Ride';
  }

  int get rewardPoints {
    final rawRewards = additionalData?['rewards'];
    if (rawRewards is Map<String, dynamic>) {
      return ResponseParser.asInt(rawRewards['points']);
    }

    if (rawRewards is Map) {
      return ResponseParser.asInt(rawRewards['points']);
    }

    return ResponseParser.asInt(
        additionalData?['rewardPoints'] ?? additionalData?['points']);
  }

  String get rewardBadgeName {
    final rawRewards = additionalData?['rewards'];
    if (rawRewards is Map<String, dynamic>) {
      return ResponseParser.asString(rawRewards['badgeName']);
    }

    if (rawRewards is Map) {
      return ResponseParser.asString(rawRewards['badgeName']);
    }

    return ResponseParser.asString(additionalData?['badgeName']);
  }

  String? get formattedDate {
    if (eventDate == null) return null;

    final raw = eventDate!.trim();
    if (raw.isEmpty) return null;

    try {
      final dateTime = DateTime.parse(raw);
      return DateFormat('d MMM yyyy').format(dateTime);
    } catch (_) {
      final cleaned = raw
          .replaceAll(RegExp(r'\s*\.\s*'), ' ')
          .replaceAll(RegExp(r'\s+'), ' ')
          .trim();

      final match = RegExp(r'(\d{1,2}\s+[A-Za-z]+\s+(?:\d{4}|\d{5,}))')
          .firstMatch(cleaned);
      if (match != null) {
        var datePart = match.group(0)!.trim();
        final yearMatch = RegExp(r'(\d{5,})$').firstMatch(datePart);
        if (yearMatch != null) {
          final year = yearMatch.group(0)!;
          datePart =
              datePart.replaceFirst(year, year.substring(year.length - 4));
        }
        return datePart;
      }

      return cleaned;
    }
  }

  String? get formattedTime {
    if (eventTime == null) return null;

    final raw = eventTime!.trim();
    if (raw.isEmpty) return null;

    var cleaned = raw.replaceAll(RegExp(r'[^\dA-Za-z:\sAPMapm]'), ' ');
    cleaned = cleaned.replaceAll(RegExp(r'\s+'), ' ').trim();

    final match = RegExp(r'(\d{1,2}:\d{1,4})').firstMatch(cleaned);
    if (match != null) {
      final rawTime = match.group(0)!;
      final parts = rawTime.split(':');
      if (parts.length == 2) {
        final hours = int.tryParse(parts[0]) ?? 0;
        var minutes = parts[1];
        if (minutes.length > 2) {
          minutes = minutes.substring(0, 2);
        }
        if (minutes.length == 1) {
          minutes = '${minutes}0';
        }
        final hourString = hours.toString().padLeft(2, '0');
        final minuteValue = int.tryParse(minutes) ?? 0;
        final minuteString = minuteValue.toString().padLeft(2, '0');
        return '$hourString:$minuteString';
      }
    }

    return cleaned;
  }

  String get participantsString {
    if (currentParticipants != null && maxParticipants != null) {
      return '$currentParticipants/$maxParticipants';
    } else if (currentParticipants != null) {
      return '$currentParticipants';
    } else if (maxParticipants != null) {
      return '0/$maxParticipants';
    }
    return '0';
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'mainImage': mainImage,
      'eventDate': eventDate,
      'eventTime': eventTime,
      'address': address,
      'maxParticipants': maxParticipants,
      'currentParticipants': currentParticipants,
      'minAge': minAge,
      'maxAge': maxAge,
      'youtubeLink': youtubeLink,
      'status': status,
      'createdBy': createdBy,
      'allowCancellation': allowCancellation,
      'amenities': amenities,
      'category': category,
      'city': city,
      'communityId': communityId,
      'difficulty': difficulty,
      'distance': distance,
      'eligibility': eligibility,
      'requiredGear': requiredGear,
      'galleryImages': galleryImages,
      'isFeatured': isFeatured,
      'schedule': schedule,
      'slug': slug,
      'trackId': trackId,
      'derivedCategory': derivedCategory,
    };
  }
}
