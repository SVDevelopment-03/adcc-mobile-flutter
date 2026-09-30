import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/features/auth/view/communityScreen/auth_action_card.dart';
import 'package:adcc/features/auth/view/communityScreen/social_button.dart';
import 'package:adcc/features/auth/view/registrationScreen/create_account.dart';
import 'package:adcc/l10n/app_localizations.dart';
import 'package:adcc/shared/widgets/app_button.dart';
import 'package:adcc/shared/widgets/app_header_login.dart';
import 'package:flutter/material.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  String communityType = "";

  void _createAccount() {
    if (communityType == "phone" || communityType == "email") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const CreateAccountScreen()),
      );
    } else {
      debugPrint('No auth type selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFFF6EC), Color(0xFFEAF4FF)],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                AppHeaderLogin(
                  onBack: () {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  },
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        /// Logo
                        Image.asset('assets/icons/adcc_logo.png', height: 80),
                        const SizedBox(height: 60),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 150,
                                height: 25,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color.fromARGB(255, 255, 250, 243),
                                      Color.fromARGB(255, 246, 226, 192),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                  height: 1.4,
                                ),
                                children: [
                                  TextSpan(
                                    text:
                                        '${l10n.community_heading1.toUpperCase()}\n',
                                  ),
                                  TextSpan(
                                    text: l10n.community_heading2.toUpperCase(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 40),

                        AuthActionCard(
                          title: l10n.phone_action_card,
                          iconPath: 'assets/icons/phone_Icon.png',
                          onTap: () {
                            debugPrint('Phone clicked');
                            setState(() {
                              communityType = "phone";
                            });
                          },
                          selected: communityType == "phone" ? true : false,
                        ),
                        const SizedBox(height: 16),

                        AuthActionCard(
                          title: l10n.email_action_card,
                          iconPath: 'assets/icons/email_Icon.png',
                          onTap: () {
                            debugPrint('Email clicked');
                            setState(() {
                              communityType = "email";
                            });
                          },
                          selected: communityType == "email" ? true : false,
                        ),

                        const SizedBox(height: 24),

                        /// Create Account Button
                        AppButton(
                          label: l10n.create_button.toUpperCase(),
                          backgroundColor: AppColors.orange,
                          borderRadius: 16,
                          onPressed: _createAccount,
                          enabled: communityType != "" ? true : false,
                        ),

                        const SizedBox(height: 24),

                        /// Or sign in with
                        Text(
                          l10n.sign_in_option,
                          style: const TextStyle(fontSize: 14),
                        ),

                        const SizedBox(height: 16),

                        /// Social Buttons
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SocialButton(
                              imagePath: "assets/icons/apple_icon.png",
                            ),
                            SizedBox(width: 20),
                            SocialButton(
                              imagePath: "assets/icons/google_icon.png",
                            ),
                            SizedBox(width: 20),
                            SocialButton(
                              imagePath: "assets/icons/facebook_icon.png",
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                  child: Text(
                    l10n.policy,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
