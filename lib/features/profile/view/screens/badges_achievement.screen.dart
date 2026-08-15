import 'package:adcc/core/constants/cosmatic_imgs.dart';
import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/features/profile/models/profile_history_models.dart';
import 'package:adcc/features/profile/repositories/profile_repository.dart';
import 'package:adcc/core/services/api_client.dart';
import 'package:adcc/core/constants/api_endpoints.dart';
import 'package:adcc/core/utils/response_parser.dart';
import 'package:adcc/features/profile/view/sections/badges/achievements_section.dart';
import 'package:adcc/features/profile/view/sections/badges/latest_achivement_card.dart';
import 'package:adcc/features/profile/view/sections/badges/leaderboard_section.dart';
import 'package:adcc/features/profile/view/sections/badges/rider_level_section.dart';
import 'package:adcc/features/profile/view/sections/badges/share_button.dart';
import 'package:adcc/l10n/app_localizations.dart';
import 'package:adcc/shared/widgets/banner_header.dart';
import 'package:adcc/core/utils/image_source.dart';
import 'package:flutter/material.dart';

class BadgesAchievementsScreen extends StatefulWidget {
  const BadgesAchievementsScreen({super.key});

  @override
  State<BadgesAchievementsScreen> createState() =>
      _BadgesAchievementsScreenState();
}

class _BadgesAchievementsScreenState extends State<BadgesAchievementsScreen> {
  late final Future<List<ProfileBadgeItem>> _badgesFuture;
  String _riderLevel = 'Intermediate';
  String _badgesValue = '0';
  String _pointsValue = '0';
  String _progressValue = '0';
  bool _statsLoading = true;

  @override
  void initState() {
    super.initState();
    _badgesFuture = ProfileRepository().fetchUserBadges();
    _loadStats();
  }

  Future<void> _loadStats() async {
    try {
      final repo = ProfileRepository();
      final profile = await repo.fetchProfile();

      final resp =
          await ApiClient.instance.get<dynamic>(ApiEndpoints.authMeStats);
      final statsMap =
          ResponseParser.extractMap(resp.data, const ['stats', 'data']) ??
              ResponseParser.extractMap(resp.data, const ['data']) ??
              <String, dynamic>{};

      final totalPoints = ResponseParser.asInt(
          statsMap['totalPoints'] ?? statsMap['points'] ?? 0);
      final inProgress = ResponseParser.asInt(
          statsMap['inProgressBadges'] ?? statsMap['badgesInProgress'] ?? 0);

      final badges = await _badgesFuture;
      final earnedCount = badges.where((b) => b.earned).length;

      if (mounted) {
        setState(() {
          _riderLevel = profile?.skillLevel ?? 'Intermediate';
          _badgesValue = earnedCount.toString().padLeft(2, '0');
          _pointsValue = totalPoints.toString();
          _progressValue = inProgress.toString();
          _statsLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _statsLoading = false);
    }
  }

  String _dateLabel(DateTime? date) {
    if (date == null) return AppLocalizations.of(context)!.rider_level_locked;
    final d = date.toLocal();
    return 'Earned ${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final horizontalPadding = (screenWidth * 0.05).clamp(12.0, 24.0);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: resolveImageProvider(ProfileImgs.profileBackground),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding:
              EdgeInsets.fromLTRB(horizontalPadding, 16, horizontalPadding, 20),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  BannerHeadder(
                    imagePath: 'assets/images/badges-achiv.jpg',
                    title: AppLocalizations.of(context)!.badges_achivements,
                    subtitle: '',
                    centerTitle: true,
                    onBackTap: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 28),
                  RiderStatsSection(
                    riderLevel: "${AppLocalizations.of(context)!.riderLevel}: ${_riderLevel}",
                    badgesTitle: AppLocalizations.of(context)!.total_badges,
                    badgesValue: _statsLoading ? '...' : _badgesValue,
                    pointsTitle: AppLocalizations.of(context)!.total_points,
                    pointsValue: _statsLoading ? '...' : _pointsValue,
                    progressTitle: AppLocalizations.of(context)!.inProgress,
                    progressValue: _statsLoading ? '...' : _progressValue,
                  ),
                  const SizedBox(height: 32),
                  LatestAchievementCard(),
                  const SizedBox(height: 40),
                  const AchievementsSection(),
                  const SizedBox(height: 40),
                  _buildMyBadgesGrid(),
                  const SizedBox(height: 40),
                  const LeaderboardSection(),
                  const SizedBox(height: 40),
                  const ShareAchievementsButton(),
                  const SizedBox(height: 111),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMyBadgesGrid() {
    return FutureBuilder<List<ProfileBadgeItem>>(
      future: _badgesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }

        final badges = snapshot.data ?? const <ProfileBadgeItem>[];
        final earnedCount = badges.where((b) => b.earned).length;

        if (badges.isEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.unlocked_badges,
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.charcoal,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.no_badges_available,
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 13,
                  color: Colors.black54,
                ),
              ),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.unlocked_badges,
              style: const TextStyle(
                fontFamily: 'Outfit',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.charcoal,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              AppLocalizations.of(context)!.earned_count(earnedCount),
              style: const TextStyle(
                fontFamily: 'Outfit',
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 14),
            GridView.builder(
              itemCount: badges.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.6,
              ),
              itemBuilder: (context, index) {
                final badge = badges[index];
                return Opacity(
                  opacity: badge.earned ? 1 : 0.45,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: badge.earned
                            ? const [Color(0xFF5257B5), Color(0xFFB399DA)]
                            : const [Color(0xFFBCB0FF), Color(0xFFD9D3FF)],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: badge.earned
                                ? const Color(0xFFFFFFFF)
                                : const Color(0xFFEDE7FF),
                            shape: BoxShape.circle,
                          ),
                          child: ClipOval(
                            child: badge.imageUrl.startsWith('http')
                                ? Image.network(
                                    badge.imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Icon(
                                      badge.earned
                                          ? Icons.emoji_events
                                          : Icons.lock_outline,
                                      size: 20,
                                      color: badge.earned
                                          ? const Color(0xFF5257B5)
                                          : const Color(0xFF7B6FB8),
                                    ),
                                  )
                                : Icon(
                                    badge.earned
                                        ? Icons.emoji_events
                                        : Icons.lock_outline,
                                    size: 20,
                                    color: badge.earned
                                        ? const Color(0xFF5257B5)
                                        : const Color(0xFF7B6FB8),
                                  ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                badge.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontFamily: 'Outfit',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _dateLabel(badge.earnedAt),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontFamily: 'Outfit',
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

// import 'package:adcc/core/theme/app_colors.dart';
// import 'package:adcc/features/profile/models/profile_history_models.dart';
// import 'package:adcc/features/profile/repositories/profile_repository.dart';
// import 'package:adcc/core/services/api_client.dart';
// import 'package:adcc/core/constants/api_endpoints.dart';
// import 'package:adcc/core/utils/response_parser.dart';
// import 'package:adcc/features/profile/models/profile_model.dart';
// import 'package:adcc/features/profile/view/sections/badges/achievements_section.dart';
// import 'package:adcc/features/profile/view/sections/badges/latest_achivement_card.dart';
// import 'package:adcc/features/profile/view/sections/badges/leaderboard_section.dart';
// import 'package:adcc/features/profile/view/sections/badges/rider_level_section.dart';
// import 'package:adcc/features/profile/view/sections/badges/share_button.dart';
// import 'package:adcc/shared/widgets/banner_header.dart';
// import 'package:flutter/material.dart';

// class BadgesAchievementsScreen extends StatefulWidget {
//   const BadgesAchievementsScreen({super.key});

//   @override
//   State<BadgesAchievementsScreen> createState() => _BadgesAchievementsScreenState();
// }

// class _BadgesAchievementsScreenState extends State<BadgesAchievementsScreen> {
//   late final Future<List<ProfileBadgeItem>> _badgesFuture;
//   String _riderLevel = 'Intermediate';
//   String _badgesValue = '0';
//   String _pointsValue = '0';
//   String _progressValue = '0';
//   bool _statsLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _badgesFuture = ProfileRepository().fetchUserBadges();
//     _loadStats();
//   }

//   Future<void> _loadStats() async {
//     try {
//       final repo = ProfileRepository();
//       final profile = await repo.fetchProfile();

//       final resp = await ApiClient.instance.get<dynamic>(ApiEndpoints.authMeStats);
//       final statsMap = ResponseParser.extractMap(resp.data, const ['stats', 'data']) ??
//           ResponseParser.extractMap(resp.data, const ['data']) ??
//           <String, dynamic>{};

//       final totalPoints = ResponseParser.asInt(statsMap['totalPoints'] ?? statsMap['points'] ?? 0);
//       final inProgress = ResponseParser.asInt(statsMap['inProgressBadges'] ?? statsMap['badgesInProgress'] ?? 0);

//       final badges = await _badgesFuture;
//       final earnedCount = badges.where((b) => b.earned).length;

//       if (mounted) {
//         setState(() {
//           _riderLevel = profile?.skillLevel ?? 'Intermediate';
//           _badgesValue = earnedCount.toString().padLeft(2, '0');
//           _pointsValue = totalPoints.toString();
//           _progressValue = inProgress.toString();
//           _statsLoading = false;
//         });
//       }
//     } catch (_) {
//       if (mounted) setState(() => _statsLoading = false);
//     }
//   }

//   String _dateLabel(DateTime? date) {
//     if (date == null) return 'Locked';
//     final d = date.toLocal();
//     return 'Earned ${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.sizeOf(context).width;
//     final horizontalPadding = (screenWidth * 0.05).clamp(12.0, 24.0);

//     return Scaffold(
//       backgroundColor: const Color(0xFFEBF4FF),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // ── Banner header (full-bleed, no padding) ──
//               BannerHeadder(
//                 imagePath: 'assets/images/no-img.jpg',
//                 title: 'Badges & Achievements',
//                 subtitle: '',
//                 centerTitle: true,
//                 onBackTap: () => Navigator.pop(context),
//               ),

//               Padding(
//                 padding: EdgeInsets.fromLTRB(
//                   horizontalPadding, 20, horizontalPadding, 0,
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // ── Rider stats (level pill + stat cards) ──
//                     RiderStatsSection(
//                       riderLevel: 'Rider Level: $_riderLevel',
//                       badgesTitle: 'Total Badges',
//                       badgesValue: _statsLoading ? '...' : _badgesValue,
//                       pointsTitle: 'Total Points',
//                       pointsValue: _statsLoading ? '...' : _pointsValue,
//                       progressTitle: 'In Progress',
//                       progressValue: _statsLoading ? '...' : _progressValue,
//                     ),

//                     const SizedBox(height: 24),

//                     // ── Latest Achievement (full-width photo card) ──
//                     const LatestAchievementCard(),

//                     const SizedBox(height: 32),

//                     // ── Achievements horizontal section ──
//                     const AchievementsSection(),

//                     const SizedBox(height: 32),

//                     // ── Unlocked Badges grid (dynamic from API) ──
//                     _buildMyBadgesGrid(),

//                     const SizedBox(height: 32),

//                     // ── Leaderboard horizontal scroll ──
//                     const LeaderboardSection(),

//                     const SizedBox(height: 32),

//                     // ── Share button ──
//                     const ShareAchievementsButton(),

//                     const SizedBox(height: 32),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildMyBadgesGrid() {
//     return FutureBuilder<List<ProfileBadgeItem>>(
//       future: _badgesFuture,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(
//             child: Padding(
//               padding: EdgeInsets.symmetric(vertical: 20),
//               child: CircularProgressIndicator(strokeWidth: 2),
//             ),
//           );
//         }

//         final badges = snapshot.data ?? const <ProfileBadgeItem>[];
//         final earnedCount = badges.where((b) => b.earned).length;

//         if (badges.isEmpty) {
//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: const [
//               Text(
//                 'Unlocked Badges',
//                 style: TextStyle(
//                   fontFamily: 'Outfit',
//                   fontSize: 20,
//                   fontWeight: FontWeight.w600,
//                   color: Color(0xFF1C2B4A),
//                 ),
//               ),
//               SizedBox(height: 8),
//               Text(
//                 'No badges available yet',
//                 style: TextStyle(
//                   fontFamily: 'Outfit',
//                   fontSize: 13,
//                   color: Colors.black54,
//                 ),
//               ),
//             ],
//           );
//         }

//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Unlocked Badges',
//               style: TextStyle(
//                 fontFamily: 'Outfit',
//                 fontSize: 20,
//                 fontWeight: FontWeight.w600,
//                 color: Color(0xFF1C2B4A),
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               '$earnedCount earned',
//               style: const TextStyle(
//                 fontFamily: 'Outfit',
//                 fontSize: 13,
//                 fontWeight: FontWeight.w400,
//                 color: Colors.black54,
//               ),
//             ),
//             const SizedBox(height: 14),
//             GridView.builder(
//               itemCount: badges.length,
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 mainAxisSpacing: 12,
//                 crossAxisSpacing: 12,
//                 childAspectRatio: 1.55,
//               ),
//               itemBuilder: (context, index) {
//                 final badge = badges[index];
//                 return Opacity(
//                   opacity: badge.earned ? 1.0 : 0.5,
//                   child: Container(
//                     padding: const EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                       color: badge.earned
//                           ? const Color(0xFFFFF3E2)
//                           : const Color(0xFFF1F1F1),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Top row: icon + name
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Container(
//                               width: 32,
//                               height: 32,
//                               decoration: BoxDecoration(
//                                 color: badge.earned
//                                     ? const Color(0xFFF0DDAF)
//                                     : const Color(0xFFD9D9D9),
//                                 shape: BoxShape.circle,
//                               ),
//                               child: ClipOval(
//                                 child: badge.imageUrl.startsWith('http')
//                                     ? Image.network(
//                                         badge.imageUrl,
//                                         fit: BoxFit.cover,
//                                         errorBuilder: (_, __, ___) => Icon(
//                                           badge.earned
//                                               ? Icons.military_tech
//                                               : Icons.lock_outline,
//                                           size: 18,
//                                           color: const Color(0xFF666666),
//                                         ),
//                                       )
//                                     : Icon(
//                                         badge.earned
//                                             ? Icons.military_tech
//                                             : Icons.lock_outline,
//                                         size: 18,
//                                         color: const Color(0xFF666666),
//                                       ),
//                               ),
//                             ),
//                             const SizedBox(width: 8),
//                             Expanded(
//                               child: Text(
//                                 badge.name,
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                                 style: const TextStyle(
//                                   fontFamily: 'Outfit',
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.w600,
//                                   color: Color(0xFF1C2B4A),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),

//                         const SizedBox(height: 6),

//                         // Date label
//                         Padding(
//                           padding: const EdgeInsets.only(left: 40),
//                           child: Text(
//                             _dateLabel(badge.earnedAt),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                             style: const TextStyle(
//                               fontFamily: 'Outfit',
//                               fontSize: 10,
//                               fontWeight: FontWeight.w400,
//                               color: Color(0xFF5E5E5E),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
