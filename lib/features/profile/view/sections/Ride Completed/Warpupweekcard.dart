import 'package:adcc/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class WrapUpWeekCard extends StatefulWidget {
  const WrapUpWeekCard({super.key});

  @override
  State<WrapUpWeekCard> createState() => _WrapUpWeekCardState();
}

class _WrapUpWeekCardState extends State<WrapUpWeekCard> {
  int rating = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: 358,
      height: 682,
      decoration: BoxDecoration(
        color: const Color(0xffF0DDAF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          children: [
            const SizedBox(height: 30),

            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xffCE6921),
                  width: 1,
                ),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xffCE6921),
                    Color(0xffEF7722),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Image.asset(
                  "assets/icons/winner.png",
                  width: 40,
                  height: 40,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              l10n.wrap_up_week,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              l10n.great_job_completing_ride,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),

            const SizedBox(height: 20),

            /// RATE EXPERIENCE CARD
            Container(
              width: 302,
              height: 97,
              decoration: BoxDecoration(
                color: const Color(0xffFFEFD7),
                borderRadius: BorderRadius.circular(9.9496),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.challenge_rate_experience,
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      5,
                      (index) => buildStar(index),
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 18),

            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    statCard("assets/icons/distance.png", l10n.distance, "2.32"),
                    statCard(
                        "assets/icons/duration.png", l10n.duration, "00:00:29"),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    statCard(
                        "assets/icons/avg_speed.png", l10n.avg_speed, "288.0"),
                    statCard("assets/icons/calories.png", l10n.calories, "81"),
                  ],
                ),
              ],
            ),

            const Spacer(),

            /// ELEVATION BUTTON
            Container(
              width: 296,
              height: 46,
              decoration: BoxDecoration(
                color: const Color(0xffD63A3A),
                borderRadius: BorderRadius.circular(9.9496),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.elevation_gain,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 50),
                  Image.asset(
                    "assets/icons/gain.png", // apni image
                    width: 18,
                    height: 18,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    "45 m",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 20)
          ],
        ),
      ),
    );
  }

  Widget buildStar(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          rating = index + 1;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: Image.asset(
          "assets/icons/rate.png",
          width: 26,
          height: 26,
          color: rating > index ? Colors.orange : Colors.grey,
        ),
      ),
    );
  }

  Widget statCard(String imagePath, String title, String value) {
    return Container(
      width: 128,
      height: 112,
      decoration: BoxDecoration(
        color: const Color(0xffFFEFD7),
        borderRadius: BorderRadius.circular(9.9496),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            width: 22,
            height: 22,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
