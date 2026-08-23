import 'package:adcc/core/constants/api_endpoints.dart';
import 'package:adcc/core/services/api_client.dart';
import 'package:adcc/core/utils/response_parser.dart';
import 'package:flutter/foundation.dart';
import 'package:adcc/features/store/models/store_item_model.dart';

class ProductBannerModel {
  final String key;
  final String? title;
  final String? label;
  final String? image;
  final String? targetScreen;

  ProductBannerModel({
    required this.key,
    this.title,
    this.label,
    this.image,
    this.targetScreen,
  });

  static String? _nullableString(dynamic value) {
    final str = ResponseParser.asString(value);
    return str.isEmpty ? null : str;
  }

  factory ProductBannerModel.fromJson(Map<String, dynamic> json) {
    // Defensive parsing: try multiple key names for targetScreen
    String? resolvedTarget;
    resolvedTarget = _nullableString(json['targetScreen']) ??
        _nullableString(json['targetscreen']) ??
        _nullableString(json['target_screen']) ??
        _nullableString(json['target']) ??
        _nullableString(json['route']);

    return ProductBannerModel(
      key: ResponseParser.asString(json['key']),
      title: _nullableString(json['title']),
      label: _nullableString(json['label']),
      image: _nullableString(json['image']),
      targetScreen: resolvedTarget,
    );
  }
}

class MerchandiseCategory {
  final String name;
  final String? image;

  MerchandiseCategory({
    required this.name,
    this.image,
  });

  static String? _nullableString(dynamic value) {
    final str = ResponseParser.asString(value);
    return str.isEmpty ? null : str;
  }

  factory MerchandiseCategory.fromJson(Map<String, dynamic> json) {
    return MerchandiseCategory(
      name: ResponseParser.asString(json['name']),
      image: _nullableString(json['image']),
    );
  }
}

class ClubStoreRepository {
  final ApiClient _apiClient;

  ClubStoreRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient.instance;

  Future<List<StoreItemModel>> fetchMerchandise({
    String? search,
    String? category,
    String? city,
    int page = 1,
    int limit = 20,
  }) async {
    final queryParameters = <String, dynamic>{
      'page': page,
      'limit': limit,
      'status': 'published',
    };

    if (search != null && search.isNotEmpty) {
      queryParameters['q'] = search;
    }
    if (category != null && category.isNotEmpty && category != 'All') {
      queryParameters['category'] = category;
    }
    if (city != null && city.isNotEmpty) {
      queryParameters['city'] = city;
    }

    final response = await _apiClient.get<dynamic>(
      ApiEndpoints.merchandiseItems,
      queryParameters: queryParameters,
    );

    final list = ResponseParser.extractList(
        response.data, const ['items', 'products', 'results']);
    final items = list
        .whereType<Map<String, dynamic>>()
        .map(StoreItemModel.fromJson)
        .toList();
    items.shuffle();
    return items;
  }

  Future<List<MerchandiseCategory>> fetchMerchandiseCategories() async {
    final response =
        await _apiClient.get<dynamic>(ApiEndpoints.merchandiseCategories);
    final list = ResponseParser.extractList(
        response.data, const ['data', 'items', 'categories', 'results']);

    final categories = list
        .whereType<Map<String, dynamic>>()
        .map(MerchandiseCategory.fromJson)
        .where((category) => category.name.isNotEmpty)
        .toList();

    categories.sort((a, b) => a.name.compareTo(b.name));
    return categories;
  }

    /// Fetch product banners. Pass [lang] (e.g. 'en' or 'ar') to request the
    /// language-specific banner set. Defaults to English when omitted.
    Future<List<ProductBannerModel>> fetchProductBanners({String? lang}) async {
      final isAr = lang != null && lang.startsWith('ar');

      // If Arabic requested, try Arabic endpoint first, then fall back to
      // English if no Arabic banners are available.
      final endpoints = isAr
        ? [ApiEndpoints.productBannersAr, ApiEndpoints.productBanners]
        : [ApiEndpoints.productBanners];

      for (final endpoint in endpoints) {
        try {
          final response = await _apiClient.get<dynamic>(endpoint);
          final list = ResponseParser.extractList(response.data, const ['data', 'banners']);
          // Log raw items for debugging
          for (var i = 0; i < list.length; i++) {
            try {
              debugPrint('fetchProductBanners: raw banner[$i]=${list[i]}');
            } catch (_) {}
          }
          final items = list
              .whereType<Map<String, dynamic>>()
              .map(ProductBannerModel.fromJson)
              .toList();
          // Log for debugging
          debugPrint('fetchProductBanners: tried $endpoint -> ${items.length} items');
          if (items.isNotEmpty) return items;
        } catch (e) {
          debugPrint('fetchProductBanners: error fetching $endpoint: $e');
        }
        // if this was English endpoint (or Arabic empty), continue to next
      }

      debugPrint('fetchProductBanners: no banners found for endpoints: $endpoints');
      return <ProductBannerModel>[];
    }

  Future<StoreItemModel?> fetchMerchandiseItemById(String id) async {
    final response =
        await _apiClient.get<dynamic>(ApiEndpoints.merchandiseItemById(id));
    final map = ResponseParser.extractMap(
            response.data, const ['data', 'item', 'product']) ??
        {};
    if (map.isEmpty) return null;
    return StoreItemModel.fromJson(map);
  }
}
