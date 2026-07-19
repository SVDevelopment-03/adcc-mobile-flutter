import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/features/home/models/home_models.dart';
import 'package:adcc/shared/widgets/ride_info_card.dart';
import 'package:flutter/material.dart';

class RideInfoSection extends StatelessWidget {
  final List<HomeRideInfoModel> rideInfos;
  final String sectionTitle;
  final bool showFallback;

  const RideInfoSection({
    super.key,
    this.rideInfos = const [],
    this.sectionTitle = 'Ride in Abu Dhabi',
    this.showFallback = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Text(
            sectionTitle,
            style: theme.textTheme.titleLarge?.copyWith(
              fontFamily: 'Outfit',
              fontWeight: FontWeight.w600,
              fontSize: 20,
              height: 1.0,
              letterSpacing: 0,
              color: AppColors.textDark,
            ),
          ),

          const SizedBox(height: 12),

          // Cards
          ...(rideInfos.isEmpty
              ? (showFallback
                  ? const [
                      RideInfoCard(
                        title: 'Official Cycling Routes',
                        subtitle: 'Explore safe routes across Abu Dhabi',
                      ),
                      SizedBox(height: 12),
                      RideInfoCard(
                        title: 'Track Safety & Guidelines',
                        subtitle: 'Stay safe on every ride',
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
