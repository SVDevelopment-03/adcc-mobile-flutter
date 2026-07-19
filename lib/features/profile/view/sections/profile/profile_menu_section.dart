import 'package:adcc/features/events/sections/my_upcoming_event_calendar.dart';
import 'package:adcc/features/profile/view/screens/badges_achievement.screen.dart';
import 'package:adcc/features/profile/view/screens/cycling_details_screen.dart';

import 'package:adcc/features/profile/view/screens/my_challenges_screen.dart';
import 'package:adcc/features/profile/view/screens/rewards_point_screen.dart';
import 'package:adcc/features/profile/view/screens/settings_screen.dart';
import 'package:flutter/material.dart';

class ProfileMenuSection extends StatelessWidget {
  const ProfileMenuSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFF2F6FC),
          borderRadius: BorderRadius.circular(17.5168),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2E3176).withValues(alpha: 0.10),
              offset: const Offset(0, 4.38),
              blurRadius: 30.65,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 21.8945),
          child: Column(
            children: [
              const SizedBox(height: 12),
              _MenuItem(
                assetIcon: 'assets/images/my-event.gif',
                title: 'My Events & Calendar',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const MyUpcomingeventfrom(events: []),
                    ),
                  );
                },
              ),
              const _Divider(),
              _MenuItem(
                // assetIcon: "assets/images/Badges.gif",
                  icon: Icons.military_tech_rounded,
                title: 'Badges & achievements',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const BadgesAchievementsScreen(),
                    ),
                  );
                },
              ),
              const _Divider(),
              _MenuItem(
                // icon: Icons.pedal_bike_rounded,
                 assetIcon: "assets/images/cycilist.gif",
                title: 'My Challenges',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const MyChallengesScreen(),
                    ),
                  );
                },
              ),
              const _Divider(),
              _MenuItem(
                icon: Icons.directions_bike_rounded,
                //  assetIcon: "assets/images/cycilist.gif",
                title: 'My Cycling Details',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const CyclingDetailsScreen(),
                    ),
                  );
                },
              ),
              const _Divider(),
              _MenuItem(
                // icon: Icons.military_tech_rounded,
                 assetIcon: "assets/images/Medal.gif",
                title: 'Rewards and points',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const RewardsPointsScreen(),
                    ),
                  );
                },
              ),
              const _Divider(),
              _MenuItem(
                // icon: Icons.settings_rounded,
                 assetIcon: "assets/images/Settings.gif",
                title: 'Settings & preferences',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SettingsScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData? icon;
  final String? assetIcon;
  final String title;
  final VoidCallback? onTap;

  const _MenuItem({
    this.icon,
    this.assetIcon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: 52.5505,
          child: Row(
            children: [
              SizedBox(
                width: 30,
                height: 30,
                child: assetIcon != null
                    ? Image.asset(
                        assetIcon!,
                        width: 24,
                        height: 24,
                        fit: BoxFit.contain,
                      )
                    : Icon(
                        icon,
                        // color: const Color(0xFF0359E8),
                        size: 24,
                      ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 13.1376,
                    fontWeight: FontWeight.w600,
                    height: 17 / 13.1376,
                    letterSpacing: 0.13,
                    color: Color(0xFF333333),
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                size: 22,
                color: Color(0xFF333333),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      color: const Color(0xFF333333).withValues(alpha: 0.10),
    );
  }
}
