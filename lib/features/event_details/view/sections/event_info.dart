import 'package:flutter/material.dart';
import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/features/events/Model/model_events.dart';

class EventInfo extends StatelessWidget {
  final Event? event;

  const EventInfo({
    super.key,
    required this.event,
  });

  List<String> _buildEligibilityPoints() {
    if (event == null) {
      return const [
        "Age: 18+",
        "Helmet required",
        "Road bike mandatory",
        "Advanced experience",
      ];
    }

    final points = <String>[];

    if (event!.minAge != null) {
      points.add("Age: ${event!.minAge}+");
    }

    if (event!.eligibility != null && event!.eligibility!.isNotEmpty) {
      final e = event!.eligibility!.first;

      points.add(
        e["helmetRequired"] == true ? "Helmet required" : "Helmet not required",
      );

      points.add(
        e["roadBikeOnly"] == true
            ? "Road bike mandatory"
            : "Road bike not mandatory",
      );

      points.add(
        "Experience: ${_capitalize(e["experienceLevel"]?.toString() ?? "All")}",
      );

      points.add(
        "Gender: ${_capitalize(e["gender"]?.toString() ?? "All")}",
      );
    }

    return points;
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    final points = _buildEligibilityPoints();

    if (points.isEmpty) {
      points.addAll(const [
        "Age: 18+",
        "Helmet required",
        "Road bike mandatory",
        "Advanced experience",
      ]);
    }

    final half = (points.length / 2).ceil();
    final leftColumn = points.sublist(0, half);
    final rightColumn =
        points.length > half ? points.sublist(half) : <String>[];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Who Can Join",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Color(0xFFE9E4DB)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: leftColumn
                        .map((e) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: _JoinItem(text: e),
                            ))
                        .toList(),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: rightColumn
                        .map((e) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: _JoinItem(text: e),
                            ))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _JoinItem extends StatelessWidget {
  final String text;

  const _JoinItem({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          "assets/icons/tick.jpg",
          width: 18,
          height: 18,
          fit: BoxFit.contain,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500, // Medium
              height: 17 / 13,
              letterSpacing: 0,
              color: AppColors.charcoal,
            ),
          ),
        ),
      ],
    );
  }
}
