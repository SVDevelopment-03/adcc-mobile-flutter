import 'package:adcc/core/constants/api_endpoints.dart';
import 'package:adcc/core/models/lookup_model.dart';
import 'package:adcc/core/services/api_client.dart';
import 'package:adcc/core/services/api_exception.dart';
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

  // Hardcoded fallbacks for common community category labels when the
  // dashboard-managed lookups aren't available or don't include them.
  static const Map<String, String> _hardcodedCategoryAr = {
    'all community types': 'جميع أنواع المجتمعات',
    'all community type': 'جميع أنواع المجتمعات',
    'all types': 'جميع أنواع المجتمعات',
    'city': 'مجتمع المدينة',
    'city community': 'مجتمع المدينة',
    'city communities': 'مجتمع المدينة',
    'citycommunity': 'مجتمع المدينة',
    'type': 'مجتمع الاهتمامات / النوع',
    'interest': 'مجتمع الاهتمامات / النوع',
    'interest type': 'مجتمع الاهتمامات / النوع',
    'interest type community': 'مجتمع الاهتمامات / النوع',
    'interest type communities': 'مجتمع الاهتمامات / النوع',
    'interest / type community': 'مجتمع الاهتمامات / النوع',
    'interest / type communities': 'مجتمع الاهتمامات / النوع',
    'interest community': 'مجتمع الاهتمامات / النوع',
    'purpose': 'مجتمع ذو غرض خاص',
    'purpose based': 'مجتمع ذو غرض خاص',
    'purpose based community': 'مجتمع ذو غرض خاص',
    'purpose-based': 'مجتمع ذو غرض خاص',
    'purpose based communities': 'مجتمع ذو غرض خاص',
    'purpose based communitys': 'مجتمع ذو غرض خاص',
    'special purpose': 'مجتمع ذو غرض خاص',
    'special purpose community': 'مجتمع ذو غرض خاص',
    'special purpose communities': 'مجتمع ذو غرض خاص',
    'special purpose type': 'مجتمع ذو غرض خاص',
    'n a': 'غير متاح',
    'na': 'غير متاح',
    'not available': 'غير متاح',
  };

  static String normalizeLookupValue(String value) {
    return value
        .trim()
        .replaceAll(RegExp(r'[_/]+'), ' ')
        .replaceAll('-', ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .toLowerCase();
  }

  static String? fallbackLocalizedCategoryAr(String raw) {
    final normalized = normalizeLookupValue(raw);
    return _hardcodedCategoryAr[normalized];
  }

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

  /// Try to fetch the consolidated static-data endpoint and populate the
  /// in-memory cache for all types. If the endpoint is not available (404)
  /// or returns an unexpected shape, the method returns false and callers
  /// should fall back to per-type requests.
  Future<bool> _fetchAllStaticData() async {
    try {
      final response = await _apiClient.get<dynamic>(ApiEndpoints.staticData);
      final raw = ResponseParser.extractMap(response.data, const ['data']);
      if (raw == null) return false;

      final lookups = raw['lookups'];
      if (lookups == null || lookups is! Map) return false;

      // Clear and populate cache
      for (final entry in lookups.entries) {
        final type = entry.key as String;
        final items = (entry.value as List)
            .whereType<Map<String, dynamic>>()
            .map(LookupModel.fromJson)
            .where((item) => item.active)
            .toList();

        items.sort((a, b) {
          final orderCompare = a.order.compareTo(b.order);
          return orderCompare != 0 ? orderCompare : a.label.compareTo(b.label);
        });

        _cache[type] = items;
      }

      return true;
    } catch (_) {
      return false;
    }
  }

  /// Fetch (or return cached) lookups for a type.
  Future<List<LookupModel>> getLookups(String type) async {
    final cached = _cache[type];
    if (cached != null) return cached;

    // Try to populate cache from consolidated static-data endpoint first.
    final ok = await _fetchAllStaticData();
    if (ok && _cache[type] != null) return _cache[type]!;

    // Fallback to the legacy per-type endpoint
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
    final byValue = {for (final item in items) item.value: item};
    final byLabel = {for (final item in items) item.label.toLowerCase(): item};

    final direct = byValue[value];
    if (direct != null) return direct.displayFor(locale);

    final labelMatch = byLabel[value.toLowerCase()];
    if (labelMatch != null) return labelMatch.displayFor(locale);

    final normalizedMatch = _matchLookupItem(items, value);
    if (normalizedMatch != null) return normalizedMatch.displayFor(locale);

    // Check hardcoded fallbacks for Arabic
    if (locale != null && locale.trim().toLowerCase().startsWith('ar')) {
      final mapped = fallbackLocalizedCategoryAr(value);
      if (mapped != null && mapped.isNotEmpty) return mapped;
    }

    return value;
  }

  static LookupModel? _matchLookupItem(List<LookupModel> items, String raw) {
    final target = normalizeLookupValue(raw);
    if (target.isEmpty) return null;

    for (final item in items) {
      final valueMatch = normalizeLookupValue(item.value) == target;
      final labelMatch = normalizeLookupValue(item.label) == target;
      final arabicLabelMatch = normalizeLookupValue(item.labelAr) == target;
      if (valueMatch || labelMatch || arabicLabelMatch) {
        return item;
      }
    }

    return null;
  }

  /// Resolve a list of stored English values to localized display labels.
  Future<List<String>> resolveLabels(String type, List<String> values) async {
    final locale = await getLocaleCode();
    final items = await getLookups(type);
    final byValue = {for (final item in items) item.value: item};
    final byLabel = {for (final item in items) item.label.toLowerCase(): item};

    return values.map((raw) {
      final v = raw.trim();
      if (v.isEmpty) return v;
      final direct = byValue[v];
      if (direct != null) return direct.displayFor(locale);
      final labelMatch = byLabel[v.toLowerCase()];
      if (labelMatch != null) return labelMatch.displayFor(locale);

      final normalizedMatch = _matchLookupItem(items, v);
      if (normalizedMatch != null) return normalizedMatch.displayFor(locale);

      // Hardcoded Arabic mapping when locale is Arabic
      if (locale != null && locale.trim().toLowerCase().startsWith('ar')) {
        final mapped = fallbackLocalizedCategoryAr(v);
        if (mapped != null && mapped.isNotEmpty) return mapped;
      }
      return v;
    }).toList();
  }

  /// Synchronous lookup for code that already has items loaded.
  static String displayLabel(LookupModel item, String? localeCode) =>
      item.displayFor(localeCode);
}
