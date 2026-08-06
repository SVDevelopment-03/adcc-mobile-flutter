// import 'package:adcc/core/theme/app_colors.dart';
// import 'package:adcc/features/profile/repositories/profile_repository.dart';
// import 'package:adcc/features/profile/models/profile_history_models.dart';
// import 'package:flutter/material.dart';

// class LeaderboardSection extends StatefulWidget {
//   const LeaderboardSection({super.key});

//   @override
//   State<LeaderboardSection> createState() => _LeaderboardSectionState();
// }

// class _LeaderboardSectionState extends State<LeaderboardSection> {
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
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Padding(
//           padding: EdgeInsets.symmetric(horizontal: 2),
//           child: Text(
//             "Leaderboard",
//             style: TextStyle(
//               fontFamily: 'Outfit',
//               fontSize: 20,
//               fontWeight: FontWeight.w600,
//               height: 1,
//               letterSpacing: 0,
//               color: AppColors.charcoal,
//             ),
//           ),
//         ),
//         const SizedBox(height: 18),
//         if (_loading)
//           const Center(child: CircularProgressIndicator())
//         else ...[
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 0),
//             child: Column(
//               children: _badges.take(3).map((b) {
//                 final title = b.name;
//                 final subtitle = b.earned ? 'Completed' : 'Objective';
//                 final progressText = b.earned ? 'Completed' : 'Locked';
//                 final progressValue = b.earned ? 1.0 : 0.0;
//                 return Column(
//                   children: [
//                     _LeaderboardCard(
//                       title: title,
//                       subtitle: subtitle,
//                       progressText: progressText,
//                       progressValue: progressValue,
//                     ),
//                     const SizedBox(height: 16),
//                   ],
//                 );
//               }).toList(),
//             ),
//           ),
//         ]
//       ],
//     );
//   }
// }

// class _LeaderboardCard extends StatelessWidget {
//   final String title;
//   final String subtitle;
//   final String progressText;
//   final double progressValue;

//   const _LeaderboardCard({
//     required this.title,
//     required this.subtitle,
//     required this.progressText,
//     required this.progressValue,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       height: 133,
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: const Color(0xFFFFEFD7),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 width: 63.5945,
//                 height: 63.5945,
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFCF9F0C),
//                   borderRadius: BorderRadius.circular(18.5508),
//                 ),
//                 child: Center(
//                   child: Image.asset(
//                     'assets/icons/trophy.png',
//                     width: 28,
//                     height: 28,
//                     fit: BoxFit.contain,
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                    Text(
//   title,
//   style: const TextStyle(
//     fontFamily: 'Outfit',
//     fontSize: 16,
//     fontWeight: FontWeight.w500,
//     height: 1, // 100% line height
//     letterSpacing: 0,
//     color: Color(0XFF101828)
//   ),
// ),
//                     const SizedBox(height: 4),
//                    Text(
//   subtitle,
//   style: const TextStyle(
//     fontFamily: 'Outfit',
//     fontSize: 14,
//     fontWeight: FontWeight.w500,
//     height: 1, // 100% line height
//     letterSpacing: 0,
//     color: Color(0xFF4A5565),
//   ),
// )
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 9),
// Row(
//   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   children: [
//     Text(
//       "Progress",
//       style: const TextStyle(
//         fontFamily: 'Outfit',
//         fontSize: 13,
//         fontWeight: FontWeight.w400,
//         height: 18.7066 / 13.0946, // ≈1.43
//         letterSpacing: 0,
//         color: AppColors.charcoal,
//       ),
//     ),
//     Text(
//       progressText,
//       style: const TextStyle(
//         fontFamily: 'Outfit',
//         fontSize: 13,
//         fontWeight: FontWeight.w400,
//         height: 18.7066 / 13.0946,
//         letterSpacing: 0,
//         color: AppColors.charcoal,
//       ),
//     ),
//   ],
// ),
//           const SizedBox(height: 6),
//           ClipRRect(
//             borderRadius: BorderRadius.circular(10),
//             child: LinearProgressIndicator(
//               value: progressValue,
//               minHeight: 8,
//               backgroundColor: const Color(0xFFFFFFFF),
//               valueColor: const AlwaysStoppedAnimation<Color>(
//                 Color(0xFFCF9F0C),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/features/profile/repositories/profile_repository.dart';
import 'package:adcc/features/profile/models/profile_history_models.dart';
import 'package:flutter/material.dart';

class LeaderboardSection extends StatefulWidget {
  const LeaderboardSection({super.key});

  @override
  State<LeaderboardSection> createState() => _LeaderboardSectionState();
}

class _LeaderboardSectionState extends State<LeaderboardSection> {
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
      if (mounted)
        setState(() {
          _badges = badges;
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
        const Text(
          "Leaderboard",
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            height: 1,
            letterSpacing: 0,
            color: Color(0xFF1C2B4A),
          ),
        ),
        const SizedBox(height: 16),
        if (_loading)
          const Center(child: CircularProgressIndicator())
        else
          _buildHorizontalCards(),
      ],
    );
  }

  Widget _buildHorizontalCards() {
    if (_badges.isEmpty) {
      return const Text(
        'No leaderboard data yet',
        style: TextStyle(
          fontFamily: 'Outfit',
          fontSize: 13,
          color: Colors.black54,
        ),
      );
    }

    return SizedBox(
      height: 175,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 2),
        itemCount: _badges.take(5).length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final b = _badges[index];
          final title = b.name;
          final subtitle = b.earned ? 'Completed' : 'Objective';
          final progressText = b.earned ? 'Completed' : 'In Progress';
          final progressValue = b.earned ? 1.0 : 0.25;
          return _LeaderboardCard(
            title: title,
            subtitle: subtitle,
            progressText: progressText,
            progressValue: progressValue,
          );
        },
      ),
    );
  }
}

class _LeaderboardCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String progressText;
  final double progressValue;

  const _LeaderboardCard({
    required this.title,
    required this.subtitle,
    required this.progressText,
    required this.progressValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      height: 175,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF5257B5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Trophy icon container
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFFBCB0FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Image.asset(
                'assets/icons/trophy.png',
                width: 24,
                height: 24,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.emoji_events,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Title
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              height: 1.2,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 3),

          // Subtitle
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 11,
              fontWeight: FontWeight.w400,
              height: 1.2,
              color: Colors.white70,
            ),
          ),

          const Spacer(),

          // Progress label row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Progress",
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: Colors.white70,
                ),
              ),
              Text(
                progressText,
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: Colors.white70,
                ),
              ),
            ],
          ),

          const SizedBox(height: 5),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progressValue,
              minHeight: 6,
              backgroundColor: Colors.white.withOpacity(0.15),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFFFFFFFF),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
