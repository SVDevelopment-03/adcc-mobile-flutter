class EventModel {
  final String id;
  final String title;
  final String description;
  final String mainImage;
  final String eventImage;
  final DateTime eventDate;
  final String eventTime;
  final String address;
  final num distance;
  final List<String> amenities;
  final List<ScheduleItem> schedule;
  final Eligibility eligibility;
  final int maxParticipants;
  final int minAge;
  final int maxAge;
  final String youtubeLink;
  final int currentParticipants;
  final String status;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String category;
  final int safeTime;
  final int rank;
  final List<dynamic> user;

  EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.mainImage,
    required this.eventImage,
    required this.eventDate,
    required this.eventTime,
    required this.address,
    required this.distance,
    required this.amenities,
    required this.schedule,
    required this.eligibility,
    required this.maxParticipants,
    required this.minAge,
    required this.maxAge,
    required this.youtubeLink,
    required this.currentParticipants,
    required this.status,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    required this.category,
    required this.safeTime,
    required this.rank,
    required this.user,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json["_id"] ?? "",
      title: json["title"] ?? "",
      description: json["description"] ?? "",
      mainImage: json["mainImage"] ?? "",
      eventImage: json["eventImage"] ?? "",
      eventDate: json["eventDate"] != null
          ? DateTime.parse(json["eventDate"])
          : DateTime.now(),
      eventTime: json["eventTime"] ?? "",
      address: json["address"] ?? "",
      distance: json["distance"] ?? 0,
      amenities: (json["amenities"] as List?)?.map((e) => e.toString()).toList() ?? [],
      schedule: (json["schedule"] as List?)
          ?.map((e) => ScheduleItem.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      eligibility: Eligibility.fromJson(json["eligibility"]?[0] ?? {}),
      maxParticipants: json["maxParticipants"] ?? 0,
      minAge: json["minAge"] ?? 0,
      maxAge: json["maxAge"] ?? 0,
      youtubeLink: json["youtubeLink"] ?? "",
      currentParticipants: json["currentParticipants"] ?? 0,
      status: json["status"] ?? "",
      createdBy: json["createdBy"] ?? "",
      createdAt: json["createdAt"] != null
          ? DateTime.parse(json["createdAt"])
          : DateTime.now(),
      updatedAt: json["updatedAt"] != null
          ? DateTime.parse(json["updatedAt"])
          : DateTime.now(),
      category: json["category"] ?? "",
      safeTime: json["safeTime"] ?? 0,
      rank: json["rank"] ?? 0,
      user: json["user"] as List? ?? [],
    );
  }
}

class ScheduleItem {
  final String time;
  final String title;
  final String id;

  ScheduleItem({
    required this.time,
    required this.title,
    required this.id,
  });

  factory ScheduleItem.fromJson(Map<String, dynamic> json) {
    return ScheduleItem(
      time: json["time"] ?? "",
      title: json["title"] ?? "",
      id: json["_id"] ?? "",
    );
  }
}

class Eligibility {
  final bool helmetRequired;
  final bool roadBikeOnly;
  final String experienceLevel;
  final String gender;
  final String id;

  Eligibility({
    required this.helmetRequired,
    required this.roadBikeOnly,
    required this.experienceLevel,
    required this.gender,
    required this.id,
  });

  factory Eligibility.fromJson(Map<String, dynamic> json) {
    return Eligibility(
      helmetRequired: json["helmetRequired"] ?? false,
      roadBikeOnly: json["roadBikeOnly"] ?? false,
      experienceLevel: json["experienceLevel"] ?? "all",
      gender: json["gender"] ?? "all",
      id: json["_id"] ?? "",
    );
  }
}