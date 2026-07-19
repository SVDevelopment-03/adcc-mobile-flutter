import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class AcceptedDifficultySection extends StatelessWidget {
  final String? selectedDifficulty;
  final Function(String) onDifficultySelected;

  const AcceptedDifficultySection({
    super.key,
    required this.selectedDifficulty,
    required this.onDifficultySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       const Text(
  'How was the difficulty?',
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

        const SizedBox(height: 17),

        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _DifficultyButton(
              label: 'Too Easy',
              icon: Icons.sentiment_very_satisfied,
              isSelected: selectedDifficulty == 'too_easy',
              onTap: () => onDifficultySelected('too_easy'),
            ),

            _DifficultyButton(
              label: 'Just Right',
              icon: Icons.sentiment_neutral,
              isSelected: selectedDifficulty == 'just_right',
              onTap: () => onDifficultySelected('just_right'),
            ),

            _DifficultyButton(
              label: 'Too Hard',
              icon: Icons.sentiment_very_dissatisfied,
              isSelected: selectedDifficulty == 'too_hard',
              onTap: () => onDifficultySelected('too_hard'),
            ),
          ],
        ),
      ],
    );
  }
}

class _DifficultyButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _DifficultyButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        width: 116,
        height: 42,
        padding: const EdgeInsets.symmetric(
          vertical: 9,
          horizontal: 6,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFCF9F0C)
              : const Color(0xFFE9E4DB),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected
                  ? Colors.white
                  : AppColors.charcoal,
            ),

            const SizedBox(width: 6),

            Expanded(
              child:Text(
  label,
  style: TextStyle(
    fontFamily: "Outfit",
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.43,
    letterSpacing: 0,
    color: isSelected
        ? Colors.white
        : AppColors.textDark, // unselected dark color
  ),
  overflow: TextOverflow.ellipsis,
),
            ),
          ],
        ),
      ),
    );
  }
}