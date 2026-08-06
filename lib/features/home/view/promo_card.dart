import 'package:adcc/features/challenges/view/leaderboard_screen.dart';
import 'package:adcc/features/home/view/home_screen.dart';
import 'package:adcc/shared/widgets/adaptive_image.dart';
import 'package:flutter/material.dart';
import 'package:adcc/features/events/view/events_screen.dart';
import 'package:adcc/features/routes/view/routes_screen.dart';
import 'package:adcc/features/challenges/view/challenges_screen.dart';

class PromoData {
  final String image;
  final String title;
  final String subtitle;
  final String highlight;
  final String buttonText;

  PromoData({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.highlight,
    required this.buttonText,
  });
}

class PromoCard extends StatelessWidget {
  final PromoData data;

  /// Optional zero-based index of this promo card. Used to route to
  /// placeholder screens in sequence: 0 -> Track, 1 -> Event, 2 -> Challenge.
  /// In future this should route to the backend-provided destination.
  final int index;

  const PromoCard({super.key, required this.data, this.index = 0});

  void _handleTap(BuildContext context) {
    // TODO: Replace placeholder routing with backend destination logic
    // once backend provides route details for promo cards.

    final target = index % 3;

    if (target == 0) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => HomeScreen(initialIndex: 3),
        ),
      );
      return;
    }

    if (target == 1) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => HomeScreen(initialIndex: 1),
        ),
      );
      return;
    }

    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const LeaderboardScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () => _handleTap(context),
        child: AdaptiveImage(
          imagePath: data.image,
          fit: BoxFit.cover,
          width: double.infinity,
        ),
      ),
    );
  }
}

// Real screens are used from their respective modules above.
