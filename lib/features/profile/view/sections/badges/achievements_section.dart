// import 'package:adcc/features/profile/repositories/profile_repository.dart';
// import 'package:adcc/features/profile/models/profile_history_models.dart';
// import 'package:flutter/material.dart';

// class AchievementsSection extends StatefulWidget {
//   const AchievementsSection({super.key});

//   @override
//   State<AchievementsSection> createState() => _AchievementsSectionState();
// }

// class _AchievementsSectionState extends State<AchievementsSection> {
//   List<ProfileBadgeItem> _badges = [];
//   bool _loading = true;

//   @override
//   void initState() {
//     super.initState();
//     _loadBadges();
//   }

//   Future<void> _loadBadges() async {
//     try {
//       final badges = await ProfileRepository().fetchUserBadges();
//       if (mounted) setState(() { _badges = badges; _loading = false; });
//     } catch (_) {
//       if (mounted) setState(() { _loading = false; });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 2),
//       child: Container(
//         decoration: BoxDecoration(
//           color: const Color(0xFFD4AA27),
//           borderRadius: BorderRadius.circular(16),
//         ),
//         padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildHeader(),
//             const SizedBox(height: 20),
//             _buildAchievementsGrid(),
//           ],
//         ),
//       ),
//     );
//   }

//  Widget _buildHeader() {
//   return Row(
//     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     children: [
//       Row(
//         children: [
//          Image.asset(
//   "assets/icons/achive.png",
//   height: 22,
//   width: 22,
//   fit: BoxFit.contain,
// ),
//           const SizedBox(width: 8),
//           const Text(
//   "Achievements",
//   style: TextStyle(
//     fontFamily: 'Outfit',
//     fontSize: 18,
//     fontWeight: FontWeight.w600,
//     height: 28 / 18, // ≈1.56
//     letterSpacing: 0,
//     color: Colors.white,
//   ),
// )
//         ],
//       ),
//       Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: () {},
//           borderRadius: BorderRadius.circular(20),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//             child: Row(
//               children: const [
//                Text(
//   "View All",
//   textAlign: TextAlign.center,
//   style: TextStyle(
//     fontFamily: 'Geist',
//     fontSize: 14,
//     fontWeight: FontWeight.w400,
//     height: 20 / 14, // ≈1.43
//     letterSpacing: 0,
//     color: Colors.white,
//   ),
// ),
//                 SizedBox(width: 4),
//                 Icon(
//                   Icons.chevron_right,
//                   size: 18,
//                   color: Colors.white,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     ],
//   );
// }

//   Widget _buildAchievementsGrid() {
//     if (_loading) {
//       return const Center(
//         child: Padding(
//           padding: EdgeInsets.symmetric(vertical: 20),
//           child: CircularProgressIndicator(strokeWidth: 2),
//         ),
//       );
//     }

//     final list = _badges;
//       if (list.isEmpty) {
//       return const Padding(
//         padding: EdgeInsets.symmetric(vertical: 12),
//         child: Text('No achievements yet', style: TextStyle(color: Colors.white)),
//       );
//     }

//     // Show up to 6 badges in grid
//     final items = list.take(6).toList();
//     const double spacing = 12;
//     const double rowSpacing = 16;

//     Widget buildItem(ProfileBadgeItem badge) {
//       final image = badge.imageUrl.trim();
//       final imagePath = image.isNotEmpty ? image : 'assets/icons/beginner.png';
//       return _AchievementItem(
//         imagePath: imagePath,
//         label: badge.name,
//         useIconContainer: false,
//         earned: badge.earned,
//       );
//     }

//     // Build rows of 4 where possible
//     final rows = <Widget>[];
//     for (var i = 0; i < items.length; i += 4) {
//       final rowItems = items.skip(i).take(4).toList();
//       rows.add(Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           for (var j = 0; j < 4; j++)
//             Expanded(
//               child: j < rowItems.length
//                   ? buildItem(rowItems[j])
//                   : const SizedBox.shrink(),
//             ),
//           if (i + 4 < items.length) const SizedBox(width: spacing),
//         ],
//       ));
//       rows.add(const SizedBox(height: rowSpacing));
//     }

//     return Column(children: rows);
//   }
// }
// class _AchievementItem extends StatelessWidget {
//   final String imagePath;
//   final String label;
//   final bool useIconContainer;
//   final bool earned;

//   const _AchievementItem({
//     required this.imagePath,
//     required this.label,
//     this.useIconContainer = false,
//     this.earned = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final image = imagePath.trim();
//     Widget imageWidget;
//     if (image.startsWith('http')) {
//       imageWidget = Image.network(image, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.emoji_events));
//     } else {
//       imageWidget = Image.asset(
//         image.isEmpty ? 'assets/icons/beginner.png' : image,
//         fit: BoxFit.cover,
//       );
//     }

//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         if (useIconContainer)
//           Container(
//             width: 67,
//             height: 65,
//             padding: const EdgeInsets.fromLTRB(15, 14, 16, 15),
//             decoration: BoxDecoration(
//               color: const Color(0xFFFFEFD7),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Center(child: imageWidget),
//           )
//         else
//           Container(
//             decoration: BoxDecoration(borderRadius: BorderRadius.circular(14)),
//             child: ClipRRect(borderRadius: BorderRadius.circular(14), child: AspectRatio(aspectRatio: 1, child: imageWidget)),
//           ),

//         const SizedBox(height: 8),

//         Text(
//           label,
//           textAlign: TextAlign.center,
//           maxLines: 2,
//           overflow: TextOverflow.ellipsis,
//           style: TextStyle(
//             fontFamily: 'Outfit',
//             fontSize: 10,
//             fontWeight: FontWeight.w400,
//             height: 1,
//             letterSpacing: 0,
//             color: Colors.white.withOpacity(earned ? 1.0 : 0.7),
//           ),
//         )
//       ],
//     );
//   }
// }

import 'package:adcc/features/profile/repositories/profile_repository.dart';
import 'package:adcc/features/profile/models/profile_history_models.dart';
import 'package:flutter/material.dart';

class AchievementsSection extends StatefulWidget {
  const AchievementsSection({super.key});

  @override
  State<AchievementsSection> createState() => _AchievementsSectionState();
}

class _AchievementsSectionState extends State<AchievementsSection> {
  List<ProfileBadgeItem> _badges = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadBadges();
  }

  Future<void> _loadBadges() async {
    try {
      final badges = await ProfileRepository().fetchUserBadges();
      final earnedBadges = badges.where((badge) => badge.earned).toList();
      if (mounted)
        setState(() {
          _badges = earnedBadges;
          _loading = false;
        });
    } catch (_) {
      if (mounted)
        setState(() {
          _loading = false;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: 14),
        _buildAchievementsRow(),
        const SizedBox(height: 14),
        // _buildViewAll(),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Left decorative line + icon
        _buildDecorativeSide(),
        const SizedBox(width: 10),
        const Text(
          "Achievements",
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            height: 1,
            letterSpacing: 0,
            color: Color(0xFF1C2B4A),
          ),
        ),
        const SizedBox(width: 10),
        // Right decorative line + icon
        _buildDecorativeSide(flip: true),
      ],
    );
  }

  Widget _buildDecorativeSide({bool flip = false}) {
    return Row(
      children: [
        if (!flip)
          Container(
            width: 30,
            height: 1.5,
            color: const Color(0xFFD4AA27),
          ),
        const SizedBox(width: 4),
        Icon(
          Icons.track_changes_outlined,
          size: 18,
          color: const Color(0xFFD4AA27),
        ),
        const SizedBox(width: 4),
        if (flip)
          Container(
            width: 30,
            height: 1.5,
            color: const Color(0xFFD4AA27),
          ),
      ],
    );
  }

  Widget _buildAchievementsRow() {
    if (_loading) {
      return const SizedBox(
        height: 140,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    if (_badges.isEmpty) {
      return const SizedBox(
        height: 140,
        child: Center(
          child: Text(
            'No achievements yet',
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 13,
              color: Colors.black54,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: 155,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 2),
        itemCount: _badges.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final badge = _badges[index];
          final image = badge.imageUrl.trim();
          return _AchievementCard(
            label: badge.name,
            imagePath: image.isNotEmpty ? image : '',
            earned: badge.earned,
          );
        },
      ),
    );
  }

  Widget _buildViewAll() {
    return Center(
      child: GestureDetector(
        onTap: () {},
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              "View All",
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1C2B4A),
              ),
            ),
            SizedBox(width: 4),
            Icon(
              Icons.chevron_right,
              size: 18,
              color: Color(0xFF1C2B4A),
            ),
          ],
        ),
      ),
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final String label;
  final String imagePath;
  final bool earned;

  const _AchievementCard({
    required this.label,
    required this.imagePath,
    required this.earned,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: earned ? 1.0 : 0.6,
      child: Container(
        width: 110,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF5257B5), Color(0xFFB399DA)],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            // Badge icon area
            SizedBox(
              width: 70,
              height: 70,
              child: _buildImage(),
            ),
            const SizedBox(height: 10),
            // Badge name
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  height: 1.3,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 14),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (imagePath.isEmpty) {
      return _fallbackIcon();
    }

    if (imagePath.startsWith('http') || imagePath.startsWith('https')) {
      return Image.network(
        imagePath,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => _fallbackIcon(),
      );
    }

    return Image.asset(
      imagePath,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => _fallbackIcon(),
    );
  }

  Widget _fallbackIcon() {
    // Draw an outlined star or moon as shown in the reference
    return const Icon(
      Icons.emoji_events, // A generic trophy/event icon
      color: Color(0xFFD4AA27), // Matching the gold accent color
      size: 40, // Appropriate size for the container
    );
  }
}

/// Paints a simple outlined star badge icon (matching reference image style)
class _OutlineBadgePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD4AA27).withOpacity(0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeJoin = StrokeJoin.round;

    final cx = size.width / 2;
    final cy = size.height / 2;
    final outerR = size.width * 0.42;
    final innerR = size.width * 0.18;
    const numPoints = 5;

    final path = Path();
    for (var i = 0; i < numPoints * 2; i++) {
      final angle = (i * 3.14159265 / numPoints) - 3.14159265 / 2;
      final r = i.isEven ? outerR : innerR;
      final x = cx + r * _cos(angle);
      final y = cy + r * _sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  double _cos(double rad) => _cosDeg(rad * 180 / 3.14159265);
  double _sin(double rad) => _sinDeg(rad * 180 / 3.14159265);

  double _cosDeg(double deg) {
    final rad = deg * 3.14159265 / 180;
    // Taylor series approximation
    double result = 1;
    double term = 1;
    for (int i = 1; i <= 8; i++) {
      term *= -rad * rad / ((2 * i - 1) * (2 * i));
      result += term;
    }
    return result;
  }

  double _sinDeg(double deg) {
    final rad = deg * 3.14159265 / 180;
    double result = rad;
    double term = rad;
    for (int i = 1; i <= 8; i++) {
      term *= -rad * rad / ((2 * i) * (2 * i + 1));
      result += term;
    }
    return result;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
