import 'package:adcc/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class PerformanceInsightsCard extends StatelessWidget {
  final String completionRate;
  final String averageDistance;
  final String bestCategory;

  const PerformanceInsightsCard({
    super.key,
    this.completionRate = '92%',
    this.averageDistance = '34.5 km',
    this.bestCategory = 'Community Rides',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 358,
      height: 158,
      decoration: BoxDecoration(
        color: const Color(0xffD4AA27),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

        
          Row(
            children:  [
Image.asset(
                  "assets/icons/achive.png", 
                  width: 16,
                  height: 16,
                  fit: BoxFit.contain,
                  
                ),
              SizedBox(width: 8),
             Text(
  "Performance Insights",
  style: const TextStyle(
    fontFamily: 'Outfit',
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 28 / 18, // ≈1.56
    letterSpacing: 0,
    color: Colors.white,
  ),
)
            ],
          ),

          const SizedBox(height: 18),

          /// BOXES
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _InsightBox(
                title: "Average\nCompletion Rate",
                value: completionRate,
              ),
              _InsightBox(
                title: "Average Event\nDistance",
                value: averageDistance,
              ),
              _InsightBox(
                title: "Best Category",
                value: bestCategory,
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _InsightBox extends StatelessWidget {
  final String title;
  final String value;

  const _InsightBox({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 92,
      height: 80,
      padding: const EdgeInsets.only(
        top: 10,
        right: 3,
        bottom: 10,
        left: 8,
      ),
      decoration: BoxDecoration(
        color: const Color(0xffFFF3E2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

        Text(
  title,
  style: const TextStyle(
    fontFamily: 'Outfit',
    fontSize: 10,
    fontWeight: FontWeight.w400,
    height: 1, // 100% line height
    letterSpacing: 0,
    color: Color(0xFF525252),
  ),
),

          const Spacer(),

      Text(
  value,
  style: const TextStyle(
    fontFamily: 'Outfit',
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1, // 100% line height
    letterSpacing: 0,
    color: AppColors.charcoal,
  ),
)
        ],
      ),
    );
  }
}