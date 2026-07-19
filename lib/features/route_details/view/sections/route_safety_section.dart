import 'package:adcc/core/constants/cosmatic_imgs.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class RouteSafetySection extends StatelessWidget {
  final String safetyMessage;
  final bool helmetRequired;

  const RouteSafetySection({
    super.key,
    required this.safetyMessage,
    required this.helmetRequired,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> points = _buildSafetyPoints();

    if (points.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: CachedNetworkImageProvider(TrackImgs.trackSafetyBackground),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(11.59),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Safety Information",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            ...points.map((point) => Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "•",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        point,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          height: 1.25,
                        ),
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  List<String> _buildSafetyPoints() {
    final List<String> parsedPoints = _parseSafetyPoints(safetyMessage);

    if (parsedPoints.isNotEmpty) {
      if (helmetRequired &&
          !parsedPoints.any((e) => e.toLowerCase().contains("helmet"))) {
        parsedPoints.add("Helmets are mandatory.");
      }
      return parsedPoints;
    }

    // 🔥 Fallback Default Points
    final fallback = [
      "Ride early morning or late evening in summer.",
      "Carry sufficient water.",
      "Follow traffic and track regulations.",
    ];

    if (helmetRequired) {
      fallback.add("Helmets are mandatory.");
    }

    return fallback;
  }

  List<String> _parseSafetyPoints(String text) {
    if (text.trim().isEmpty) return [];

    final lines = text
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    return lines.map((l) {
      return l.replaceFirst(RegExp(r'^[•\-\*]\s*'), '').trim();
    }).toList();
  }
}
