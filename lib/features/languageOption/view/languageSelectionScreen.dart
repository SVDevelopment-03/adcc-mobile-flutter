import 'package:adcc/core/services/language_storage_service.dart';
import 'package:adcc/core/services/token_storage_service.dart';
import 'package:adcc/features/onboarding/view/onboarding_screen.dart';
import 'package:adcc/features/home/view/home_screen.dart';
import 'package:adcc/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
// video player removed — background uses images only
import 'package:cached_network_image/cached_network_image.dart';

import '../../../main.dart';
import 'package:adcc/core/services/lookup_service.dart';

class LanguageSelectionScreen extends StatefulWidget {
  final VoidCallback? onLanguageSelected;

  const LanguageSelectionScreen({
    super.key,
    this.onLanguageSelected,
  });

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  static final Uri _backgroundVideoUrl = Uri.parse(
    'https://adcc-frontend.s3.amazonaws.com/event+-+F1.mp4',
  );

  String _selected = 'en';
  // No video controller — use static image background

  @override
  void initState() {
    super.initState();
    _loadSaved();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadSaved() async {
    final saved = await LanguageStorageService.getLocaleCode();
    if (!mounted || saved == null) return;
    setState(() => _selected = saved);
  }

  Future<void> _continue() async {
    await LanguageStorageService.setLocaleCode(_selected);
    if (!mounted) return;
    // Trigger app locale change
    MyApp.setLocale(context, Locale(_selected));

    // Clear lookup cache so localized lookup labels reload for the new language
    LookupService.instance.clearCache();
    if (widget.onLanguageSelected != null) {
      widget.onLanguageSelected!();
      return;
    }

    // Check if user is authenticated
    final isAuthenticated = await TokenStorageService.isAuthenticated();
    if (!mounted) return;

    if (isAuthenticated) {
      // User is logged in, go to home screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      // User is not logged in, go to onboarding (login)
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
    }
  }
// Replace ONLY your build() method UI with this design.
// Keep your existing logic, variables, video controller, and functions same.

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          /// BACKGROUND (cached)
          SizedBox.expand(
            child: CachedNetworkImage(
              imageUrl:
                  'https://projet-adcc-image.s3.me-central-1.amazonaws.com/content/image-3503-1787384811352-b0e717035381.png',
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.black.withOpacity(0.05),
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFF494949)),
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Image.asset(
                'assets/images/onboarding33.png',
                fit: BoxFit.cover,
              ),
            ),
          ),

          /// DARK OVERLAY
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.15),
                  Colors.black.withOpacity(0.55),
                ],
              ),
            ),
          ),

          /// MAIN CONTENT
          SafeArea(
            child: Column(
              children: [
                const Spacer(),

                /// TITLE
                Text(
                  AppLocalizations.of(context)!.choose_your_language,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.2,
                    letterSpacing: 0.3,
                  ),
                ),

                const SizedBox(height: 28),

                /// BOTTOM CONTAINER
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 14),
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                        "https://projet-adcc-image.s3.me-central-1.amazonaws.com/content/Choose-your-language-bg-1785911727899-a9ef1e4888eb.png",
                      ),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(26),
                      topRight: Radius.circular(26),
                    ),
                  ),
                  child: Column(
                    children: [
                      /// ENGLISH TILE
                      _newLanguageTile(
                        title: AppLocalizations.of(context)!
                            .language_label_english,
                        flag: "assets/images/en-country.png",
                        selected: _selected == 'en',
                        onTap: () {
                          setState(() {
                            _selected = 'en';
                          });
                        },
                      ),

                      const SizedBox(height: 14),

                      /// ARABIC TILE
                      _newLanguageTile(
                        title:
                            AppLocalizations.of(context)!.language_label_arabic,
                        flag: "assets/images/ar-country.png",
                        selected: _selected == 'ar',
                        onTap: () {
                          setState(() {
                            _selected = 'ar';
                          });
                        },
                      ),

                      const SizedBox(height: 42),

                      /// CONTINUE BUTTON
                      GestureDetector(
                        onTap: _continue,
                        child: Container(
                          height: 58,
                          decoration: BoxDecoration(
                            color: const Color(0xFF4A6487),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Center(
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .continue_button,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),

                              /// ARROW BOX
                              Container(
                                width: 45,
                                height: 45,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 22,
                                  color: Color(0xFF4A6487),
                                ),
                              ),
                              SizedBox(width: 8)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// NEW LANGUAGE TILE
  Widget _newLanguageTile({
    required String title,
    required String flag,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: selected ? Colors.white : const Color(0xFFC8CDD6),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? const Color(0xFF5A6B84) : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            /// FLAG
            Image.asset(
              flag,
              width: 28,
              height: 28,
            ),

            const SizedBox(width: 14),

            /// TITLE
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF3C3C3C),
                ),
              ),
            ),

            /// RADIO BUTTON
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? const Color(0xFFE54545) : Colors.grey,
                  width: 1.5,
                ),
              ),
              child: selected
                  ? Center(
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFE54545),
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
