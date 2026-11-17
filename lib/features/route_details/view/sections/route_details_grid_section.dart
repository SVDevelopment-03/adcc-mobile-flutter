import 'package:flutter/material.dart';
import 'package:adcc/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';

class RouteDetailsGridSection extends StatelessWidget {
  final Map<String, String> routeDetails;

  const RouteDetailsGridSection({
    super.key,
    required this.routeDetails,
  });

  /// One consistent outline icon set for all detail cards.
  static const Map<String, IconData> _detailIcons = {
    'distance': Icons.straighten_rounded,
    'elevation': Icons.terrain_rounded,
    'type': Icons.alt_route_rounded,
    'avg_time': Icons.timer_outlined,
    'pace': Icons.speed_rounded,
  };

  /// Track screen accent (matches the green facility cards).
  static const Color iconColor = Color(0xFF019839);

  IconData _iconForLabel(String label) {
    return _detailIcons[label] ?? Icons.route_rounded;
  }

  String _labelForKey(BuildContext context, String key) {
    final loc = AppLocalizations.of(context)!;
    switch (key) {
      case 'distance':
        return loc.distance;
      case 'elevation':
        return loc.elevation;
      case 'type':
        return loc.type_label;
      case 'avg_time':
        return loc.avg_time;
      case 'pace':
        return loc.pace;
      default:
        return key;
    }
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
                                icon: _iconForLabel(
                                  entries.isNotEmpty ? entries[0].key : 'distance',
                                ),
                                label: entries.isNotEmpty
                                    ? _labelForKey(context, entries[0].key)
                                    : AppLocalizations.of(context)!.distance,
                                value: entries.isNotEmpty
                                    ? entries[0].value
                                    : '—',
                              ),
                            ),
                            const SizedBox(width: spacing),
                            Expanded(
                              child: _RouteDetailSmallCard(
                                height: smallCardHeight,
                                icon: _iconForLabel(
                                  entries.length > 1 ? entries[1].key : 'elevation',
                                ),
                                label: entries.length > 1
                                    ? _labelForKey(context, entries[1].key)
                                    : AppLocalizations.of(context)!.elevation,
                                value: entries.length > 1
                                    ? entries[1].value
                                    : '—',
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
                                icon: _iconForLabel(
                                  entries.length > 2 ? entries[2].key : 'type',
                                ),
                                label: entries.length > 2
                                    ? _labelForKey(context, entries[2].key)
                                    : AppLocalizations.of(context)!.type_label,
                                value: entries.length > 2
                                    ? entries[2].value
                                    : '—',
                              ),
                            ),
                            const SizedBox(width: spacing),
                            Expanded(
                              child: _RouteDetailSmallCard(
                                height: smallCardHeight,
                                icon: _iconForLabel(
                                  entries.length > 3 ? entries[3].key : 'avg_time',
                                ),
                                label: entries.length > 3
                                    ? _labelForKey(context, entries[3].key)
                                    : AppLocalizations.of(context)!.avg_time,
                                value: entries.length > 3
                                    ? entries[3].value
                                    : '—',
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
                      icon: _iconForLabel(
                        entries.length > 4 ? entries[4].key : 'pace',
                      ),
                      label: entries.length > 4 ? _labelForKey(context, entries[4].key) : AppLocalizations.of(context)!.pace,
                      value: entries.length > 4
                          ? entries[4].value
                          : '—',
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
  final IconData icon;
  final String label;
  final String value;
  final double height;

  const _RouteDetailSmallCard({
    required this.icon,
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
              Icon(
                icon,
                size: 18,
                color: RouteDetailsGridSection.iconColor,
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
  final IconData icon;
  final String label;
  final String value;
  final double height;

  const _RouteDetailTallCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.fromLTRB(14, 20, 8, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 18,
                color: RouteDetailsGridSection.iconColor,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
          Text(
            value,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: "Outfit",
              fontSize: 12.7012,
              fontWeight: FontWeight.w500,
              color: Color(0XFF1A1C20),
            ),
          ),
        ],
      ),
    );
  }
}
