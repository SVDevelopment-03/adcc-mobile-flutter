import 'package:adcc/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:adcc/features/challenges/models/challenge_model.dart';
import '../../widgets/challenge_card.dart';
import '../../challenge_details_screen.dart';

class ActiveChallengesSection extends StatelessWidget {
  final List<ChallengeModel> challenges;

  const ActiveChallengesSection({
    super.key,
    this.challenges = const [],
  });
  // No static fallback data: UI should reflect API-driven content only.

  @override
  Widget build(BuildContext context) {
    final uiChallenges = challenges
        .map(
          (c) => {
            'id': c.id,
            'image': c.image,
            'difficulty': c.difficulty,
            'title': c.title,
            'description': c.description,
            'progress': c.progress,
            'target': c.target,
            'unit': c.unit,
            'daysLeft': c.daysLeft,
            'participants': c.participants,
          },
        )
        .toList();

    if (uiChallenges.isEmpty) {
      final l10n = AppLocalizations.of(context)!;
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(child: Text(l10n.challenge_no_active_challenges)),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: uiChallenges.length,
          separatorBuilder: (context, index) => const SizedBox(height: 22),
          itemBuilder: (context, index) {
            final challenge = uiChallenges[index];
            return ChallengeCard(
              imagePath: challenge['image'] as String,
              difficulty: challenge['difficulty'] as String,
              title: challenge['title'] as String,
              description: challenge['description'] as String,
              progress: challenge['progress'] as int,
              target: challenge['target'] as int,
              unit: challenge['unit'] as String,
              daysLeft: challenge['daysLeft'] as int,
              participants: challenge['participants'] as int,
              onTap: () {
                // Navigate to challenge details screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChallengeDetailsScreen(
                      challengeId: challenge['id'] as String,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
