import 'package:flutter/material.dart';
import 'package:adcc/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';

class RouteDetailsGridSection extends StatelessWidget {
  final Map<String, String> routeDetails;

  const RouteDetailsGridSection({
    super.key,
    required this.routeDetails,
  });

  static const Map<String, String> _detailIcons = {
    'Distance': 'assets/icons/track-indicator.png',
    'Elevation': 'assets/icons/elevation.png',
    'Type': 'assets/icons/loop-track.png',
    'Avg Time': 'assets/icons/stop-watch.png',
    'Pace': 'assets/icons/type.png',
  };

  String _iconForLabel(String label) {
    return _detailIcons[label] ?? 'assets/svg/trackicon.png';
  }

  @override
  Widget build(BuildContext context) {
    final entries = routeDetails.entries.toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.trackDetails,
            style: const TextStyle(
              fontFamily: "Outfit",
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 16),

          /// Responsive Layout
          LayoutBuilder(
            builder: (context, constraints) {
              final screenWidth = constraints.maxWidth;

              /// Minimum width required to look perfect
              const double minRequiredWidth = 340;

              /// Small card height
              const double smallCardHeight = 95;

              /// Spacing
              const double spacing = 12;

              /// Tall card height (2 small cards + spacing)
              const double tallCardHeight = (smallCardHeight * 2) + spacing;

              Widget content = Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// LEFT GRID
                  SizedBox(
                    width: screenWidth * 0.65,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _RouteDetailSmallCard(
                                height: smallCardHeight,
                                iconPath: _iconForLabel(
                                  entries.isNotEmpty
                                      ? entries[0].key
                                      : AppLocalizations.of(context)!.distance,
                                ),
                                label: entries.isNotEmpty
                                    ? entries[0].key
                                    : AppLocalizations.of(context)!.distance,
                                value: entries.isNotEmpty
                                    ? entries[0].value
                                    : "1demo",
                              ),
                            ),
                            const SizedBox(width: spacing),
                            Expanded(
                              child: _RouteDetailSmallCard(
                                height: smallCardHeight,
                                iconPath: _iconForLabel(
                                  entries.length > 1
                                      ? entries[1].key
                                      : AppLocalizations.of(context)!.elevation,
                                ),
                                label: entries.length > 1
                                    ? entries[1].key
                                    : AppLocalizations.of(context)!.elevation,
                                value: entries.length > 1
                                    ? entries[1].value
                                    : "+12m",
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: spacing),
                        Row(
                          children: [
                            Expanded(
                              child: _RouteDetailSmallCard(
                                height: smallCardHeight,
                                iconPath: _iconForLabel(
                                  entries.length > 2 ? entries[2].key : AppLocalizations.of(context)!.type_label,
                                ),
                                label: entries.length > 2
                                    ? entries[2].key
                                    : AppLocalizations.of(context)!.type_label,
                                value: entries.length > 2
                                    ? entries[2].value
                                    : "Loop Track",
                              ),
                            ),
                            const SizedBox(width: spacing),
                            Expanded(
                              child: _RouteDetailSmallCard(
                                height: smallCardHeight,
                                iconPath: _iconForLabel(
                                  entries.length > 3
                                      ? entries[3].key
                                      : AppLocalizations.of(context)!.avg_time,
                                ),
                                label: entries.length > 3
                                    ? entries[3].key
                                    : AppLocalizations.of(context)!.avg_time,
                                value: entries.length > 3
                                    ? entries[3].value
                                    : "18–25 min",
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: spacing),

                  /// RIGHT TALL CARD
                  SizedBox(
                    width: screenWidth * 0.30,
                    child: _RouteDetailTallCard(
                      height: tallCardHeight,
                      iconPath: _iconForLabel(
                        entries.length > 4 ? entries[4].key : AppLocalizations.of(context)!.pace,
                      ),
                      label: entries.length > 4 ? entries[4].key : AppLocalizations.of(context)!.pace,
                      value: entries.length > 4
                          ? entries[4].value
                          : "Beginner / Casual",
                    ),
                  ),
                ],
              );

              /// If screen too small → horizontal scroll
              if (screenWidth < minRequiredWidth) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: minRequiredWidth,
                    child: content,
                  ),
                );
              }

              return content;
            },
          ),
        ],
      ),
    );
  }
}

class _RouteDetailSmallCard extends StatelessWidget {
  final String iconPath;
  final String label;
  final String value;
  final double height;

  const _RouteDetailSmallCard({
    required this.iconPath,
    required this.label,
    required this.value,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.fromLTRB(18, 20, 4, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ICON + LABEL
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 18,
                height: 18,
                child: Image.asset(
                  iconPath,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontFamily: "Outfit",
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textDark,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: "Outfit",
                fontSize: 12.7012,
                fontWeight: FontWeight.w500,
                color: Color(0XFF1A1C20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RouteDetailTallCard extends StatelessWidget {
  final String iconPath;
  final String label;
  final String value;
  final double height;

  const _RouteDetailTallCard({
    required this.iconPath,
    required this.label,
    required this.value,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: Image.asset(
              iconPath,
              fit: BoxFit.contain,
            ),
          ),
          const Spacer(),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: "Outfit",
              fontSize: 10,
              fontWeight: FontWeight.w400,
              color: AppColors.charcoal,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: "Outfit",
              fontSize: 12.7012,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}
