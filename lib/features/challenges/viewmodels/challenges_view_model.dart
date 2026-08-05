import 'package:flutter/foundation.dart';
import 'package:adcc/features/challenges/models/challenge_model.dart';
import 'package:adcc/features/challenges/repositories/challenges_repository.dart';

class ChallengesViewModel extends ChangeNotifier {
  final ChallengesRepository _repository;

  ChallengesViewModel({ChallengesRepository? repository})
      : _repository = repository ?? ChallengesRepository();

  bool isLoading = false;
  String? error;
  List<ChallengeModel> allChallenges = const [];

  Future<void> loadChallenges({String? status}) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      allChallenges = await _repository.fetchChallenges(status: status);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  List<ChallengeModel> byStatus(String status) {
    return allChallenges.where((c) => c.status == status).toList();
  }

  List<ChallengeModel> searchIn(List<ChallengeModel> source, String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return source;
    return source.where((c) {
      return c.title.toLowerCase().contains(q) ||
          c.description.toLowerCase().contains(q);
    }).toList();
  }
}
