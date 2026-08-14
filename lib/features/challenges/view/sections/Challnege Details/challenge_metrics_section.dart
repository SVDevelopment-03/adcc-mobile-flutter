import 'package:adcc/features/challenges/view/sections/Challnege%20Details/metric_card.dart';
import 'package:adcc/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class ChallengeMetricsSection extends StatelessWidget {
  final int joined;
  final int daysLeft;
  final int points;

  const ChallengeMetricsSection({
    super.key,
    required this.joined,
    required this.daysLeft,
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            MetricCard(
              imagePath: "assets/icons/red_people.png",
              label: l10n.challenge_joined_label,
              value: joined.toString(),
            ),
            const SizedBox(width: 20),
            MetricCard(
              imagePath: "assets/icons/clock.png",
              label: l10n.challenge_days_left_label,
              value: daysLeft.toString(),
            ),
            const SizedBox(width: 20),
            MetricCard(
              imagePath: "assets/icons/trophy.png",
              label: l10n.challenge_points_label,
              value: points.toString(),
            ),
          ],
        ),
      ),
    );
  }
}
