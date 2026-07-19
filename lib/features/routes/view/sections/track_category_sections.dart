import 'package:flutter/material.dart';

class TrackCategory extends StatelessWidget {
  final List<String> categories;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const TrackCategory({
    super.key,
    required this.categories,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final isSelected = selectedIndex == index;

          return GestureDetector(
            onTap: () => onSelected(index),
            child: Container(
              height: 38,
              padding: const EdgeInsets.fromLTRB(
                12,
                9,
                13,
                9,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFCF9F0C) // selected bg
                    : const Color(0x1A1C201A), // unselected bg
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  categories[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Outfit",
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 20 / 14,
                    color: isSelected
                        ? Colors.white
                        : const Color(0xFF1A1C20),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}