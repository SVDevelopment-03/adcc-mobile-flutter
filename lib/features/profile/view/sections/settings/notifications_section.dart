import 'package:adcc/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class NotificationsSection extends StatelessWidget {
  final bool eventReminders;
  final bool communityUpdates;
  final bool newMessages;
  final bool achievements;
  final bool weeklyReport;

  final Function(bool) onEventRemindersChanged;
  final Function(bool) onCommunityUpdatesChanged;
  final Function(bool) onNewMessagesChanged;
  final Function(bool) onAchievementsChanged;
  final Function(bool) onWeeklyReportChanged;

  const NotificationsSection({
    super.key,
    required this.eventReminders,
    required this.communityUpdates,
    required this.newMessages,
    required this.achievements,
    required this.weeklyReport,
    required this.onEventRemindersChanged,
    required this.onCommunityUpdatesChanged,
    required this.onNewMessagesChanged,
    required this.onAchievementsChanged,
    required this.onWeeklyReportChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// TITLE
        const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Text(
              "Notifications",
              style: const TextStyle(
                fontFamily: 'Outfit',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                height: 1,
                letterSpacing: 0,
                color: AppColors.charcoal,
              ),
            )),

        /// CARD CONTAINER
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFe1ebfa),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              _SwitchTile(
                title: "Event Reminders",
                subtitle: "Get notified before events start",
                value: eventReminders,
                onChanged: onEventRemindersChanged,
              ),

              const Divider(height: 1),

              _SwitchTile(
                title: "Community Updates",
                subtitle: "New posts and announcements",
                value: communityUpdates,
                onChanged: onCommunityUpdatesChanged,
              ),

              const Divider(height: 1),

              _SwitchTile(
                title: "New Messages",
                subtitle: "Direct messages from riders",
                value: newMessages,
                onChanged: onNewMessagesChanged,
              ),

              // NOTE: `New Messages` toggle controls whether the user receives
              // real-time or push notifications for direct messages. Persist
              // this preference to the user's profile/notification settings
              // (e.g. call `ProfileService.updateProfile({'notifyNewMessages': true})`).

              const Divider(height: 1),

              _SwitchTile(
                title: "Achievements",
                subtitle: "When you unlock badges",
                value: achievements,
                onChanged: onAchievementsChanged,
              ),

              // const Divider(height: 1),

              // _SwitchTile(
              //   title: "Weekly Report",
              //   subtitle: "Your cycling activity summary.\n Coming soon!",
              //   value: weeklyReport,
              //   onChanged: onWeeklyReportChanged,
              // ),

              // NOTE: `Weekly Report` controls whether the app sends a weekly
              // summary email/push to the user. Persist under user notification
              // preferences (e.g. `weeklyReport: true`) so backend can schedule
              // or suppress weekly reports.
            ],
          ),
        ),
      ],
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final Function(bool) onChanged;

  const _SwitchTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 82.9,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            /// TEXT
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      height: 1,
                      letterSpacing: 0,
                      color: AppColors.charcoal,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      height: 1,
                      letterSpacing: 0,
                      color: Color(0xFF525252),
                    ),
                  )
                ],
              ),
            ),

            /// SWITCH
            Transform.scale(
              scale: 0.85,
              child: Switch(
                value: value,
                onChanged: onChanged,
                trackColor: MaterialStateProperty.resolveWith<Color>((states) {
                  if (states.contains(MaterialState.selected)) {
                    return const Color(0xFFC435873); // ON background color
                  }
                  return const Color(0xFFD1D5DC); // OFF background color
                }),
                thumbColor: MaterialStateProperty.all(Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
