import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class RouteFeatureTagsSection extends StatelessWidget {
  final List<String> tags;

  const RouteFeatureTagsSection({
    super.key,
    required this.tags,
  });

  @override
  Widget build(BuildContext context) {
   
    final int tagsPerRow = 3;
    final List<List<String>> tagRows = [];
    
    for (int i = 0; i < tags.length; i += tagsPerRow) {
      final end = (i + tagsPerRow < tags.length) ? i + tagsPerRow : tags.length;
      tagRows.add(tags.sublist(i, end));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        height: 80, 
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: tagRows.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: tagRows[index].asMap().entries.map((entry) {
                    final tagIndex = entry.key;
                    final tag = entry.value;
                    return Padding(
                      padding: EdgeInsets.only(
                        right: tagIndex < tagRows[index].length - 1 ? 8 : 0,
                        bottom: 8,
                      ),
                      child: _buildTag(tag),
                    );
                  }).toList(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTag(String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.paleGreen,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        tag,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
      ),
    );
  }
}

