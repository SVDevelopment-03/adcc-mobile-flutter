import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:adcc/l10n/app_localizations.dart';
import 'package:adcc/features/onboarding/models/onboarding_slide_model.dart';
import 'package:adcc/features/onboarding/repositories/onboarding_repository.dart';

class OnboardingViewModel extends ChangeNotifier {
  final OnboardingRepository _repository;

  OnboardingViewModel({OnboardingRepository? repository})
      : _repository = repository ?? OnboardingRepository();

  bool isLoading = false;
  List<OnboardingSlideModel> slides = const [];

  Future<void> loadSlides(AppLocalizations l10n) async {
    slides = OnboardingRepository.buildFallbackSlides(l10n);
    isLoading = true;
    notifyListeners();

    try {
      final fetchedSlides =
          await _repository.fetchSlides(l10n).timeout(const Duration(seconds: 8));
      slides = fetchedSlides;
    } on TimeoutException {
      slides = OnboardingRepository.buildFallbackSlides(l10n);
    } catch (_) {
      slides = OnboardingRepository.buildFallbackSlides(l10n);
    }

    isLoading = false;
    notifyListeners();
  }
}
