import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:adcc/features/onboarding/models/onboarding_slide_model.dart';
import 'package:adcc/features/onboarding/repositories/onboarding_repository.dart';

class OnboardingViewModel extends ChangeNotifier {
  final OnboardingRepository _repository;

  OnboardingViewModel({OnboardingRepository? repository})
      : _repository = repository ?? OnboardingRepository();

  bool isLoading = false;
  List<OnboardingSlideModel> slides = const [];

  Future<void> loadSlides() async {
    slides = OnboardingRepository.fallbackSlides;
    isLoading = true;
    notifyListeners();

    try {
      final fetchedSlides =
          await _repository.fetchSlides().timeout(const Duration(seconds: 8));
      slides = fetchedSlides;
    } on TimeoutException {
      slides = OnboardingRepository.fallbackSlides;
    } catch (_) {
      slides = OnboardingRepository.fallbackSlides;
    }

    isLoading = false;
    notifyListeners();
  }
}
