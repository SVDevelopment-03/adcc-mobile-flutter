import 'package:flutter/material.dart';

/// A reusable asymmetric grid widget that creates an alternating pattern:
/// Row 1: Big card (left) + Small card (right)
/// Row 2: Small card (left) + Big card (right)
/// Cards are positioned to fill gaps, creating a compact masonry-style layout
class AsymmetricGrid extends StatelessWidget {
  /// List of items to display
  final List<dynamic> items;

  /// Builder function to create a card widget from an item
  final Widget Function(BuildContext context, dynamic item, bool isBig) itemBuilder;

  /// Height for big cards
  final double bigCardHeight;

  /// Height for small cards
  final double smallCardHeight;

  /// Spacing between cards horizontally
  final double horizontalSpacing;

  /// Spacing between rows vertically
  final double verticalSpacing;

  const AsymmetricGrid({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.bigCardHeight = 250,
    this.smallCardHeight = 180,
    this.horizontalSpacing = 12,
    this.verticalSpacing = 12,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    // Group items into pairs for rows
    final List<List<dynamic>> rows = [];
    for (int i = 0; i < items.length; i += 2) {
      if (i + 1 < items.length) {
        rows.add([items[i], items[i + 1]]);
      } else {
        rows.add([items[i]]);
      }
    }

    // Calculate total height needed
    final double totalHeight = rows.length * (bigCardHeight + verticalSpacing) -70;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Use available width from constraints (accounts for padding)
        final availableWidth = constraints.maxWidth;
        final cardWidth = (availableWidth - horizontalSpacing) / 2;

        return SizedBox(
          height: totalHeight,
          child: Stack(
            children: [
              // Position each card individually
              ...rows.asMap().entries.expand((entry) {
                final rowIndex = entry.key;
                final rowItems = entry.value;
                final isBigLeftPattern = rowIndex % 2 == 0;

                final List<Widget> cards = [];

                // Left card
                final double leftCardY = rowIndex * (bigCardHeight + verticalSpacing);
                cards.add(
                  Positioned(
                    left: 0,
                    top: leftCardY,
                    width: cardWidth,
                    height: isBigLeftPattern ? bigCardHeight : smallCardHeight,
                    child: itemBuilder(
                      context,
                      rowItems[0],
                      isBigLeftPattern,
                    ),
                  ),
                );

                // Right card
                if (rowItems.length > 1) {
                  // If Row 1 (big-left), right card is small and starts at same Y as left card
                  // If Row 2 (small-left), right card is big and starts at the bottom of Row 1's small card
                  final double rightCardY = isBigLeftPattern
                      ? leftCardY  // Same level as left card
                      : smallCardHeight + verticalSpacing; // Start at bottom of Row 1's small card

                  cards.add(
                    Positioned(
                      left: cardWidth + horizontalSpacing,
                      top: rightCardY,
                      width: cardWidth,
                      height: isBigLeftPattern ? smallCardHeight : bigCardHeight,
                      child: itemBuilder(
                        context,
                        rowItems[1],
                        !isBigLeftPattern,
                      ),
                    ),
                  );
                }

                return cards;
              }),
            ],
          ),
        );
      },
    );
  }
}
