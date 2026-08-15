import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/features/communities/view/community_screen.dart';
import 'package:adcc/features/home/view/quick_action_item.dart';
import 'package:adcc/features/store/view/Screen/store_screen.dart';
import 'package:adcc/features/routes/view/routes_screen_wrapper.dart';
import 'package:adcc/features/events/view/events_screen.dart';
import 'package:adcc/features/ride_feed/view/ride_feed_screen.dart';
import 'package:flutter/material.dart';
import 'package:adcc/features/challenges/view/leaderboard_screen.dart';
import 'package:adcc/l10n/app_localizations.dart';

import '../../club_store/view/marchindies_screen.dart';
import '../../profile/view/screens/cycling_details_screen.dart';

class QuickActionsSection extends StatelessWidget {
  final ValueChanged<int>? onTabChange;
  final bool fromGuest;
  final VoidCallback? onGuestRestrictedTap;

  const QuickActionsSection({
    super.key,
    this.onTabChange,
    this.fromGuest = false,
    this.onGuestRestrictedTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Text(
          AppLocalizations.of(context)!.quickActions,
          style: const TextStyle(
            fontFamily: 'Outfit',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            height: 1, // 100% line height
            letterSpacing: 0,
            color: AppColors.textDark,
          ),
        ),
        // const SizedBox(height: 21),
        GridView.count(
          crossAxisCount: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 79 / 108,
          mainAxisSpacing: 11,
          crossAxisSpacing: 8,
          padding: const EdgeInsets.only(top: 21),
          children: [
            QuickActionItem(
              title: AppLocalizations.of(context)!.community,
              imagePath: 'assets/images/community.png',
              iconSize: 31.86,
              onTap: () {
                // Switch to Communities tab (index 2) when possible so the home bottom bar remains visible.
                if (onTabChange != null) {
                  onTabChange!(2);
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CommunitiesScreen(),
                    ),
                  );
                }
              },
            ),
            QuickActionItem(
              title: AppLocalizations.of(context)!.tracks,
              imagePath: 'assets/icons/tracks.gif',
              iconSize: 38.57,
              onTap: () {
                // Switch to Routes tab (index 3) instead of pushing new screen
                if (onTabChange != null) {
                  onTabChange!(3);
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const RoutesScreenWrapper(),
                    ),
                  );
                }
              },
            ),
            QuickActionItem(
              title: AppLocalizations.of(context)!.challenges,
              imagePath: 'assets/icons/challenges.gif',
              iconSize: 37.73,
              onTap: () {
                if (fromGuest) {
                  onGuestRestrictedTap?.call();
                  return;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    // builder: (_) => const ChallengesScreen(),
                    builder: (_) => const LeaderboardScreen(),
                  ),
                );
              },
            ),
            QuickActionItem(
              title: AppLocalizations.of(context)!.eventsTab,
              imagePath: 'assets/icons/events_calender.gif',
              iconSize: 31.86,
              onTap: () {
                // Switch to Events tab (index 1) instead of pushing new screen
                if (onTabChange != null) {
                  onTabChange!(1);
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const EventsScreen(),
                    ),
                  );
                }
              },
            ),
            QuickActionItem(
              title: AppLocalizations.of(context)!.marketplace,
              imagePath: 'assets/images/store.png',
              iconSize: 29.35,
              onTap: () {
                if (fromGuest) {
                  onGuestRestrictedTap?.call();
                  return;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const StoreScreen(),
                  ),
                );
              },
            ),
            QuickActionItem(
              title: AppLocalizations.of(context)!.bikeExperience,
              imagePath: 'assets/icons/bike_experience.gif',
              iconSize: 32.87,
              onTap: () {
                if (fromGuest) {
                  onGuestRestrictedTap?.call();
                  return;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CyclingDetailsScreen(),
                  ),
                );
              },
            ),
            QuickActionItem(
              title: AppLocalizations.of(context)!.rideFeed,
              imagePath: 'assets/images/quick_action_ride_feed.png',
              iconSize: 42,
              onTap: () {
                if (fromGuest) {
                  onGuestRestrictedTap?.call();
                  return;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RideFeedScreen(),
                  ),
                );
              },
            ),
            QuickActionItem(
              title: AppLocalizations.of(context)!.clubStore,
              imagePath: 'assets/images/quick_action_merchandise.png',
              iconSize: 38,
              iconOffsetY: -3,
              onTap: () {
                if (fromGuest) {
                  onGuestRestrictedTap?.call();
                  return;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ClubStoreMarchindiesScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
