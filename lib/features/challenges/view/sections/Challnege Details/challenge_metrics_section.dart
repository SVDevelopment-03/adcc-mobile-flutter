import 'package:adcc/features/challenges/view/sections/Challnege%20Details/metric_card.dart';
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            MetricCard(
              imagePath: "assets/icons/red_people.png",
              label: "Joined",
              value: joined.toString(),
            ),

            const SizedBox(width: 20),

            MetricCard(
              imagePath: "assets/icons/clock.png",
              label: "Days Left",
              value: daysLeft.toString(),
            ),

            const SizedBox(width: 20),

            MetricCard(
              imagePath: "assets/icons/trophy.png",
              label: "Points",
              value: points.toString(),
            ),
          ],
        ),
      ),
    );
  }
}