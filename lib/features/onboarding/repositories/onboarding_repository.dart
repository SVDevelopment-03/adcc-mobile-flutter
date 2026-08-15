import 'package:adcc/core/constants/api_endpoints.dart';
import 'package:adcc/core/services/api_client.dart';
import 'package:adcc/core/utils/response_parser.dart';
import 'package:adcc/l10n/app_localizations.dart';
import 'package:adcc/features/onboarding/models/onboarding_slide_model.dart';

class OnboardingRepository {
  final ApiClient _apiClient;

  static List<OnboardingSlideModel> buildFallbackSlides(AppLocalizations l10n) {
    return [
      OnboardingSlideModel(
        title: l10n.onboardingTitle1,
        description: l10n.onboardingDesc1,
        buttonText: l10n.next,
        imagePath: 'assets/images/onboarding_bg_one.png',
      ),
      OnboardingSlideModel(
        title: l10n.onboardingTitle2,
        description: l10n.onboardingDesc2,
        buttonText: l10n.getStarted,
        imagePath: 'assets/images/onboarding_bg_two.png',
      ),
      OnboardingSlideModel(
        title: l10n.onboardingTitle3,
        description: l10n.onboardingDesc3,
        buttonText: l10n.next,
        imagePath: 'assets/images/onboarding-2-copy.jpg',
      ),
      OnboardingSlideModel(
        title: l10n.onboardingTitle4,
        description: l10n.onboardingDesc4,
        buttonText: l10n.getStarted,
        imagePath: 'assets/images/onboarding4.png',
      ),
    ];
  }

  OnboardingRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient.instance;

  Future<List<OnboardingSlideModel>> fetchSlides(AppLocalizations l10n) async {
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

      final extra = <String, dynamic>{};
      final slides = list.whereType<Map<String, dynamic>>().map((json) {
        return OnboardingSlideModel(
          title: ResponseParser.asString(
            json['title'] ?? json['label'],
            fallback: extra['title'] as String? ?? l10n.onboardingTitle1,
          ),
          description: ResponseParser.asString(
            json['description'],
            fallback: l10n.onboardingDesc1,
          ),
          buttonText: ResponseParser.asString(
            json['buttonText'],
            fallback: l10n.next,
          ),
          imagePath: ResponseParser.asString(
            json['image'],
            fallback: 'assets/images/onboarding_bg_one.png',
          ),
        );
      }).toList();

      final fallback = buildFallbackSlides(l10n);
      if (slides.isEmpty) return fallback;

      // Ensure we always have a complete onboarding flow (4 slides).
      // Some environments return fewer slides from the backend.
      if (slides.length >= fallback.length) return slides;

      final toppedUp = <OnboardingSlideModel>[...slides];
      for (var i = toppedUp.length; i < fallback.length; i++) {
        toppedUp.add(fallback[i]);
      }

      return toppedUp;
    } catch (_) {
      return buildFallbackSlides(l10n);
    }
  }
}
