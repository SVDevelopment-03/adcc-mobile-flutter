import 'package:adcc/features/auth/view/registrationScreen/create_account.dart';
import 'package:adcc/features/onboarding/models/onboarding_slide_model.dart';
import 'package:adcc/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _autoSlideTimer;
  // TODO: Toggle to enable/disable onboarding auto-scroll. Set to `true` to re-enable.
  static const bool _enableAutoSlide = false;

  static const String _onboardingImageUrl1 =
      'https://projet-adcc-image.s3.me-central-1.amazonaws.com/content/Onboarding-Screen-1-1787310981397-7fae67a32f4b.png';
  static const String _onboardingImageUrl2 =
      'https://projet-adcc-image.s3.me-central-1.amazonaws.com/content/Onboarding-Screen-2-1787311233214-6befb25d22da.png';
  static const String _onboardingImageUrl3 =
      'https://projet-adcc-image.s3.me-central-1.amazonaws.com/content/Onboarding-Screen-3-1785911975941-6c98b1ff307e.png';
  static const String _onboardingImageUrl4 =
      'https://projet-adcc-image.s3.me-central-1.amazonaws.com/content/Onboarding-Screen-4-1787311331918-c77a4685a89b.png';

  @override
  void initState() {
    super.initState();
    if (_enableAutoSlide) _startAutoSlide();
  }

  List<OnboardingSlideModel> _buildSlides(AppLocalizations l10n) {
    return [
      OnboardingSlideModel(
        title: l10n.onboardingTitle1,
        description: l10n.onboardingDesc1,
        buttonText: l10n.next,
        imagePath: _onboardingImageUrl1,
      ),
      OnboardingSlideModel(
        title: l10n.onboardingTitle2,
        description: l10n.onboardingDesc2,
        buttonText: l10n.next,
        imagePath: _onboardingImageUrl2,
      ),
      OnboardingSlideModel(
        title: l10n.onboardingTitle3,
        description: l10n.onboardingDesc3,
        buttonText: l10n.next,
        imagePath: _onboardingImageUrl3,
      ),
      OnboardingSlideModel(
        title: l10n.onboardingTitle4,
        description: l10n.onboardingDesc4,
        buttonText: l10n.getStarted,
        imagePath: _onboardingImageUrl4,
      ),
    ];
  }

  void _startAutoSlide() {
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      final slides = _buildSlides(AppLocalizations.of(context)!);
      if (slides.isEmpty) return;

      if (_currentPage < slides.length - 1) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      } else {
        // Loop back to first slide or stop
        _pageController.animateToPage(
          0,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _onButtonPressed() {
    final slides = _buildSlides(AppLocalizations.of(context)!);
    if (slides.isEmpty) return;

    if (_currentPage < slides.length - 1) {
      // Move to next slide
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Last slide - navigate to login
      _navigateToLogin();
    }
  }

  void _skipToLogin() {
    _navigateToLogin();
  }

  void _navigateToLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CreateAccountScreen()),
      // MaterialPageRoute(builder: (_) => const RegisterScreen()),
    );
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final slides = _buildSlides(l10n);
    return Scaffold(
      body: Stack(
        children: [
          if (slides.isEmpty)
            const Center(child: CircularProgressIndicator())
          else
            // PageView Slider (only background, title, description)
            PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: slides.length,
              itemBuilder: (context, index) {
                return OnboardingSlide(
                  data: slides[index],
                );
              },
            ),

          // Skip Button (always visible)
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: TextButton(
                  onPressed: _skipToLogin,
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFF435873),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: const StadiumBorder(),
                  ),
                  child: Text(
                    l10n.skip,
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Pagination dots + button, laid out together so the dots always
          // sit directly above the button on every screen size.
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (slides.isNotEmpty) _buildPaginationDots(slides),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 53,
                      child: ElevatedButton(
                        onPressed: _onButtonPressed,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 0.0),
                          backgroundColor: const Color(0xFF435873),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Text(
                                slides.isEmpty
                                    ? l10n.next
                                    : slides[_currentPage].buttonText,
                                style: const TextStyle(
                                  fontFamily: 'Outfit',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Container(
                              width: 44,
                              height: 44,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.rectangle,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              ),
                              child: Center(
                                child: Image.asset(
                                  'assets/icons/right_arrow_head.png',
                                  width: 18,
                                  height: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaginationDots(List<OnboardingSlideModel> slides) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        slides.length,
        (index) => Container(
          width: 7.78,
          height: 7.78,
          margin: const EdgeInsets.symmetric(horizontal: 5.5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == index
                ? const Color(0xFFF09802)
                : const Color(0xFFD9D9D9),
          ),
        ),
      ),
    );
  }
}

class OnboardingSlide extends StatelessWidget {
  final OnboardingSlideModel data;

  const OnboardingSlide({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: data.imagePath.startsWith('http')
              ? Image.network(
                  data.imagePath,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(
                          Icons.image_not_supported,
                          size: 100,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  },
                )
              : Image.asset(
                  data.imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(
                          Icons.image_not_supported,
                          size: 100,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  },
                ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: MediaQuery.of(context).size.height * 0.5,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black,
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _TwoLineTitle(text: data.title),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        data.description,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Outfit',
                          fontSize: 16,
                          height: 1.5,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const SizedBox(height: 190),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Onboarding title that always fits in two lines: the font shrinks on
/// narrow screens / large system text, and the width is capped on wide
/// screens (tablets, iPad) so the title still wraps onto a second line.
class _TwoLineTitle extends StatelessWidget {
  final String text;

  const _TwoLineTitle({required this.text});

  static const double _maxFontSize = 28;
  static const double _minFontSize = 16;
  static const double _maxWidth = 340;

  TextStyle _style(double fontSize) => TextStyle(
        fontFamily: 'Outfit',
        color: Colors.white,
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
        height: 1.2,
      );

  @override
  Widget build(BuildContext context) {
    final textScaler = MediaQuery.textScalerOf(context);
    final textDirection = Directionality.of(context);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: _maxWidth),
        child: LayoutBuilder(
          builder: (context, constraints) {
            var fontSize = _maxFontSize;
            while (fontSize > _minFontSize) {
              final painter = TextPainter(
                text: TextSpan(text: text, style: _style(fontSize)),
                textDirection: textDirection,
                textScaler: textScaler,
                maxLines: 2,
              )..layout(maxWidth: constraints.maxWidth);
              final fits = !painter.didExceedMaxLines;
              painter.dispose();
              if (fits) break;
              fontSize -= 1;
            }

            return SizedBox(
              width: double.infinity,
              child: Text(
                text,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: _style(fontSize),
              ),
            );
          },
        ),
      ),
    );
  }
}
