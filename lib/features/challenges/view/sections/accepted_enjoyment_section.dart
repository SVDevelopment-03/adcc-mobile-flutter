import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class AcceptedEnjoymentSection extends StatelessWidget {
  final List<String> selectedEnjoyments;
  final Function(String) onEnjoymentToggled;

  const AcceptedEnjoymentSection({
    super.key,
    required this.selectedEnjoyments,
    required this.onEnjoymentToggled,
  });

  @override
  Widget build(BuildContext context) {
    final enjoyments = [
      {
        'id': 'great_challenge',
        'label': 'Great Challenge',
        'image': 'assets/icons/challanges_emoji.png',
      },
      {
        'id': 'perfect_difficulty',
        'label': 'Perfect Difficulty',
        'image': 'assets/icons/lightning_emoji.png',
      },
      {
        'id': 'motivating',
        'label': 'Motivating',
        'image': 'assets/icons/muscle_emoji.png',
      },
      {
        'id': 'achievable_goals',
        'label': 'Achievable Goals',
        'image': 'assets/icons/shining_emoji.png',
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         const Text(
  'What did you enjoy?',
  textAlign: TextAlign.center,
  style: TextStyle(
    fontFamily: "Outfit",
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1,
    letterSpacing: 0,
    color: AppColors.charcoal,
  ),
),

          const SizedBox(height: 26),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: enjoyments.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 155 / 96,
            ),
            itemBuilder: (context, index) {
              final item = enjoyments[index];
              final isSelected =
                  selectedEnjoyments.contains(item['id'] as String);

              return _EnjoymentCard(
                label: item['label'] as String,
                imagePath: item['image'] as String,
                isSelected: isSelected,
                onTap: () => onEnjoymentToggled(item['id'] as String),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _EnjoymentCard extends StatelessWidget {
  final String label;
  final String imagePath;
  final bool isSelected;
  final VoidCallback onTap;

  const _EnjoymentCard({
    required this.label,
    required this.imagePath,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(9.95),
      onTap: onTap,
      child: Container(
        width: 155,
        height: 96,
        padding: const EdgeInsets.fromLTRB(20, 8, 11, 18),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFCF9F0C)
              : const Color(0xFFFFF3E2),
          borderRadius: BorderRadius.circular(9.95),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              imagePath,
              width: 30,
              height: 30,
              fit: BoxFit.contain,
            ),

            const SizedBox(height: 11),

           Text(
  label,
  style: TextStyle(
    fontFamily: "Outfit",
    fontSize: 13,
    fontWeight: FontWeight.w500,
    height: 1,
    letterSpacing: 0,
    color: isSelected
        ? Colors.white
        : AppColors.charcoal,
  ),
  maxLines: 1,
  overflow: TextOverflow.ellipsis,
),
          ],
        ),
      ),
    );
  }
}