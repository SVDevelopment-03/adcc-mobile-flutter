import 'package:adcc/core/constants/cosmatic_imgs.dart';
import 'package:adcc/features/profile/view/sections/badges/rider_level_section.dart';
import 'package:adcc/features/profile/view/sections/reward_point/available_points_section.dart';
import 'package:adcc/features/profile/view/sections/reward_point/available_rewards_section.dart';
import 'package:adcc/shared/widgets/banner_header.dart';
import 'package:adcc/features/profile/repositories/profile_repository.dart';
import 'package:adcc/core/constants/api_endpoints.dart';
import 'package:adcc/core/services/api_client.dart';
import 'package:adcc/core/utils/response_parser.dart';
import 'package:adcc/core/utils/image_source.dart';
import 'package:adcc/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class RewardsPointsScreen extends StatelessWidget {
  const RewardsPointsScreen({super.key});

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
              padding: EdgeInsets.fromLTRB(
                  horizontalPadding, 16, horizontalPadding, 20),
              child: SafeArea(
                  child: SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                    BannerHeadder(
                      imagePath: 'assets/images/rewards-points-bg.jpg',
                      title: AppLocalizations.of(context)!.rewards_and_points,
                      subtitle: AppLocalizations.of(context)!.earn_points_subtitle,
                      centerTitle: true,
                      onBackTap: () => Navigator.pop(context),
                    ),
                    const SizedBox(height: 28),
                    FutureBuilder<Map<String, String>>(
                      future: _fetchRewardsStats(),
                      builder: (context, snapshot) {
                        final data = snapshot.data ?? {};
                        final riderLevel = data['riderLevel'] ?? 'Intermediate';
                        final earned = data['earnedThisMonth'] ?? '0';
                        final total = data['totalPoints'] ?? '0';
                        final tier = data['currentTier'] ?? 'Bronze';

                        return RiderStatsSection(
                          riderLevel: '${AppLocalizations.of(context)!.riderLevel}: $riderLevel',
                          badgesTitle: AppLocalizations.of(context)!.earned_this_month,
                          badgesValue: snapshot.connectionState ==
                                  ConnectionState.waiting
                              ? '...'
                              : earned,
                          pointsTitle: AppLocalizations.of(context)!.reward_claimed,
                          pointsValue: snapshot.connectionState ==
                                  ConnectionState.waiting
                              ? '...'
                              : total,
                          progressTitle: AppLocalizations.of(context)!.current_tier,
                          progressValue: snapshot.connectionState ==
                                  ConnectionState.waiting
                              ? '...'
                              : tier,
                        );
                      },
                    ),
                    const SizedBox(height: 30),
                    const AvailablePointsSection(),
                    const SizedBox(height: 40),
                    const AvailableRewardsSection(),
                  ]))))),
    );
  }
}

Future<Map<String, String>> _fetchRewardsStats() async {
  try {
    final repo = ProfileRepository();
    final profile = await repo.fetchProfile();
    final resp =
        await ApiClient.instance.get<dynamic>(ApiEndpoints.authMeStats);
    final statsMap = ResponseParser.extractMap(resp.data, const ['data']) ??
        ResponseParser.extractMap(resp.data, const ['stats', 'data']) ??
        <String, dynamic>{};

    final earnedThisMonth = (statsMap['pointsThisMonth'] ??
                statsMap['monthPoints'] ??
                statsMap['earnedThisMonth'])
            ?.toString() ??
        '0';
    final totalPoints =
        (statsMap['totalPoints'] ?? statsMap['points'] ?? 0).toString();
    final currentTier =
        (statsMap['tier'] ?? statsMap['currentTier'] ?? 'Bronze').toString();

    return {
      'riderLevel': profile?.skillLevel ?? 'Intermediate',
      'earnedThisMonth': earnedThisMonth,
      'totalPoints': totalPoints,
      'currentTier': currentTier,
    };
  } catch (_) {
    return {
      'riderLevel': 'Intermediate',
      'earnedThisMonth': '0',
      'totalPoints': '0',
      'currentTier': 'Bronze',
    };
  }
}
