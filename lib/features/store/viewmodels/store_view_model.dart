import 'package:flutter/foundation.dart';
import 'package:adcc/features/store/models/store_item_model.dart';
import 'package:adcc/features/store/repositories/store_repository.dart';

class StoreViewModel extends ChangeNotifier {
  final StoreRepository _repository;

  StoreViewModel({StoreRepository? repository})
      : _repository = repository ?? StoreRepository();

  bool isLoading = false;
  String? error;
  List<StoreItemModel> items = const [];

  Future<void> loadItems({
    String? search,
    String? category,
    String? city,
    double? minPrice,
    double? maxPrice,
  }) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      items = await _repository.fetchItems(
        search: search,
        category: category,
        city: city,
        minPrice: minPrice,
        maxPrice: maxPrice,
      );
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  List<StoreItemModel> filterItems({
    required String category,
    required String search,
  }) {
    var filtered = items;

    if (category != 'All') {
      filtered = filtered.where((e) => e.category == category).toList();
    }

    final q = search.trim().toLowerCase();
    if (q.isNotEmpty) {
      filtered = filtered.where((e) {
        return e.title.toLowerCase().contains(q) ||
            e.postedBy.toLowerCase().contains(q);
      }).toList();
    }

    return filtered;
  }
}
