import 'package:flutter/material.dart';
import 'package:adcc/features/challenges/models/challenge_model.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/recent_challenge_card.dart';

class RecentChallengesSection extends StatelessWidget {
  final List<ChallengeModel> recent;

  const RecentChallengesSection({
    super.key,
    this.recent = const [],
  });

  // Sample recent challenge data - replace with actual data from API
  final List<Map<String, dynamic>> recentChallenges = const [
    {
      'title': 'Evening Ride of Corniche',
      'distance': '18.2 km',
      'duration': '52 min',
      'timeAgo': 'Yesterday',
    },
    {
      'title': 'SheRides Community Event',
      'distance': '22.0 km',
      'duration': '1h 15min',
      'timeAgo': '2 days ago',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final uiRecent = recent.isEmpty
        ? recentChallenges
        : recent
            .take(3)
            .map(
              (e) => {
                'title': e.title,
                'distance': '${e.progress} ${e.unit}',
                'duration': '${e.daysLeft} days left',
                'timeAgo': e.status,
              },
            )
            .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
  'Recent Challenges',
  style: const TextStyle(
    fontFamily: "Geist",
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.5, // 150% line height
    letterSpacing: 0,
    color: AppColors.textDark,
  ),
),
        const SizedBox(height: 20),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: uiRecent.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final challenge = uiRecent[index];
            return RecentChallengeCard(
              title: challenge['title'] as String,
              distance: challenge['distance'] as String,
              duration: challenge['duration'] as String,
              timeAgo: challenge['timeAgo'] as String,
              onTap: () {
                // Navigate to challenge details
                debugPrint('Recent challenge tapped: ${challenge['title']}');
              },
            );
          },
        ),
      ],
    );
  }
}

