import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class RouteFacilitiesSection extends StatelessWidget {
  final List<Map<String, dynamic>> facilities;

  const RouteFacilitiesSection({
    super.key,
    required this.facilities,
  });

  @override
  Widget build(BuildContext context) {
    if (facilities.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Facilities',
            style: TextStyle(
              fontFamily: "Outfit",
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 75,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: facilities.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final facility = facilities[index];
                return _FacilityCard(
                  iconPath:
                      facility['icon'] as String? ?? 'assets/icons/water-icon.png',
                  label: facility['label'] as String? ?? '',
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FacilityCard extends StatelessWidget {
  final String iconPath;
  final String label;

  const _FacilityCard({
    required this.iconPath,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90.56,
      height: 74.67,
      padding: const EdgeInsets.fromLTRB(8, 11, 8, 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF3BCC7E),
            Color(0xFFFFFFFF),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            iconPath,
            width: 22,
            height: 22,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) {
              return const Icon(
                Icons.error_outline,
                size: 22,
                color: Color(0xFF3C9ABA),
              );
            },
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontFamily: "Outfit",
              fontSize: 15.4727,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            // overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
