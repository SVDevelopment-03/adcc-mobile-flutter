import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/features/events/services/categories_service.dart';
import 'package:adcc/shared/widgets/adaptive_image.dart';
import 'package:flutter/material.dart';

/// Model for event category
class EventCategory {
  final String title;
  final String imagePath;

  const EventCategory({
    required this.title,
    required this.imagePath,
  });
}

/// Grid widget displaying event categories
class EventCategoriesGrid extends StatefulWidget {
  final Function(String category)? onCategoryTap;

  const EventCategoriesGrid({
    super.key,
    this.onCategoryTap,
  });

  @override
  State<EventCategoriesGrid> createState() => _EventCategoriesGridState();
}

class _EventCategoriesGridState extends State<EventCategoriesGrid> {
  final _service = CategoriesService();
  late Future<List<EventCategory>> _futureCategories;

  @override
  void initState() {
    super.initState();
    _futureCategories = _loadCategories();
  }

  Future<List<EventCategory>> _loadCategories() async {
    try {
      final res = await _service.getAvailableCategories();
      if (res.success && res.data != null && res.data!.isNotEmpty) {
        return res.data!
            .map((t) => EventCategory(title: t, imagePath: _iconFor(t)))
            .toList();
      }

      // fallback to a small default set if API returns nothing
      final fallback = [
        'Race',
        'Community Ride',
        'Training & Clinics',
        'Awareness Rides',
        'Family & Kids',
        'Corporate',
      ];

      return fallback.map((t) => EventCategory(title: t, imagePath: _iconFor(t))).toList();
    } catch (e) {
      final fallback = [
        'Race',
        'Community Ride',
        'Training & Clinics',
        'Awareness Rides',
        'Family & Kids',
        'Corporate',
      ];

      return fallback.map((t) => EventCategory(title: t, imagePath: _iconFor(t))).toList();
    }
  }

  String _iconFor(String title) {
    final s = title.toLowerCase();
    if (s.contains('race')) return 'assets/icons/ra.png';
    if (s.contains('community')) return 'assets/icons/cf.png';
    if (s.contains('training')) return 'assets/icons/tc.png';
    if (s.contains('awareness')) return 'assets/icons/ra.png';
    return 'assets/icons/cf.png';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<EventCategory>>(
      future: _futureCategories,
      builder: (context, snapshot) {
        final categories = snapshot.data ?? [];

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.85,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return _CategoryCard(
              category: category,
              onTap: () {
                widget.onCategoryTap?.call(category.title);
              },
            );
          },
        );
      },
    );
  }
}

/// Individual category card widget
class _CategoryCard extends StatelessWidget {
  final EventCategory category;
  final VoidCallback? onTap;

  const _CategoryCard({
    required this.category,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
        child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Title at the top
              Text(
                category.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                  height: 1.2,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              // Image illustration - takes most of the space
              Expanded(
                child: Center(
                  child: AdaptiveImage(
                    imagePath: category.imagePath,
                    fit: BoxFit.contain,
                    placeholderColor: AppColors.softCream,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
