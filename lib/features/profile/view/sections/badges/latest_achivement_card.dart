// import 'package:adcc/core/theme/app_colors.dart';
// import 'package:adcc/features/profile/repositories/profile_repository.dart';
// import 'package:adcc/features/profile/models/profile_history_models.dart';
// import 'package:flutter/material.dart';

// class LatestAchievementCard extends StatefulWidget {
//   const LatestAchievementCard({super.key});

//   @override
//   State<LatestAchievementCard> createState() => _LatestAchievementCardState();
// }

// class _LatestAchievementCardState extends State<LatestAchievementCard> {
//   ProfileBadgeItem? _latest;
//   bool _loading = true;

//   @override
//   void initState() {
//     super.initState();
//     _loadLatest();
//   }

//   Future<void> _loadLatest() async {
//     try {
//       final badges = await ProfileRepository().fetchUserBadges();
//       badges.sort((a, b) {
//         final ad = a.earnedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
//         final bd = b.earnedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
//         return bd.compareTo(ad);
//       });
//       ProfileBadgeItem? latest;
//       if (badges.isEmpty) {
//         latest = null;
//       } else {
//         latest = badges.firstWhere((b) => b.earned, orElse: () => badges.first);
//       }
//       if (mounted) setState(() { _latest = latest; _loading = false; });
//     } catch (_) {
//       if (mounted) setState(() { _loading = false; });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final title = _latest?.name ?? 'Latest Achievement';
//     final earnedLabel = _latest?.earnedAt != null
//         ? 'Unlocked on — ${_formatDate(_latest!.earnedAt!)}'
//         : 'Locked';
//     final image = _resolveImageSource(_latest?.imageUrl);

//     return SizedBox(
//       width: double.infinity,
//       height: 218,
//       child: Stack(
//         clipBehavior: Clip.none,
//         children: [
//           Container(
//             width: double.infinity,
//             height: 218,
//             decoration: BoxDecoration(
//               color: const Color(0xFFF0DDAF),
//               borderRadius: BorderRadius.circular(16),
//             ),
//           ),
//           Positioned(
//             top: 24,
//             left: 16,
//             child: Container(
//               width: 47,
//               height: 47,
//               decoration: const BoxDecoration(
//                 color: Color(0x33000000),
//                 shape: BoxShape.circle,
//               ),
//               child: Center(
//                 child: Image.asset(
//                   'assets/icons/trophy.png',
//                   width: 24,
//                   height: 24,
//                   fit: BoxFit.contain,
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             top: 78,
//             left: 14,
//             child: SizedBox(
//               width: 180,
//               height: 46,
//               child: Text(
//                 title,
//                 style: const TextStyle(
//                   fontFamily: 'Outfit',
//                   fontSize: 18,
//                   fontWeight: FontWeight.w600,
//                   height: 1,
//                   letterSpacing: 0,
//                   color: AppColors.charcoal,
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             top: 164,
//             left: 14,
//             child: SizedBox(
//               width: 180,
//               height: 32,
//               child: Text(
//                 _loading ? 'Loading...' : earnedLabel,
//                 style: const TextStyle(
//                   fontFamily: 'Outfit',
//                   fontSize: 13,
//                   fontWeight: FontWeight.w400,
//                   height: 1,
//                   letterSpacing: 0,
//                   color: Color(0xCC000000),
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             top: 12,
//             right: 8,
//             bottom: 12,
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(12),
//               child: image.startsWith('http')
//                   ? Image.network(
//                       image,
//                       width: 131,
//                       height: 180,
//                       fit: BoxFit.cover,
//                       errorBuilder: (_, __, ___) => Image.asset(
//                         'assets/images/no-img.jpg',
//                         width: 131,
//                         height: 180,
//                         fit: BoxFit.cover,
//                       ),
//                     )
//                     : Image.asset(
//                       image,
//                       width: 131,
//                       height: 180,
//                       fit: BoxFit.cover,
//                     ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   String _formatDate(DateTime d) {
//     return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
//   }

//   String _resolveImageSource(String? imageUrl) {
//     final value = imageUrl?.trim() ?? '';
//     if (value.isEmpty) {
//       return 'assets/images/no-img.jpg';
//     }
//     return value;
//   }
// }

import 'package:adcc/features/profile/repositories/profile_repository.dart';
import 'package:adcc/features/profile/models/profile_history_models.dart';
import 'package:adcc/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class LatestAchievementCard extends StatefulWidget {
  const LatestAchievementCard({super.key});

  @override
  State<LatestAchievementCard> createState() => _LatestAchievementCardState();
}

class _LatestAchievementCardState extends State<LatestAchievementCard> {
  ProfileBadgeItem? _latest;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadLatest();
  }

  Future<void> _loadLatest() async {
    try {
      final badges = await ProfileRepository().fetchUserBadges();
      badges.sort((a, b) {
        final ad = a.earnedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bd = b.earnedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bd.compareTo(ad);
      });
      ProfileBadgeItem? latest;
      if (badges.isEmpty) {
        latest = null;
      } else {
        latest = badges.firstWhere((b) => b.earned, orElse: () => badges.first);
      }
      if (mounted)
        setState(() {
          _latest = latest;
          _loading = false;
        });
    } catch (_) {
      if (mounted)
        setState(() {
          _loading = false;
        });
    }
  }

  String _formatDate(DateTime d) {
    // Format: "Dec 20, 2025"
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }

  String _resolveImageSource(String? imageUrl) {
    final value = imageUrl?.trim() ?? '';
    if (value.isEmpty) return 'assets/images/achievements-bg.png';
    return value;
  }

  @override
  Widget build(BuildContext context) {
    final title = _latest?.name ?? 'Latest Achievement';
    final hasDate = _latest?.earnedAt != null;
    final dateStr = hasDate ? _formatDate(_latest!.earnedAt!) : '';
    final image = _resolveImageSource(_latest?.imageUrl);

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        width: double.infinity,
        height: 240,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background image
            _buildBackgroundImage(image),

            // Dark gradient overlay from bottom
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.25),
                    Colors.black.withOpacity(0.75),
                  ],
                  stops: const [0.3, 0.6, 1.0],
                ),
              ),
            ),

            // Content at bottom-left
            Positioned(
              left: 18,
              right: 18,
              bottom: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Trophy icon
                  const Icon(
                    Icons.emoji_events_outlined,
                    color: Colors.white,
                    size: 26,
                  ),
                  const SizedBox(height: 6),

                  // Title
                  Text(
                    _loading ? AppLocalizations.of(context)!.loading : title,
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                      letterSpacing: 0,
                      color: Colors.white,
                    ),
                  ),

                  if (!_loading && hasDate) ...[
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_outlined,
                          size: 13,
                          color: Colors.white70,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          dateStr,
                          style: const TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Colors.white70,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundImage(String image) {
    if (image.isNotEmpty && image.startsWith('http')) {
      return Image.network(
        image,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Image.asset(
          'assets/images/achievements-bg.png',
          fit: BoxFit.cover,
        ),
      );
    }
    return Image.asset('assets/images/achievements-bg.png', fit: BoxFit.cover);
  }
}
