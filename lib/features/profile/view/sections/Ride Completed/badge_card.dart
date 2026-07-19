import 'package:flutter/material.dart';

class BadgeCard extends StatelessWidget {
  const BadgeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 358,
      height: 182,
      decoration: BoxDecoration(
        color: const Color(0x8CFFFFFF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
        child: Row(
          children: [

          /// IMAGE
Container(
  width: 149,
  height: 162,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(9.2075),
    image: const DecorationImage(
      fit: BoxFit.cover,
      image: AssetImage(
        'assets/images/no-img.jpg',
      ),
    ),
  ),
),

            const SizedBox(width: 12),

            /// TEXT + BADGE
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                /// AWARD ICON
Container(
  width: 55,
  height: 55,
  decoration: const BoxDecoration(
    color: Color(0xffF0DDAF),
    shape: BoxShape.circle,
  ),
  child: Center(
    child: SizedBox(
      width: 30,
      height: 30,
      child: Image.asset(
        "assets/icons/medal.png",
        fit: BoxFit.contain,
      ),
    ),
  ),
),
                  const SizedBox(height: 12),

                  const Text(
                    "New Badge Formed!",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 4),

                  const Text(
                    "Century Explorer",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    "Complete 5 Rides in the same Condo",
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                  ),

                ],
              ),
            )

          ],
        ),
      ),
    );
  }
}