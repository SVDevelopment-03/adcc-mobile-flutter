import 'package:adcc/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AcceptedRatingSection extends StatelessWidget {
  final int? selectedRating;
  final Function(int) onRatingChanged;

  const AcceptedRatingSection({
    super.key,
    required this.selectedRating,
    required this.onRatingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 302,
      height: 97,
      decoration: BoxDecoration(
        color: const Color(0xFFFFEFD7),
        borderRadius: BorderRadius.circular(9.95),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        const Text(
  'Rate Your Experience',
  textAlign: TextAlign.center,
  style: TextStyle(
    fontFamily: "Outfit",
    fontSize: 15.8,
    fontWeight: FontWeight.w500,
    height: 1.43,
    letterSpacing: 0,
    color: AppColors.charcoal,
  ),
),

          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              final rating = index + 1;
              final isSelected =
                  selectedRating != null && rating <= selectedRating!;

              return GestureDetector(
                onTap: () => onRatingChanged(rating),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Image.asset(
                    'assets/icons/rate.png',
                    width: 32,
                    height: 33,
                    color: const Color(0xFF767676),
                    colorBlendMode: BlendMode.srcIn,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}