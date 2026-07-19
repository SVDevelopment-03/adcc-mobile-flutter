import 'package:adcc/core/services/language_storage_service.dart';
import 'package:adcc/features/onboarding/view/onboarding_screen.dart';
import 'package:adcc/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../../main.dart';

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
  late final VideoPlayerController _videoController;
  bool _videoFailed = false;

  @override
  void initState() {
    super.initState();
    _initVideo();
    _loadSaved();
  }

  Future<void> _initVideo() async {
    _videoController = VideoPlayerController.networkUrl(_backgroundVideoUrl);
    try {
      await _videoController.initialize();
      if (!mounted) return;
      await _videoController.setLooping(true);
      await _videoController.setVolume(0);
      await _videoController.play();
      setState(() {});
    } catch (_) {
      if (!mounted) return;
      setState(() => _videoFailed = true);
    }
  }

  @override
  void dispose() {
    _videoController.dispose();
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
    MyApp.setLocale(context, Locale(_selected));
    if (widget.onLanguageSelected != null) {
      widget.onLanguageSelected!();
      return;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const OnboardingScreen()),
    );
  }
// Replace ONLY your build() method UI with this design.
// Keep your existing logic, variables, video controller, and functions same.

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          /// BACKGROUND
          SizedBox.expand(
            child: _videoController.value.isInitialized && !_videoFailed
                ? FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _videoController.value.size.width,
                      height: _videoController.value.size.height,
                      child: VideoPlayer(_videoController),
                    ),
                  )
                : Image.asset(
                    "assets/images/onboarding33.png",
                    fit: BoxFit.cover,
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
                const Text(
                  "CHOOSE YOUR\nLANGUAGE",
                  textAlign: TextAlign.center,
                  style: TextStyle(
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
                  decoration: const BoxDecoration(
                    color: Color(0xFFD9E2F2),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(26),
                      topRight: Radius.circular(26),
                    ),
                  ),
                  child: Column(
                    children: [
                      /// ENGLISH TILE
                      _newLanguageTile(
                        title: "ENGLISH",
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
                        title: "ARABIC",
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
                              const Expanded(
                                child: Center(
                                  child: Text(
                                    "Continue",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),

                              /// ARROW BOX
                              Container(
                                padding: EdgeInsets.all(5),
                                width: 58,
                                height: 58,
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
