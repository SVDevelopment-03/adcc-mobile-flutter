import 'package:flutter/material.dart';
import 'package:adcc/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../../shared/widgets/asymmetric_grid.dart';

class RideByStyleSection extends StatelessWidget {
  const RideByStyleSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final styles = [
      {
        'title': l10n.hill_elevation_training,
        'subtitle': l10n.routes_count(6),
        'image': 'assets/images/no-img.jpg',
      },
      {
        'title': l10n.night_riding_routes,
        'subtitle': l10n.routes_count(8),
        'image': 'assets/images/no-img.jpg',
      },
      {
        'title': l10n.sunrise_rides,
        'subtitle': l10n.routes_count(12),
        'image': 'assets/images/no-img.jpg',
      },
      {
        'title': l10n.family_youth_friendly,
        'subtitle': l10n.routes_count(15),
        'image': 'assets/images/no-img.jpg',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: AppLocalizations.of(context)!.rideByStyle,
          onViewAll: () {},
          showViewAll: false,
        ),
        const SizedBox(height: 16),
        AsymmetricGrid(
          items: styles,
          bigCardHeight: 280,
          smallCardHeight: 200,
          horizontalSpacing: 16,
          verticalSpacing: 16,
          itemBuilder: (context, item, isBig) {
            final style = item as Map<String, dynamic>;
            return _buildStyleCard(
              title: style['title'] as String,
              subtitle: style['subtitle'] as String,
              image: style['image'] as String,
            );
          },
        ),
      ],
    );
  }

  Widget _buildStyleCard({
    required String title,
    required String subtitle,
    required String image,
  }) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppColors.buttonGuest, // #F0DDAF
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    image,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppColors.softCream,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Title
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textDark,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              // Route count
              Text(
                subtitle,
                style: const TextStyle(
                  color: AppColors.textDark,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
