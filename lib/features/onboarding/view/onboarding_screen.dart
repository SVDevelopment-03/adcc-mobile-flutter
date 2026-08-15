import 'package:adcc/features/auth/view/registrationScreen/create_account.dart';
import 'package:adcc/features/onboarding/models/onboarding_slide_model.dart';
import 'package:adcc/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const String _onboardingImageUrl1 =
      'https://projet-adcc-image.s3.me-central-1.amazonaws.com/content/Onboarding-Screen-1-1785912478151-3f050bbd0599.png';
  static const String _onboardingImageUrl2 =
      'https://projet-adcc-image.s3.me-central-1.amazonaws.com/content/Onboarding-Screen-3-1785911975941-6c98b1ff307e.png';
  static const String _onboardingImageUrl3 =
      'https://projet-adcc-image.s3.me-central-1.amazonaws.com/content/Onboarding-Screen-2-1785911922294-179d7fa5c171.png';
  static const String _onboardingImageUrl4 =
      'https://projet-adcc-image.s3.me-central-1.amazonaws.com/content/Onboarding-Screen-4-1785879195047-7a66afbe73ab.png';

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
                  child: Text(
                    l10n.skip,
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Static Pagination Dots
          Positioned(
            bottom: 150,
            left: 0,
            right: 0,
            child: slides.isEmpty
                ? const SizedBox.shrink()
                : _buildPaginationDots(slides),
          ),

          // Static Button
          Positioned(
              bottom: 30,
              left: 24,
              right: 24,
              child: SafeArea(
                child: SizedBox(
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
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                          margin: const EdgeInsets.symmetric(horizontal: 8.0),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
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
              )),
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
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.7),
                ],
                stops: const [0.0, 0.45, 1.0],
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
                  children: [
                    Text(
                      data.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Outfit',
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
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
                    const SizedBox(height: 160),
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
