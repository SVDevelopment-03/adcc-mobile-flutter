import 'package:adcc/core/services/api_response.dart';
import 'package:adcc/core/utils/response_parser.dart';

class ChallengePerformerModel {
  final int rank;
  final String name;
  final String value;

  const ChallengePerformerModel({
    required this.rank,
    required this.name,
    required this.value,
  });

  factory ChallengePerformerModel.fromJson(Map<String, dynamic> json) {
    return ChallengePerformerModel(
      rank: ResponseParser.asInt(json['rank'] ?? json['position']),
      name: ResponseParser.asString(json['name'] ?? json['userName'],
          fallback: 'Rider'),
      value: ResponseParser.asString(
        json['value'] ?? json['distance'] ?? json['score'],
        fallback: '0',
      ),
    );
  }
}

class ChallengeModel {
  final String id;
  final String title;
  final String description;
  final String image;
  final String difficulty;
  final String status;
  final int progress;
  final int target;
  final String unit;
  final int daysLeft;
  final int participants;
  final int points;
  final bool isJoined;
  final List<String> rules;
  final List<ChallengePerformerModel> topPerformers;

  const ChallengeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.difficulty,
    required this.status,
    required this.progress,
    required this.target,
    required this.unit,
    required this.daysLeft,
    required this.participants,
    required this.points,
    required this.isJoined,
    required this.rules,
    required this.topPerformers,
  });

  factory ChallengeModel.fromJson(Map<String, dynamic> json) {
    final rulesRaw = json['rules'];
    final performersRaw = json['topPerformers'] ?? json['leaderboard'];

    return ChallengeModel(
      id: ResponseParser.asString(json['_id'] ?? json['id']),
      title: ResponseParser.asString(
        json['title'],
        fallback: ApiResponse.localized((l) => l.challenge_title, 'Challenge'),
      ),
      description: ResponseParser.asString(
        json['description'],
        fallback: ApiResponse.localized(
            (l) => l.noDescriptionAvailable, 'No description available'),
      ),
      image: ResponseParser.asString(
        json['image'] ?? json['mainImage'],
        fallback: 'assets/images/no-img.jpg',
      ),
      difficulty:
          ResponseParser.asString(json['difficulty'], fallback: 'Medium'),
      status: ResponseParser.asString(json['status'], fallback: 'active')
          .toLowerCase(),
      progress: ResponseParser.asInt(
        json['progress'] ?? json['currentProgress'] ?? json['progressValue'],
      ),
      target: ResponseParser.asInt(json['target'] ?? json['goal'], fallback: 1),
      unit: ResponseParser.asString(json['unit'], fallback: 'km'),
      daysLeft: ResponseParser.asInt(json['daysLeft'] ?? json['remainingDays']),
      participants: ResponseParser.asInt(
        json['participants'] ?? json['participantsCount'],
      ),
      points: ResponseParser.asInt(json['points'] ?? json['rewardPoints']),
      isJoined: ResponseParser.asBool(
        json['isJoined'] ?? json['joined'] ?? json['memberStatus'],
      ),
      rules: rulesRaw is List
          ? rulesRaw.map((e) => e.toString()).toList()
          : const [],
      topPerformers: performersRaw is List
          ? performersRaw
              .whereType<Map<String, dynamic>>()
              .map(ChallengePerformerModel.fromJson)
              .toList()
          : const [],
    );
  }
}
