import 'package:adcc/core/constants/api_endpoints.dart';
import 'package:adcc/core/models/lookup_model.dart';
import 'package:adcc/core/services/api_client.dart';
import 'package:adcc/core/services/api_exception.dart';
import 'package:adcc/core/services/api_response.dart';
import 'package:adcc/core/services/language_storage_service.dart';
import 'package:adcc/core/utils/response_parser.dart';
import 'package:dio/dio.dart';

/// Fetches dashboard-managed bilingual lookup lists from `GET /v1/lookups`.
///
/// The backend returns each entry as `{ value, label, labelAr, ... }`; the
/// app picks `label` (English) or `labelAr` (Arabic) based on the stored
/// locale. Lists are cached in memory to avoid re-fetching on every screen.
class LookupService {
  LookupService._();

  static final LookupService instance = LookupService._();

  final ApiClient _apiClient = ApiClient.instance;

  /// In-memory cache keyed by lookup type.
  final Map<String, List<LookupModel>> _cache = {};

  /// Clears the in-memory cache (e.g. after switching language or on logout).
  void clearCache() => _cache.clear();

  /// Clears a single type from the cache.
  void invalidate(String type) => _cache.remove(type);

  /// Returns the stored locale code ('ar', 'en', ...) or null if not set.
  Future<String?> getLocaleCode() => LanguageStorageService.getLocaleCode();

  Future<List<LookupModel>> _fetch(String type) async {
    final response = await _apiClient.get<dynamic>(
      ApiEndpoints.lookupsByType(type),
    );

    if (response.statusCode != null &&
        (response.statusCode! < 200 || response.statusCode! >= 300)) {
      throw ApiException.fromDioException(
        DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        ),
      );
    }

    final rawItems = ResponseParser.extractList(response.data, const [
      'data',
      'items',
      'lookups',
      'results',
    ]);
    final items = rawItems
        .whereType<Map<String, dynamic>>()
        .map(LookupModel.fromJson)
        .where((item) => item.active)
        .toList();

    items.sort((a, b) {
      final orderCompare = a.order.compareTo(b.order);
      return orderCompare != 0 ? orderCompare : a.label.compareTo(b.label);
    });

    return items;
  }

  /// Fetch (or return cached) lookups for a type.
  Future<List<LookupModel>> getLookups(String type) async {
    final cached = _cache[type];
    if (cached != null) return cached;

    final items = await _fetch(type);
    _cache[type] = items;
    return items;
  }

  /// Fetch a single type and return only the display labels for the
  /// current locale.
  Future<List<String>> getLabels(String type) async {
    final locale = await getLocaleCode();
    final items = await getLookups(type);
    return items.map((item) => item.displayFor(locale)).toList();
  }

  /// Resolve a stored English value to its localized display label.
  /// Returns the original value if the type is unknown or value not found.
  Future<String> resolveLabel(String type, String value) async {
    final locale = await getLocaleCode();
    final items = await getLookups(type);
    for (final item in items) {
      if (item.value == value) return item.displayFor(locale);
    }
    return value;
  }

  /// Resolve a list of stored English values to localized display labels.
  Future<List<String>> resolveLabels(String type, List<String> values) async {
    final locale = await getLocaleCode();
    final items = await getLookups(type);
    final byValue = {for (final item in items) item.value: item};
    return values.map((v) => byValue[v]?.displayFor(locale) ?? v).toList();
  }

  /// Synchronous lookup for code that already has items loaded.
  static String displayLabel(LookupModel item, String? localeCode) =>
      item.displayFor(localeCode);
}
