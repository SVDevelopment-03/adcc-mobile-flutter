import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/features/events/Model/model_events.dart';
import 'package:flutter/material.dart';

class RequiredGearSection extends StatelessWidget {
  final Event? event;

  const RequiredGearSection({super.key, required this.event});

  List<_RequiredGearItem> _buildItems() {
    final backendItems = _buildBackendItems();
    if (backendItems.isNotEmpty) {
      return backendItems.take(4).toList();
    }

    final eligibility = event?.eligibility != null && event!.eligibility!.isNotEmpty
        ? event!.eligibility!.first
        : null;
    final amenities = (event?.amenities ?? const <String>[])
        .map((value) => value.toLowerCase().trim())
        .toSet();

    final helmetRequired = eligibility?['helmetRequired'] == true;
    final roadBikeOnly = eligibility?['roadBikeOnly'] == true;
    final hasLights = amenities.any((value) =>
        value.contains('light') || value.contains('lighting'));
    final hasWater = amenities.any((value) =>
        value.contains('water'));

    return [
      _RequiredGearItem(
        iconPath: 'assets/icons/safety_shield.png',
        label: helmetRequired ? 'Helmet\n(Mandatory)' : 'Helmet\n(Recommended)',
      ),
      _RequiredGearItem(
        iconPath: 'assets/icons/front-rear.png',
        label: hasLights ? 'Front & Rear\nLights' : 'Front & Rear\nLights',
      ),
      _RequiredGearItem(
        iconPath: 'assets/icons/cycle.png',
        label: roadBikeOnly ? 'Road Bike\nMandatory' : 'Road Bike\nRecommended',
      ),
      _RequiredGearItem(
        iconPath: 'assets/icons/water-bottles.png',
        label: hasWater ? 'Water\nBottles' : 'Water\nBottles',
      ),
    ];
  }

  List<_RequiredGearItem> _buildBackendItems() {
    final rawItems = event?.requiredGear;
    if (rawItems == null || rawItems.isEmpty) return const [];

    const iconMap = {
      'helmet': 'assets/icons/safety_shield.png',
      'lights': 'assets/icons/lighting.png',
      'light': 'assets/icons/lighting.png',
      'road bike': 'assets/icons/cycle.png',
      'bike': 'assets/icons/cycle.png',
      'water': 'assets/icons/water.png',
      'bottle': 'assets/icons/water.png',
    };

    return rawItems.map((item) {
      final label = _readLabel(item);
      final iconPath = _resolveIconPath(label, item['icon']?.toString());
      return _RequiredGearItem(
        iconPath: iconPath,
        label: _formatLabel(label),
      );
    }).toList();
  }

  String _readLabel(Map<String, dynamic> item) {
    final raw = item['label'] ?? item['name'] ?? item['title'] ?? item['value'];
    return raw?.toString().trim().isNotEmpty == true ? raw.toString() : 'Gear';
  }

  String _resolveIconPath(String label, String? explicitIcon) {
    if (explicitIcon != null && explicitIcon.trim().isNotEmpty) {
      return explicitIcon;
    }

    final lower = label.toLowerCase();
    if (lower.contains('helmet')) return 'assets/icons/safety_shield.png';
    if (lower.contains('light')) return 'assets/icons/lighting.png';
    if (lower.contains('road bike') || lower.contains('bike')) return 'assets/icons/cycle.png';
    if (lower.contains('water')) return 'assets/icons/water.png';
    return 'assets/icons/cycle.png';
  }

  String _formatLabel(String label) {
    final singleLine = label.replaceAll('\n', ' ').trim();
    if (singleLine.length <= 12) return singleLine;

    final parts = singleLine.split(' ');
    if (parts.length <= 1) return singleLine;

    final midpoint = (parts.length / 2).ceil();
    final top = parts.take(midpoint).join(' ');
    final bottom = parts.skip(midpoint).join(' ');
    return '$top\n$bottom';
  }

  @override
  Widget build(BuildContext context) {
    final items = _buildItems();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Required Gear',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 10),
          GridView.builder(
            itemCount: items.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              mainAxisExtent: 98,
            ),
            itemBuilder: (context, index) {
              final item = items[index];
              return _GearCard(item: item);
            },
          ),
        ],
      ),
    );
  }
}

class _RequiredGearItem {
  final String iconPath;
  final String label;

  const _RequiredGearItem({
    required this.iconPath,
    required this.label,
  });
}

class _GearCard extends StatelessWidget {
  final _RequiredGearItem item;

  const _GearCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(
              color: Color(0xFFD8DEF9),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Image.asset(
                item.iconPath,
                width: 24,
                height: 24,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.directions_bike_outlined,
                  size: 20,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              item.label,
              maxLines: 2,
              // overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Outfit',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                height: 1.2,
                letterSpacing: 0,
                color: Color(0xFF313131),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
