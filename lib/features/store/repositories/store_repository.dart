import 'package:adcc/core/constants/api_endpoints.dart';
import 'package:adcc/core/services/api_client.dart';
import 'package:adcc/core/utils/response_parser.dart';
import 'package:adcc/features/store/models/store_item_model.dart';
import 'package:dio/dio.dart' show FormData, MultipartFile, Options;
import 'package:adcc/core/services/language_storage_service.dart';

class StoreRepository {
  final ApiClient _apiClient;

  StoreRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient.instance;

  Future<List<StoreItemModel>> fetchItems({
    String? search,
    String? category,
    String? city,
    double? minPrice,
    double? maxPrice,
    int page = 1,
    int limit = 50,
  }) async {
    try {
      final qp = <String, dynamic>{
        'page': page,
        'limit': limit,
        'status': 'Approved', // only show approved items in marketplace
      };

      if (search != null && search.isNotEmpty) qp['q'] = search;
      if (category != null && category.isNotEmpty && category != 'All')
        qp['category'] = category;
      if (city != null && city.isNotEmpty) qp['city'] = city;
      if (minPrice != null) qp['minPrice'] = minPrice;
      if (maxPrice != null) qp['maxPrice'] = maxPrice;

      final response = await _apiClient.get<dynamic>(
        ApiEndpoints.storeItems,
        queryParameters: qp,
      );

      final list = ResponseParser.extractList(
        response.data,
        const ['items', 'products', 'results'],
      );

      final localeCode = await LanguageStorageService.getLocaleCode();

      final mapped = list.whereType<Map<String, dynamic>>().map((raw) {
        if (localeCode == 'ar') {
          // prefer Arabic fields when available
          final copy = Map<String, dynamic>.from(raw);
          if (copy['titleAr'] != null && (copy['titleAr'] as String).trim().isNotEmpty) {
            copy['title'] = copy['titleAr'];
          } else if (copy['nameAr'] != null && (copy['nameAr'] as String).trim().isNotEmpty) {
            copy['title'] = copy['nameAr'];
          }
          if (copy['descriptionAr'] != null && (copy['descriptionAr'] as String).trim().isNotEmpty) {
            copy['description'] = copy['descriptionAr'];
          } else if (copy['nameAr'] == null && copy['descriptionAr'] == null) {
            // fallback: if merchandise uses name/description fields
          }
          // prefer Arabic specifications if present
          if (copy['specificationsAr'] != null && copy['specificationsAr'] is List) {
            copy['specifications'] = copy['specificationsAr'];
          }
          return copy;
        }
        return raw as Map<String, dynamic>;
      }).toList();

      return mapped.map(StoreItemModel.fromJson).toList();
    } catch (_) {
      return const [];
    }
  }

  Future<StoreItemModel?> fetchItemById(String id) async {
    try {
      final response =
          await _apiClient.get<dynamic>(ApiEndpoints.storeItemById(id));

      final map = ResponseParser.extractMap(
        response.data,
        const ['item', 'product', 'data'],
      );

      if (map == null) return null;
      final localeCode = await LanguageStorageService.getLocaleCode();
      final copy = Map<String, dynamic>.from(map);
      if (localeCode == 'ar') {
        if (copy['titleAr'] != null && (copy['titleAr'] as String).trim().isNotEmpty) copy['title'] = copy['titleAr'];
        if (copy['nameAr'] != null && (copy['nameAr'] as String).trim().isNotEmpty) copy['title'] = copy['nameAr'];
        if (copy['descriptionAr'] != null && (copy['descriptionAr'] as String).trim().isNotEmpty) copy['description'] = copy['descriptionAr'];
        if (copy['specificationsAr'] != null && copy['specificationsAr'] is List) copy['specifications'] = copy['specificationsAr'];
      }

      return StoreItemModel.fromJson(copy);
    } catch (_) {
      return null;
    }
  }

  Future<bool> createItem(Map<String, dynamic> payload,
      {List<MultipartFile>? photos,
      MultipartFile? coverImage,
      MultipartFile? video}) async {
    try {
      final form = FormData();

      payload.forEach((key, value) {
        if (value != null) form.fields.add(MapEntry(key, value.toString()));
      });

      if (coverImage != null) {
        form.files.add(MapEntry('coverImage', coverImage));
      }

      if (photos != null && photos.isNotEmpty) {
        for (final p in photos) {
          form.files.add(MapEntry('photos[]', p));
        }
      }

      if (video != null) {
        form.files.add(MapEntry('video', video));
      }

      await _apiClient.post<dynamic>(
        ApiEndpoints.storeItems,
        data: form,
        options: Options(contentType: 'multipart/form-data'),
      );

      return true;
    } catch (_) {
      return false;
    }
  }

  Future<List<StoreItemModel>> fetchMyItems() async {
    try {
      final response = await _apiClient.get<dynamic>(ApiEndpoints.storeMyItems,
          queryParameters: {'page': 1, 'limit': 50});

      final list = ResponseParser.extractList(
        response.data,
        const ['items', 'data', 'results'],
      );

      final localeCode = await LanguageStorageService.getLocaleCode();
      final mapped = list.whereType<Map<String, dynamic>>().map((raw) {
        if (localeCode == 'ar') {
          final copy = Map<String, dynamic>.from(raw);
          if (copy['titleAr'] != null && (copy['titleAr'] as String).trim().isNotEmpty) copy['title'] = copy['titleAr'];
          if (copy['descriptionAr'] != null && (copy['descriptionAr'] as String).trim().isNotEmpty) copy['description'] = copy['descriptionAr'];
          if (copy['specificationsAr'] != null && copy['specificationsAr'] is List) copy['specifications'] = copy['specificationsAr'];
          return copy;
        }
        return raw as Map<String, dynamic>;
      }).toList();

      return mapped.map(StoreItemModel.fromJson).toList();
    } catch (_) {
      return const [];
    }
  }

  Future<bool> updateItem(String id, Map<String, dynamic> updates,
      {List<MultipartFile>? photos,
      MultipartFile? coverImage,
      MultipartFile? video}) async {
    try {
      final form = FormData();
      updates.forEach((key, value) {
        if (value != null) form.fields.add(MapEntry(key, value.toString()));
      });

      if (coverImage != null)
        form.files.add(MapEntry('coverImage', coverImage));
      if (photos != null && photos.isNotEmpty) {
        for (final p in photos) form.files.add(MapEntry('photos[]', p));
      }
      if (video != null) {
        form.files.add(MapEntry('video', video));
      }

      await _apiClient.patch<dynamic>(
        ApiEndpoints.storeItemById(id),
        data: form,
        options: Options(contentType: 'multipart/form-data'),
      );

      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> archiveItem(String id) async {
    try {
      await _apiClient.delete<dynamic>(ApiEndpoints.storeItemById(id));
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> markItemSold(String id) async {
    try {
      await _apiClient.post<dynamic>(ApiEndpoints.storeItemMarkSold(id));
      return true;
    } catch (_) {
      return false;
    }
  }
}
