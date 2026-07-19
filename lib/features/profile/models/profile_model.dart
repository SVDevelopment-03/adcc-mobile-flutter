import 'package:adcc/core/utils/response_parser.dart';

class ProfileModel {
  final String fullName;
  final String city;
  final String skillLevel;
  final String image;
  final String km;
  final String rides;
  final String events;

  const ProfileModel({
    required this.fullName,
    required this.city,
    required this.skillLevel,
    required this.image,
    required this.km,
    required this.rides,
    required this.events,
  });

  factory ProfileModel.fromApi({
    required Map<String, dynamic> user,
    required Map<String, dynamic> stats,
  }) {
    return ProfileModel(
      fullName: ResponseParser.asString(user['fullName'], fallback: 'Rider'),
      city: ResponseParser.asString(
        user['city'] ?? user['location'],
        fallback: 'Abu Dhabi',
      ),
      skillLevel: ResponseParser.asString(
        user['skillLevel'] ?? user['riderLevel'],
        fallback: 'Intermediate rider',
      ),
      image: ResponseParser.asString(
        user['profileImage'] ?? user['image'],
        fallback: 'assets/images/profile.png',
      ),
      km: ResponseParser.asString(
        stats['totalDistanceKm'] ??
            stats['totalDistance'] ??
            stats['km'] ??
            stats['totalKm'],
        fallback: '0',
      ),
      rides: ResponseParser.asString(
        stats['totalRides'] ?? stats['rides'],
        fallback: '0',
      ),
      events: ResponseParser.asString(
        stats['totalEventsParticipated'] ??
            stats['totalEvents'] ??
            stats['events'],
        fallback: '0',
      ),
    );
  }
}
