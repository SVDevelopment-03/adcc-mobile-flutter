import 'package:adcc/core/constants/api_endpoints.dart';
import 'package:adcc/core/services/api_client.dart';
import 'package:adcc/core/utils/response_parser.dart';
import 'package:adcc/features/store/models/store_item_model.dart';

class ProductBannerModel {
  final String key;
  final String? title;
  final String? label;
  final String? image;

  ProductBannerModel({
    required this.key,
    this.title,
    this.label,
    this.image,
  });

  static String? _nullableString(dynamic value) {
    final str = ResponseParser.asString(value);
    return str.isEmpty ? null : str;
  }

  factory ProductBannerModel.fromJson(Map<String, dynamic> json) {
    return ProductBannerModel(
      key: ResponseParser.asString(json['key']),
      title: _nullableString(json['title']),
      label: _nullableString(json['label']),
      image: _nullableString(json['image']),
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

  ClubStoreRepository({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient.instance;

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

    final list = ResponseParser.extractList(response.data, const ['items', 'products', 'results']);
    final items = list
        .whereType<Map<String, dynamic>>()
        .map(StoreItemModel.fromJson)
        .toList();
    items.shuffle();
    return items;
  }

  Future<List<MerchandiseCategory>> fetchMerchandiseCategories() async {
    final response = await _apiClient.get<dynamic>(ApiEndpoints.merchandiseCategories);
    final list = ResponseParser.extractList(response.data, const ['data', 'items', 'categories', 'results']);

    final categories = list
        .whereType<Map<String, dynamic>>()
        .map(MerchandiseCategory.fromJson)
        .where((category) => category.name.isNotEmpty)
        .toList();

    categories.sort((a, b) => a.name.compareTo(b.name));
    return categories;
  }

  Future<List<ProductBannerModel>> fetchProductBanners() async {
    final response = await _apiClient.get<dynamic>(ApiEndpoints.productBanners);
    final list = ResponseParser.extractList(response.data, const ['data', 'banners']);
    return list
        .whereType<Map<String, dynamic>>()
        .map(ProductBannerModel.fromJson)
        .toList();
  }

  Future<StoreItemModel?> fetchMerchandiseItemById(String id) async {
    final response = await _apiClient.get<dynamic>(ApiEndpoints.merchandiseItemById(id));
    final map = ResponseParser.extractMap(response.data, const ['data', 'item', 'product']) ?? {};
    if (map.isEmpty) return null;
    return StoreItemModel.fromJson(map);
  }
}
