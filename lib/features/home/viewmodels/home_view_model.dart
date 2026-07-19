import 'package:flutter/foundation.dart';
import 'package:adcc/features/home/models/home_models.dart';
import 'package:adcc/features/home/repositories/home_repository.dart';

class HomeViewModel extends ChangeNotifier {
  final HomeRepository _repository;
  bool _disposed = false;

  HomeViewModel({HomeRepository? repository})
      : _repository = repository ?? HomeRepository();

  bool isLoading = false;
  String? error;
  HomeFeedModel? feed;
  DateTime? lastSyncedAt;

  Future<void> loadHome({bool forceRefresh = false}) async {
    if (isLoading) return;
    isLoading = true;
    error = null;
    if (feed == null || forceRefresh) {
      _safeNotify();
    }

    try {
      feed = await _repository.fetchHomeFeed();
      lastSyncedAt = DateTime.now();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      _safeNotify();
    }
  }

  void _safeNotify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
