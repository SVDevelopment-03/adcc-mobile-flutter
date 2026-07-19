import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class AcceptedThoughtsSection extends StatelessWidget {
  final TextEditingController controller;

  const AcceptedThoughtsSection({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       const Text(
  'Additional Thoughts',
  style: TextStyle(
    fontFamily: "Geist",
    fontSize: 20,
    fontWeight: FontWeight.w500,
    height: 1.5,
    letterSpacing: 0,
    color: AppColors.charcoal, // dark text
  ),
),
        const SizedBox(height: 16),
        Container(
          height: 159,
          decoration: BoxDecoration(
            color: Color(0XFFE9E4DB),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: controller,
            maxLines: 4,
            decoration: InputDecoration(
             hintText: 'Share details about your experience.',
hintStyle: TextStyle(
  fontFamily: "Outfit",
  fontSize: 16,
  fontWeight: FontWeight.w400,
  height: 1.5,
  letterSpacing: 0,
  color: AppColors.charcoal.withOpacity(0.4), // 40% charcoal
),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
            style: const TextStyle(
              color: AppColors.charcoal,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
