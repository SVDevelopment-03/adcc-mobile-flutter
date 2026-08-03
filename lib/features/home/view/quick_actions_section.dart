import 'package:adcc/core/constants/cosmatic_imgs.dart';
import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/features/communities/view/community_screen.dart';
import 'package:adcc/features/home/view/quick_action_item.dart';
import 'package:adcc/features/store/view/Screen/store_screen.dart';
import 'package:adcc/features/routes/view/routes_screen_wrapper.dart';
import 'package:adcc/features/events/view/events_screen.dart';
import 'package:adcc/features/ride_feed/view/ride_feed_screen.dart';
import 'package:adcc/features/my_cycling_details/view/my_cycling_details_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:adcc/features/challenges/view/leaderboard_screen.dart';

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
        const Text(
          'Quick Actions',
          style: TextStyle(
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
              title: 'Community',
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
              title: 'Tracks',
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
              title: 'Challenges',
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
              title: 'Events',
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
              title: 'Marketplace',
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
              title: 'Bike Experience',
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
              title: 'Ride Feed',
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
              title: 'Club Store',
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
