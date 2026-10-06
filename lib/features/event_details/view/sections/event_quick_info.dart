import 'package:flutter/material.dart';
import 'package:adcc/l10n/app_localizations.dart';
import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/core/utils/distance_format.dart';
import 'package:adcc/features/events/Model/model_events.dart';

class EventQuickInfoSection extends StatelessWidget {
  static const int _pillsPerRow = 3;

  final Event? event;

  const EventQuickInfoSection({
    super.key,
    required this.event,
  });

  /// "current/max" when a rider limit is set, otherwise just the count.
  String _formatRegistered(Event event) {
    final current = event.currentParticipants ?? 0;
    final max = event.maxParticipants ?? 0;
    return max > 0 ? '$current/$max' : '$current';
  }

  /// Fee from the dashboard: `registrationFeeType` is `free` or `paid`, with
  /// the amount in `registrationFeeAmount` (AED).
  String _formatRegistration(Event event, AppLocalizations l) {
    final data = event.additionalData;
    final isPaid =
        data?['registrationFeeType']?.toString().toLowerCase() == 'paid';
    final rawAmount = data?['registrationFeeAmount'];
    final amount =
        rawAmount is num ? rawAmount : num.tryParse('${rawAmount ?? ''}');
    if (!isPaid || amount == null || amount <= 0) return l.free;

    final value = amount == amount.roundToDouble() ? amount.round() : amount;
    return 'AED $value';
  }

  /// Only the pills the event actually has data for — nothing is filled in
  /// with placeholder values.
  List<_PillInfo> _buildPills(Event event, AppLocalizations l) {
    final date = event.formattedDate;
    final time = event.eventTime?.trim() ?? '';
    final distance = distanceLabelOrNull(event.distance);
    final maxRiders = event.maxParticipants ?? 0;

    return [
      if (date != null && date.isNotEmpty)
        _PillInfo(title: l.dateLabel, value: date),
      if (time.isNotEmpty) _PillInfo(title: l.timeLabel, value: time),
      if (distance != null) _PillInfo(title: l.distanceLabel, value: distance),
      if (maxRiders > 0)
        _PillInfo(title: l.maxRidersLabel, value: '$maxRiders'),
      _PillInfo(title: l.registeredLabel, value: _formatRegistered(event)),
      _PillInfo(
        title: l.registrationLabel,
        value: _formatRegistration(event, l),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final event = this.event;
    if (event == null) return const SizedBox.shrink();

    final l = AppLocalizations.of(context)!;
    final pills = _buildPills(event, l);

    // Rows of three equal-width pills; a short last row is padded with empty
    // slots so its pills keep the same width as the rows above.
    final rows = <Widget>[];
    for (var start = 0; start < pills.length; start += _pillsPerRow) {
      if (rows.isNotEmpty) rows.add(const SizedBox(height: 10));
      rows.add(
        Row(
          children: [
            for (var i = 0; i < _pillsPerRow; i++) ...[
              if (i > 0) const SizedBox(width: 10),
              Expanded(
                child: start + i < pills.length
                    ? pills[start + i]
                    : const SizedBox.shrink(),
              ),
            ],
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.quickInfo,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 10),
          Column(children: rows),
        ],
      ),
    );
  }
}

class _PillInfo extends StatelessWidget {
  final String title;
  final String value;

  const _PillInfo({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 96,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightBeige, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: AppColors.charcoal.withValues(alpha: 0.55),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.charcoal,
            ),
          ),
        ],
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
