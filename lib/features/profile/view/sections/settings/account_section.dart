import 'package:adcc/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:adcc/features/profile/view/screens/edit_profile_screen.dart';

class AccountSection extends StatelessWidget {
  const AccountSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// TITLE
        const Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text(
              "Account",
              style: const TextStyle(
                fontFamily: 'Outfit',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                height: 1,
                letterSpacing: 0,
                color: Color(0xFF333333),
              ),
            )),

        /// CARD
        Container(
          width: double.infinity,
          // height: 235,
          decoration: BoxDecoration(
            color: const Color(0xFFe1ebfa),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => EditProfileScreen(),
                    ),
                  );
                },
                child: _AccountTile(
                  image: "assets/icons/edit_profile.png",
                  title: "Edit Profile",
                  subtitle: "Update your personal information",
                ),
              ),

              // Divider(height: 1, thickness: 0.6),

              // _AccountTile(
              //   image: "assets/icons/cycling_preferences.png",
              //   title: "Cycling Preferences",
              //   subtitle: "Set your riding style & goals",
              // ),

              // Divider(height: 1, thickness: 0.6),

              // _AccountTile(
              //   image: "assets/icons/distance.png",
              //   title: "Emergency Contacts",
              //   subtitle: "Manage safety contacts",
              // ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AccountTile extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;

  const _AccountTile({
    required this.image,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            /// IMAGE ICON
            Image.asset(
              image,
              width: 22,
              height: 22,
              fit: BoxFit.contain,
            ),

            const SizedBox(width: 14),

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
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        height: 1,
                        letterSpacing: 0,
                        color: AppColors.charcoal),
                  ),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: const TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 1,
                        letterSpacing: 0,
                        color: Color(0XFF525252),
                      ))
                ],
              ),
            ),

            /// ARROW
            const Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: Colors.black54,
            ),
          ],
        ),
      ),
    );
  }
}
