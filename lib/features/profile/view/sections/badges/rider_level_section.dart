// import 'package:flutter/material.dart';
// import 'package:adcc/core/theme/app_colors.dart';

// class RiderStatsSection extends StatelessWidget {
//   final String riderLevel;

//   final String badgesTitle;
//   final String badgesValue;

//   final String pointsTitle;
//   final String pointsValue;

//   final String progressTitle;
//   final String progressValue;

//   const RiderStatsSection({
//     super.key,
//     required this.riderLevel,
//     required this.badgesTitle,
//     required this.badgesValue,
//     required this.pointsTitle,
//     required this.pointsValue,
//     required this.progressTitle,
//     required this.progressValue,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 0),
//           child: Container(
//             width: double.infinity,
//             height: 40,
//             padding: const EdgeInsets.only(
//               top: 10,
//               bottom: 11,
//               left: 13,
//               right: 13,
//             ),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.55),
//               borderRadius: BorderRadius.circular(12),

//             ),
//             alignment: Alignment.centerLeft,
//             child: Text(
//   riderLevel,
//   maxLines: 1,
//   overflow: TextOverflow.ellipsis,
//   style: const TextStyle(
//     fontFamily: 'Outfit',
//     fontSize: 12.7012,
//     fontWeight: FontWeight.w500,
//     height: 1.43,
//     letterSpacing: 0,
//     color: AppColors.charcoal
//   ),
// )
//           ),
//         ),
//         const SizedBox(height: 16),

//         SizedBox(
//           height: 75,
//           child: SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             padding: const EdgeInsets.symmetric(horizontal: 0),
//             child: Row(
//               children: [
//                 _StatCard(
//                   title: badgesTitle,
//                   value: badgesValue,
//                 ),
//                 const SizedBox(width: 13),
//                 _StatCard(
//                   title: pointsTitle,
//                   value: pointsValue,
//                 ),
//                 const SizedBox(width: 13),
//                 _StatCard(
//                   title: progressTitle,
//                   value: progressValue,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
// class _StatCard extends StatelessWidget {
//   final String title;
//   final String value;

//   const _StatCard({
//     required this.title,
//     required this.value,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 111,
//       height: 75,
//       padding: const EdgeInsets.only(
//         top: 10,
//         right: 19,
//         bottom: 10,
//         left: 16,
//       ),
//       decoration: BoxDecoration(
//         color: Colors.transparent,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: Color(0XFF3333333B),
//           width: 1,
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             maxLines: 2,
//             overflow: TextOverflow.ellipsis,
//             style: const TextStyle(
//               fontFamily: 'Outfit',
//               fontWeight: FontWeight.w400,
//               fontSize: 12,
//               height: 1,
//               color: AppColors.charcoal,
//             ),
//           ),
//           const SizedBox(height: 8.8383),
//           Text(
//             value,
//             style:  TextStyle(
//               fontFamily: 'Outfit',
//               fontWeight: FontWeight.w500,
//               fontSize: 15,
//               height: 1,
//               color: AppColors.charcoal,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class RiderStatsSection extends StatelessWidget {
  final String riderLevel;

  final String badgesTitle;
  final String badgesValue;

  final String pointsTitle;
  final String pointsValue;

  final String progressTitle;
  final String progressValue;

  const RiderStatsSection({
    super.key,
    required this.riderLevel,
    required this.badgesTitle,
    required this.badgesValue,
    required this.pointsTitle,
    required this.pointsValue,
    required this.progressTitle,
    required this.progressValue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Rider Level pill
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0x0D000000),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            riderLevel,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 13,
              fontWeight: FontWeight.w500,
              height: 1.4,
              letterSpacing: 0,
              color: Color(0xFF1C2B4A),
            ),
          ),
        ),

        const SizedBox(height: 14),

        // Stat cards row — horizontal scroll
        LayoutBuilder(
          builder: (context, constraints) {
            final availableWidth = constraints.maxWidth.isFinite
                ? constraints.maxWidth
                : MediaQuery.of(context).size.width;
            final cardWidth = (availableWidth - 24) / 3;
            final cardHeight = (cardWidth * 1.11).clamp(100.0, 260.0);

            return SizedBox(
              height: cardHeight,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _StatCard(
                      width: cardWidth,
                      height: cardHeight,
                      title: badgesTitle,
                      value: badgesValue,
                      iconAsset: 'assets/icons/total-badges.png',
                      fallbackIcon: Icons.military_tech_rounded,
                      iconColor: const Color(0xFFFFD166),
                    ),
                    const SizedBox(width: 12),
                    _StatCard(
                      width: cardWidth,
                      height: cardHeight,
                      title: pointsTitle,
                      value: pointsValue,
                      iconAsset: 'assets/icons/gift-reward.png',
                      fallbackIcon: Icons.card_giftcard_rounded,
                      iconColor: const Color(0xFF9B8EFF),
                    ),
                    const SizedBox(width: 12),
                    _StatCard(
                      width: cardWidth,
                      height: cardHeight,
                      title: progressTitle,
                      value: progressValue,
                      iconAsset: 'assets/icons/in-progress.png',
                      fallbackIcon: Icons.directions_bike_rounded,
                      iconColor: const Color(0xFF6EC6FF),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final double width;
  final double height;
  final String title;
  final String value;
  final String iconAsset;
  final IconData fallbackIcon;
  final Color iconColor;

  const _StatCard({
    required this.width,
    required this.height,
    required this.title,
    required this.value,
    required this.iconAsset,
    required this.fallbackIcon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF5257B5), Color(0xFFB399DA)],
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: const Color(0x3333333B),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Title + Value at top
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontWeight: FontWeight.w400,
                    fontSize: 11,
                    height: 1.3,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontWeight: FontWeight.w700,
                    fontSize: 21,
                    height: 1,
                    color: Colors.white,
                  ),
                ),
              ],
            ),

            // Icon at bottom-left
            Align(
              alignment: Alignment.bottomLeft,
              child: _buildIcon(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Image.asset(
      iconAsset,
      width: 28,
      height: 28,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => Icon(
        fallbackIcon,
        size: 28,
        color: iconColor,
      ),
    );
  }
}
