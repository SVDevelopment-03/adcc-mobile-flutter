import 'package:adcc/core/constants/api_endpoints.dart';
import 'package:adcc/core/services/api_client.dart';
import 'package:adcc/core/utils/response_parser.dart';
import 'package:adcc/features/onboarding/models/onboarding_slide_model.dart';

class OnboardingRepository {
  final ApiClient _apiClient;

  static const List<OnboardingSlideModel> fallbackSlides = [
    OnboardingSlideModel(
      title: 'YOUR CYCLING\n JOURNEY STARTS HERE',
      description:
          'Track your rides, explore scenic routes, join events and connect with the UAE cycling community',
      buttonText: 'Next',
      imagePath: 'assets/images/onboarding_bg_one.png',
    ),
    OnboardingSlideModel(
      title: 'JOIN THE RIDE. LIVE\n THE PASSION.',
      description:
          'Unlock a world of cycling experiences from scenic loops to community challenges all in one place.',
      buttonText: 'Get Started',
      imagePath: 'assets/images/onboarding_bg_two.png',
    ),
    OnboardingSlideModel(
      title: 'SHOP & SHARE WITH\n CYCLISTS',
      description:
          'Buy, sell, and discover cycling gear from the ADCC community all in one place.',
      buttonText: 'Next',
      imagePath: 'assets/images/onboarding-2-copy.jpg',
    ),
    OnboardingSlideModel(
      title: 'CREATE YOUR OWN\n RIDE',
      description:
          'Track your rides, set goals, and challenge yourself to go further every day.',
      buttonText: 'Get Started',
      imagePath: 'assets/images/onboarding4.png',
    ),
  ];

  OnboardingRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient.instance;

  Future<List<OnboardingSlideModel>> fetchSlides() async {
    try {
      final response = await _apiClient.get<dynamic>(
        ApiEndpoints.settingsContentList,
        queryParameters: {
          'group': 'onboarding',
          'active': true,
        },
      );

      final list = ResponseParser.extractList(
        response.data,
        const ['items', 'settings', 'results'],
      );

      final slides = list
          .whereType<Map<String, dynamic>>()
          .map((json) {
            return OnboardingSlideModel(
              title: ResponseParser.asString(
                json['title'] ?? json['label'],
                fallback: 'WELCOME',
              ),
              description: ResponseParser.asString(
                json['description'],
                fallback: 'Welcome to ADCC',
              ),
              buttonText: ResponseParser.asString(
                json['buttonText'],
                fallback: 'Next',
              ),
              imagePath: ResponseParser.asString(
                json['image'],
                fallback: 'assets/images/onboarding_bg_one.png',
              ),
            );
          })
          .toList();

      if (slides.isEmpty) return fallbackSlides;

      // Ensure we always have a complete onboarding flow (4 slides).
      // Some environments return fewer slides from the backend.
      if (slides.length >= fallbackSlides.length) return slides;

      final toppedUp = <OnboardingSlideModel>[...slides];
      for (var i = toppedUp.length; i < fallbackSlides.length; i++) {
        toppedUp.add(fallbackSlides[i]);
      }

      return toppedUp;
    } catch (_) {
      return fallbackSlides;
    }
  }
}
