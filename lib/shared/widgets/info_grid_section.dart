import 'package:adcc/modals/info_tile.dart';
import 'package:adcc/shared/widgets/info_tile.dart';
import 'package:flutter/material.dart';

class InfoGridSection extends StatelessWidget {
  final List<InfoTileData> items;

  const InfoGridSection({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasIcon = items.any((e) => e.icon != null);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double spacing = 12;
          final int columns = hasIcon ? 2 : 3;
          final double itemWidth =
              (constraints.maxWidth - spacing * (columns - 1)) / columns;

          return Wrap(
            spacing: spacing,
            runSpacing: spacing,
            children: items.map((item) {
              return SizedBox(
                width: itemWidth,
                child: InfoTile(
                  icon: item.icon,
                  label: item.label,
                  value: item.value,
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
