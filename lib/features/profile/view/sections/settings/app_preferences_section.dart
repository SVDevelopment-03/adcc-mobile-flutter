import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class AppPreferencesSection extends StatelessWidget {
  final bool darkMode;
  final Function(bool) onDarkModeChanged;
  final VoidCallback onLanguageTap;

  const AppPreferencesSection({
    super.key,
    required this.darkMode,
    required this.onDarkModeChanged,
    required this.onLanguageTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.app_preferences,
          style: const TextStyle(
            fontFamily: 'Outfit',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            height: 1.43,
            letterSpacing: -0.22,
            color: AppColors.charcoal,
          ),
        ),

        const SizedBox(height: 8),

        /// FIRST CARD
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFEAE7FF),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              _ArrowTile(
                image: "assets/icons/language.png",
                title: AppLocalizations.of(context)!.language,
                subtitle: AppLocalizations.of(context)!.english,
                onTap: onLanguageTap,
              ),

              const Divider(height: 1),

              _ArrowTile(
                image: "assets/icons/units.png",
                title: AppLocalizations.of(context)!.units,
                subtitle: AppLocalizations.of(context)!.metricComingSoon,
              ),

              // NOTE: `Units` is an app-level preference (metric/imperial).
              // This is typically saved locally (SharedPreferences) and used
              // to format distances/weights in the UI. If you want server-side
              // persistence, send the selected unit to the backend on update.

              // const Divider(height: 1),

              // _ArrowTile(
              //   image: "assets/icons/distance.png",
              //   title: "Map Style",
              //   subtitle: "Standard \nComing soon!",
              // ),

              // NOTE: `Map Style` is a client-side preference (map tiles/theme).
              // Save locally for immediate effect. If the backend needs to
              // provide per-user map settings, persist this to the user's
              // profile (e.g. `mapStyle: 'standard'`).

              const Divider(height: 1),

              _SwitchTile(
                image: "assets/icons/dark_mode.png",
                title: AppLocalizations.of(context)!.darkMode,
                subtitle: AppLocalizations.of(context)!.comingSoon,
                value: darkMode,
                onChanged: onDarkModeChanged,
              ),
            ],
          ),
        ),

        const SizedBox(height: 39),

        /// SECOND TITLE
        Text(
          AppLocalizations.of(context)!.rideGuidelinesEtiquette,
          style: const TextStyle(
            fontFamily: 'Outfit',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            height: 1.43,
            letterSpacing: -0.22,
            color: AppColors.charcoal,
          ),
        ),

        const SizedBox(height: 8),

        /// SECOND CARD
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFEAE7FF),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              _SimpleTile(title: AppLocalizations.of(context)!.helpCenterComingSoon),
              const Divider(height: 1),
              _SimpleTile(title: AppLocalizations.of(context)!.termsConditionsComingSoon),
              const Divider(height: 1),
              _SimpleTile(title: AppLocalizations.of(context)!.privacyPolicyComingSoon),
              const Divider(height: 1),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.app_version,
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.charcoal,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        AppLocalizations.of(context)!.app_version_value,
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFFA3A3A3),
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ],
    );
  }
}

class _ArrowTile extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _ArrowTile({
    required this.image,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final content = SizedBox(
      height: 82.9,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Image.asset(
              image,
              width: 20,
              height: 20,
            ),
            const SizedBox(width: 14),
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
                        color: AppColors.charcoal),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      height: 1,
                      letterSpacing: 0,
                      color: Color(0XFF525252),
                    ),
                  )
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: Colors.black54,
            ),
          ],
        ),
      ),
    );

    if (onTap == null) {
      return content;
    }

    return GestureDetector(
      onTap: onTap,
      child: content,
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;
  final bool value;
  final Function(bool) onChanged;

  const _SwitchTile({
    required this.image,
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
            Image.asset(
              image,
              width: 20,
              height: 20,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            Transform.scale(
              scale: 0.85,
              child: Switch(
                value: value,
                onChanged: onChanged,
                trackColor: MaterialStateProperty.resolveWith<Color>((states) {
                  if (states.contains(MaterialState.selected)) {
                    return const Color(0xFF5257B5); // ON background color
                  }
                  return const Color(0xFFD1D5DC);
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

class _SimpleTile extends StatelessWidget {
  final String title;

  const _SimpleTile({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 15,
              fontWeight: FontWeight.w400,
              height: 1,
              letterSpacing: 0,
              color: Color(0xFF525252),
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            size: 14,
            color: Colors.black54,
          ),
        ],
      ),
    );
  }
}
