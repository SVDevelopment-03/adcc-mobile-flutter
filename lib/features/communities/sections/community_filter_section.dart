import 'package:flutter/material.dart';
import 'package:adcc/shared/widgets/category_selector.dart';

class CommunityFilterSection extends StatelessWidget {
  final List<String> filterPills;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const CommunityFilterSection({
    super.key,
    required this.filterPills,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return CategorySelector(
      categories: filterPills,
      selectedIndex: selectedIndex,
      onSelected: onSelected,
    );
  }
}
