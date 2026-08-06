import 'package:adcc/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class CompletedEventCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String date;
  final String status;
  final String distance;
  final String time;
  final String rank;
  final String image;

  const CompletedEventCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.status,
    required this.distance,
    required this.time,
    required this.rank,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 358,
      height: 321,
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEFD7),
        borderRadius: BorderRadius.circular(11.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// IMAGE + STATUS
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.45),
                child: image.startsWith('http')
                    ? Image.network(
                        image,
                        width: 358,
                        height: 179,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Image.asset(
                          'assets/images/no-img.jpg',
                          width: 358,
                          height: 179,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Image.asset(
                        image,
                        width: 358,
                        height: 179,
                        fit: BoxFit.cover,
                      ),
              ),

              /// STATUS BADGE
              Positioned(
                top: 13,
                left: 14,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 10,
                      sigmaY: 10,
                    ),
                    child: Container(
                        width: 74,
                        height: 24,
                        padding: const EdgeInsets.fromLTRB(8, 4, 7, 4),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1C20).withOpacity(0.33),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          status,
                          style: const TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            height: 16 / 12,
                            letterSpacing: 0,
                            color: AppColors.softCream,
                          ),
                        )),
                  ),
                ),
              )
            ],
          ),

          const SizedBox(height: 10),

          /// TITLE + DATE
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// TITLE
                Expanded(
                    child: Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 15.6872,
                    fontWeight: FontWeight.w600,
                    height: 1, // 100% line height
                    letterSpacing: 0,
                    color: AppColors.textDark,
                  ),
                )),

                /// DATE
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: Colors.black54,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      date,
                      style: const TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        height: 1, // 100% line height
                        letterSpacing: 0,
                        color: AppColors.charcoal,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),

          const SizedBox(height: 4),

          /// SUBTITLE
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Text(
              subtitle,
              style: const TextStyle(
                fontFamily: 'Outfit',
                fontSize: 11,
                fontWeight: FontWeight.w400,
                height: 1,
                letterSpacing: 0,
                color: AppColors.charcoal,
              ),
            ),
          ),

          const SizedBox(height: 14),

          /// SMALL BOXES
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _InfoBox(title: "Distance", value: distance),
                _InfoBox(title: "Time", value: time),
                _InfoBox(title: "Position", value: rank),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  final String title;
  final String value;

  const _InfoBox({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 95,
      height: 64,
      padding: const EdgeInsets.only(
        top: 15,
        right: 5,
        bottom: 5,
        left: 10,
      ),
      decoration: BoxDecoration(
        color: const Color(0xffF0DDAF),
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
                color: AppColors.charcoal),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 15,
              fontWeight: FontWeight.w600,
              height: 1, // 100% line height
              letterSpacing: 0,
            ),
          )
        ],
      ),
    );
  }
}
