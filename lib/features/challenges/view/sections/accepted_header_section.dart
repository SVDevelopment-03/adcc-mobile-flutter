import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/app_colors.dart';

class AcceptedHeaderSection extends StatelessWidget {
  final String challengeTitle;

  const AcceptedHeaderSection({
    super.key,
    required this.challengeTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Trophy icon with gradient background
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
           
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFFCE6921).withOpacity(0.25),
                const Color(0xFFEF7722).withOpacity(0.25),
              ],
            ),
          ),
          child: Center(
            child: SvgPicture.asset(
              'assets/svg/winner_trophy.svg',
              width: 40,
              height: 40,
            ),
          ),
        ),

        const SizedBox(height: 22),

       Text(
  'Challenge Complete!',
  textAlign: TextAlign.center,
  style: TextStyle(
    fontFamily: "Outfit",
    fontSize: 24,
    fontWeight: FontWeight.w600, // SemiBold
    height: 1, // Line height 100%
    letterSpacing: 0,
    color: AppColors.charcoal,
  ),
),

        const SizedBox(height: 4),

      Text(
  'How was your experience?',
  textAlign: TextAlign.center,
  style: TextStyle(
    fontFamily: "Outfit",
    fontSize: 14.5,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0,
    color: Color(0XFF554E4E),
  ),
),
      ],
    );
  }
}