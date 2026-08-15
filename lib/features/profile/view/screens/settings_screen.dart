import 'package:adcc/core/constants/cosmatic_imgs.dart';
import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/features/languageOption/view/languageSelectionScreen.dart';
import 'package:adcc/features/profile/view/sections/settings/account_section.dart';
import 'package:adcc/features/profile/view/sections/settings/app_preferences_section.dart';
import 'package:adcc/features/profile/view/sections/settings/notifications_section.dart';
import 'package:adcc/features/profile/view/sections/settings/privacy_section.dart';
import 'package:adcc/core/utils/image_source.dart';
import 'package:adcc/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool eventReminders = true;
  bool communityUpdates = true;
  bool newMessages = true;
  bool achievements = true;
  bool weeklyReport = false;

  bool publicProfile = true;
  bool showStatistics = true;
  bool shareLocation = false;
  bool activitySharing = true;

  bool darkMode = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final horizontalPadding = (screenWidth * 0.05).clamp(12.0, 24.0);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.settings_and_preferences_title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Outfit',
            color: AppColors.charcoal,
            fontWeight: FontWeight.w600,
            fontSize: 22,
            height: 1,
            letterSpacing: 0,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              height: 40,
              width: 40,
              decoration: const BoxDecoration(
                color: Color(0xffFFFFFF),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Color(0xFF5257B5),
                size: 20,
              ),
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: resolveImageProvider(ProfileImgs.profileBackground),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          padding:
              EdgeInsets.fromLTRB(horizontalPadding, 24, horizontalPadding, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AccountSection(),
              const SizedBox(height: 40),
              NotificationsSection(
                eventReminders: eventReminders,
                communityUpdates: communityUpdates,
                newMessages: newMessages,
                achievements: achievements,
                weeklyReport: weeklyReport,
                onEventRemindersChanged: (v) =>
                    setState(() => eventReminders = v),
                onCommunityUpdatesChanged: (v) =>
                    setState(() => communityUpdates = v),
                onNewMessagesChanged: (v) => setState(() => newMessages = v),
                onAchievementsChanged: (v) => setState(() => achievements = v),
                onWeeklyReportChanged: (v) => setState(() => weeklyReport = v),
              ),
              // const SizedBox(height: 40),
              PrivacySection(
                publicProfile: publicProfile,
                showStatistics: showStatistics,
                shareLocation: shareLocation,
                activitySharing: activitySharing,
                onPublicProfileChanged: (v) =>
                    setState(() => publicProfile = v),
                onShowStatisticsChanged: (v) =>
                    setState(() => showStatistics = v),
                onShareLocationChanged: (v) =>
                    setState(() => shareLocation = v),
                onActivitySharingChanged: (v) =>
                    setState(() => activitySharing = v),
              ),
              const SizedBox(height: 39),
              AppPreferencesSection(
                darkMode: darkMode,
                onDarkModeChanged: (v) => setState(() => darkMode = v),
                onLanguageTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => LanguageSelectionScreen(
                        onLanguageSelected: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
