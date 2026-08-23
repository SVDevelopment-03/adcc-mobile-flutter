import 'package:adcc/core/services/api_response.dart';
import 'package:adcc/core/utils/currency_formatter.dart';
import 'package:adcc/core/utils/response_parser.dart';

class HomeEventModel {
  final String id;
  final String image;
  final String title;
  final String date;
  final String distance;
  final String type;

  const HomeEventModel({
    required this.id,
    required this.image,
    required this.title,
    required this.date,
    required this.distance,
    required this.type,
  });

  factory HomeEventModel.fromJson(Map<String, dynamic> json) {
    final rawDistance = json['distance'];
    final distanceText = rawDistance == null
        ? ApiResponse.localized((l) => l.not_available, 'N/A')
        : rawDistance is num
            ? '${rawDistance.toString()} Km'
            : rawDistance.toString();

    return HomeEventModel(
      id: ResponseParser.asString(json['_id'] ?? json['id']),
      image: ResponseParser.asString(
        json['mainImage'] ?? json['eventImage'] ?? json['image'],
        fallback: 'assets/images/no-img.jpg',
      ),
      title: ResponseParser.asString(json['title'],
          fallback: ApiResponse.localized((l) => l.upcomingEvents, 'Upcoming Event')),
      date: ResponseParser.asString(json['eventDate'] ?? json['date'],
          fallback: ApiResponse.localized((l) => l.event_badge_tbd, 'TBD')),
      distance: distanceText,
      type: ResponseParser.asString(json['category'] ?? json['type'],
          fallback: ApiResponse.localized((l) => l.categorySocial, 'Social')),
    );
  }
}

class HomeCommunityModel {
  final String id;
  final String title;
  final String image;
  final int members;

  const HomeCommunityModel({
    required this.id,
    required this.title,
    required this.image,
    required this.members,
  });

  factory HomeCommunityModel.fromJson(Map<String, dynamic> json) {
    return HomeCommunityModel(
      id: ResponseParser.asString(json['_id'] ?? json['id']),
      title: ResponseParser.asString(json['title'] ?? json['name'],
          fallback: ApiResponse.localized((l) => l.community, 'Community')),
      image: ResponseParser.asString(
        json['image'] ?? json['mainImage'],
        fallback: 'assets/images/family_ride.png',
      ),
      members: ResponseParser.asInt(
        json['membersCount'] ??
            json['members'] ??
            json['communityMembersCount'],
      ),
    );
  }
}

class HomeFeedModel {
  final HomeEventModel? featuredEvent;
  final List<HomeEventModel> upcomingEvents;
  final List<HomeCommunityModel> popularCommunities;
  final List<HomeBannerModel> promoBanners;
  final List<HomeTrackModel> nearbyTracks;
  final List<HomeStoreItemModel> recentItems;
  final List<HomeFeedPostModel> communityUpdates;
  final List<HomeRideInfoModel> rideInfos;
  final String rideInfoSectionTitle;
  final String userCity;

  const HomeFeedModel({
    required this.featuredEvent,
    required this.upcomingEvents,
    required this.popularCommunities,
    required this.promoBanners,
    required this.nearbyTracks,
    required this.recentItems,
    required this.communityUpdates,
    required this.rideInfos,
    required this.rideInfoSectionTitle,
    this.userCity = '',
  });
}

class HomeBannerModel {
  final String image;
  final String title;
  final String subtitle;
  final String highlight;
  final String buttonText;
  final String targetScreen;
  final String updatedAt;

  const HomeBannerModel({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.highlight,
    required this.buttonText,
    required this.targetScreen,
    required this.updatedAt,
  });

  factory HomeBannerModel.fromJson(Map<String, dynamic> json) {
    final image = ResponseParser.asString(
      json['image'] ?? json['mainImage'] ?? json['bannerImage'],
      fallback: 'assets/images/no-img.jpg',
    );
    final updatedAt = ResponseParser.asString(
        json['updatedAt'] ?? json['modifiedAt'] ?? json['updated_at']);

    final targetScreen = ResponseParser.asString(
      json['targetScreen'] ?? json['route'] ?? json['target'] ?? json['screen'],
      fallback: 'home',
    ).replaceAll('-', '_').replaceAll(RegExp(r'\s+'), '').toLowerCase();

    return HomeBannerModel(
      image: image,
      title: ResponseParser.asString(
        json['label'] ?? json['title'] ?? json['name'],
        fallback: ApiResponse.localized((l) => l.discover_adcc, 'Discover ADCC'),
      ),
      subtitle: ResponseParser.asString(
        json['description'] ?? json['subtitle'],
        fallback: '',
      ),
      highlight: ResponseParser.asString(
        json['title'] ?? json['highlight'] ?? json['ctaTitle'],
        fallback: '',
      ),
      buttonText: ResponseParser.asString(
        json['buttonText'] ?? json['ctaText'] ?? json['label'],
        fallback: ApiResponse.localized((l) => l.findRide, 'Find a ride'),
      ),
      targetScreen: targetScreen,
      updatedAt: updatedAt,
    );
  }
}

class HomeTrackModel {
  final String id;
  final String title;
  final String location;
  final String distance;
  final String image;
  final String level;
  final String status;

  const HomeTrackModel({
    required this.id,
    required this.title,
    required this.location,
    required this.distance,
    required this.image,
    required this.level,
    required this.status,
  });

  factory HomeTrackModel.fromJson(Map<String, dynamic> json) {
    final rawDistance = json['distance'];
    final distanceText = rawDistance == null
        ? ApiResponse.localized((l) => l.not_available, 'N/A')
        : rawDistance is num
            ? '${rawDistance.toString()} km'
            : rawDistance.toString();

    return HomeTrackModel(
      id: ResponseParser.asString(json['_id'] ?? json['id']),
      title: ResponseParser.asString(json['title'],
          fallback: ApiResponse.localized((l) => l.trackLabel, 'Track')),
      location: ResponseParser.asString(
        json['city'] ?? json['address'] ?? json['area'],
        fallback: ApiResponse.localized((l) => l.defaultCity, 'Abu Dhabi'),
      ),
      distance: distanceText,
      image: ResponseParser.asString(
        json['image'] ?? json['mainImage'],
        fallback: 'assets/images/no-img.jpg',
      ),
      level: ResponseParser.asString(
        json['difficulty'] ?? json['type'],
        fallback: ApiResponse.localized((l) => l.beginner, 'Beginner'),
      ),
      status: ResponseParser.asString(
        json['status'],
        fallback: ApiResponse.localized((l) => l.event_status_open, 'Open'),
      ),
    );
  }
}

class HomeStoreItemModel {
  final String id;
  final String image;
  final String title;
  final String postedBy;
  final String price;

  const HomeStoreItemModel({
    required this.id,
    required this.image,
    required this.title,
    required this.postedBy,
    required this.price,
  });

  factory HomeStoreItemModel.fromJson(Map<String, dynamic> json) {
    final createdBy = json['createdBy'];
    final createdByName = createdBy is Map<String, dynamic>
        ? ResponseParser.asString(createdBy['fullName'])
        : '';
    String? firstPhotoUrl(dynamic photos) {
      if (photos is List && photos.isNotEmpty) {
        final first = photos.first;
        if (first is String && first.trim().isNotEmpty) return first.trim();
        if (first is Map<String, dynamic>) {
          return ResponseParser.asString(
            first['url'] ?? first['image'] ?? first['path'],
          );
        }
      }
      return null;
    }

    final priceValue =
        json['price'] ?? json['amount'] ?? json['currentPrice'] ?? 0;
    final String currency = ResponseParser.asString(json['currency'], fallback: '');
    final priceText = priceValue is num
        ? formatPriceWithCurrency(priceValue, currency)
        : '$priceValue';

    return HomeStoreItemModel(
      id: ResponseParser.asString(json['_id'] ?? json['id']),
      image: ResponseParser.asString(
        json['coverImage'] ??
            firstPhotoUrl(json['photos']) ??
            json['image'] ??
            json['mainImage'],
        fallback: 'assets/images/bike.png',
      ),
      title: ResponseParser.asString(json['title'] ?? json['name'],
          fallback: ApiResponse.localized((l) => l.product_label, 'Item')),
      postedBy: ResponseParser.asString(
        json['sellerName'] ??
            json['postedBy'] ??
            json['authorName'] ??
            createdByName,
        fallback: '',
      ),
      price: priceText,
    );
  }
}

class HomeFeedPostModel {
  final String id;
  final String profileImage;
  final String name;
  final String locationTime;
  final String postImage;
  final int likes;
  final int commentsCount;
  final bool likedByMe;
  final String caption;

  const HomeFeedPostModel({
    required this.id,
    required this.profileImage,
    required this.name,
    required this.locationTime,
    required this.postImage,
    required this.likes,
    required this.commentsCount,
    required this.likedByMe,
    required this.caption,
  });

  HomeFeedPostModel copyWith({
    String? id,
    String? profileImage,
    String? name,
    String? locationTime,
    String? postImage,
    int? likes,
    int? commentsCount,
    bool? likedByMe,
    String? caption,
  }) {
    return HomeFeedPostModel(
      id: id ?? this.id,
      profileImage: profileImage ?? this.profileImage,
      name: name ?? this.name,
      locationTime: locationTime ?? this.locationTime,
      postImage: postImage ?? this.postImage,
      likes: likes ?? this.likes,
      commentsCount: commentsCount ?? this.commentsCount,
      likedByMe: likedByMe ?? this.likedByMe,
      caption: caption ?? this.caption,
    );
  }

  factory HomeFeedPostModel.fromJson(Map<String, dynamic> json) {
    final createdBy = json['createdBy'];
    final createdByName = createdBy is Map<String, dynamic>
        ? ResponseParser.asString(createdBy['fullName'])
        : '';
    final createdByImage = createdBy is Map<String, dynamic>
        ? ResponseParser.asString(createdBy['profileImage'])
        : '';
    final city = ResponseParser.asString(json['city'] ?? json['location']);
    final timeText = ResponseParser.asString(
      json['timeAgo'] ?? json['createdAt'],
      fallback: ApiResponse.localized((l) => l.just_now, 'Recently'),
    );

    return HomeFeedPostModel(
      id: ResponseParser.asString(json['_id'] ?? json['id']),
      profileImage: ResponseParser.asString(
        json['authorImage'] ??
            json['userImage'] ??
            json['profileImage'] ??
            createdByImage,
        fallback: 'assets/images/profile_sara.png',
      ),
      name: ResponseParser.asString(
        json['authorName'] ?? json['userName'] ?? json['name'] ?? createdByName,
        fallback: '',
      ),
      locationTime: city.isEmpty ? timeText : '$city • $timeText',
      postImage: ResponseParser.asString(
        json['image'] ?? json['mainImage'] ?? json['postImage'],
        fallback: 'assets/images/ride.png',
      ),
      likes: ResponseParser.asInt(json['likesCount'] ?? json['likes']),
      commentsCount: ResponseParser.asInt(
        json['commentsCount'] ?? json['commentCount'] ?? json['comments'],
        fallback: 0,
      ),
      likedByMe: ResponseParser.asBool(json['likedByMe']),
      caption: ResponseParser.asString(
        json['caption'] ?? json['description'],
        fallback: '',
      ),
    );
  }
}

class HomeRideInfoModel {
  final String title;
  final String subtitle;
  final String sectionTitle;

  const HomeRideInfoModel({
    required this.title,
    required this.subtitle,
    this.sectionTitle = '',
  });
}
