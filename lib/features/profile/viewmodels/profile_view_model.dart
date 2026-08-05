import 'package:flutter/foundation.dart';
import 'package:adcc/features/profile/models/profile_model.dart';
import 'package:adcc/features/profile/repositories/profile_repository.dart';

class ProfileViewModel extends ChangeNotifier {
  final ProfileRepository _repository;

  ProfileViewModel({ProfileRepository? repository})
      : _repository = repository ?? ProfileRepository();

  bool isLoading = false;
  String? error;
  ProfileModel? profile;
  bool _isDisposed = false;

  Future<void> loadProfile() async {
    isLoading = true;
    error = null;
    if (!_isDisposed) notifyListeners();

    try {
      profile = await _repository.fetchProfile();
      if (profile == null) {
        error = 'Unable to load profile';
      }
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      if (!_isDisposed) notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
