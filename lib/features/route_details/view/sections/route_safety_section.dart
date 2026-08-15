import 'package:adcc/core/constants/cosmatic_imgs.dart';
import 'package:adcc/l10n/app_localizations.dart';
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
    final List<String> points = _buildSafetyPoints(context);

    if (points.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            image: CachedNetworkImageProvider(TrackImgs.trackSafetyBackground),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(11.59),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.safetyInformation,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.black,
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
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        point,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
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

  List<String> _buildSafetyPoints(BuildContext context) {
    final List<String> parsedPoints = _parseSafetyPoints(safetyMessage);

    if (parsedPoints.isNotEmpty) {
      if (helmetRequired &&
          !parsedPoints.any((e) => e.toLowerCase().contains("helmet"))) {
        parsedPoints.add(AppLocalizations.of(context)!.helmets_mandatory);
      }
      return parsedPoints;
    }

    // 🔥 Fallback Default Points
    final fallback = [
      AppLocalizations.of(context)!.safety_ride_early,
      AppLocalizations.of(context)!.safety_carry_water,
      AppLocalizations.of(context)!.safety_follow_regulations,
    ];

    if (helmetRequired) {
      fallback.add(AppLocalizations.of(context)!.helmets_mandatory);
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
