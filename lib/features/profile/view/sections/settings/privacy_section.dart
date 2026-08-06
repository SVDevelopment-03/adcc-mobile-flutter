import 'package:adcc/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

// PrivacySection
//
// Controls user privacy and cycling-related preferences. These toggles map to
// fields stored on the user profile (server-side) so they can be honored
// across devices and by backend features (e.g., feed sharing, public stats):
// - `publicProfile` -> whether other users can view the profile
// - `showStatistics` -> whether cycling stats are visible
// - `shareLocation` -> share user's city/location metadata
// - `activitySharing` -> auto-share completed rides to feed
// Persist changes using `ProfileService.updateProfile({...})`.
class PrivacySection extends StatelessWidget {
  final bool publicProfile;
  final bool showStatistics;
  final bool shareLocation;
  final bool activitySharing;

  final Function(bool) onPublicProfileChanged;
  final Function(bool) onShowStatisticsChanged;
  final Function(bool) onShareLocationChanged;
  final Function(bool) onActivitySharingChanged;

  const PrivacySection({
    super.key,
    required this.publicProfile,
    required this.showStatistics,
    required this.shareLocation,
    required this.activitySharing,
    required this.onPublicProfileChanged,
    required this.onShowStatisticsChanged,
    required this.onShareLocationChanged,
    required this.onActivitySharingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// TITLE
        // const Padding(
        //     padding: EdgeInsets.only(bottom: 8),
        //     child: Text(
        //       "Privacy",
        //       style: const TextStyle(
        //         fontFamily: 'Outfit',
        //         fontSize: 20,
        //         fontWeight: FontWeight.w700,
        //         height: 1.43,
        //         letterSpacing: -0.22,
        //         color: AppColors.charcoal,
        //       ),
        //     )),

        // /// CARD CONTAINER
        // Container(
        //   width: double.infinity,
        //   decoration: BoxDecoration(
        //     color: const Color(0xFFFFEFD7),
        //     borderRadius: BorderRadius.circular(16),
        //   ),
        //   child: Column(
        //     children: [
        //       _SwitchTile(
        //         title: "Public Profile",
        //         subtitle: "Others can view your profile",
        //         value: publicProfile,
        //         onChanged: onPublicProfileChanged,
        //       ),
        //       const Divider(height: 1),
        //       _SwitchTile(
        //         title: "Show Statistics",
        //         subtitle: "Display your cycling stats",
        //         value: showStatistics,
        //         onChanged: onShowStatisticsChanged,
        //       ),
        //       const Divider(height: 1),
        //       _SwitchTile(
        //         title: "Share Location",
        //         subtitle: "Share your city with others",
        //         value: shareLocation,
        //         onChanged: onShareLocationChanged,
        //       ),
        //       const Divider(height: 1),
        //       _SwitchTile(
        //         title: "Activity Sharing",
        //         subtitle: "Auto-share completed rides",
        //         value: activitySharing,
        //         onChanged: onActivitySharingChanged,
        //       ),
        //     ],
        //   ),
        // ),
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
                activeTrackColor: const Color(0xFFC12D32),
                inactiveTrackColor: const Color(0xFFD1D5DC),
                thumbColor: MaterialStateProperty.all(Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
