import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/features/home/models/home_models.dart';
import 'package:adcc/shared/widgets/ride_info_card.dart';
import 'package:adcc/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class RideInfoSection extends StatelessWidget {
  final List<HomeRideInfoModel> rideInfos;
  final String? sectionTitle;
  final bool showFallback;

  const RideInfoSection({
    super.key,
    this.rideInfos = const [],
    this.sectionTitle,
    this.showFallback = true,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Text(
            sectionTitle ?? l10n.ride_in_abu_dhabi,
            style: theme.textTheme.titleLarge?.copyWith(
              fontFamily: 'Outfit',
              fontWeight: FontWeight.w600,
              fontSize: 20,
              height: 1.0,
              letterSpacing: 0,
              color: AppColors.textDark,
            ),
          ),

          const SizedBox(height: 26),

          // Cards
          ...(rideInfos.isEmpty
              ? (showFallback
                  ? [
                      RideInfoCard(
                        title: AppLocalizations.of(context)!.officialCyclingRoutes,
                        subtitle: AppLocalizations.of(context)!.exploreSafeRoutes,
                      ),
                      const SizedBox(height: 12),
                      RideInfoCard(
                        title: AppLocalizations.of(context)!.trackSafetyGuidelines,
                        subtitle: AppLocalizations.of(context)!.staySafeEveryRide,
                      ),
                    ]
                  : const <Widget>[])
              : rideInfos
                  .map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: RideInfoCard(
                        title: item.title,
                        subtitle: item.subtitle,
                      ),
                    ),
                  )
                  .toList()),
        ],
      ),
    );
  }
}
