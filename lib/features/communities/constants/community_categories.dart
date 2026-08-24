import 'package:adcc/core/models/lookup_model.dart';

class CommunityCategoryCatalog {
  final LookupModel lookup;
  final String label;
  final List<String> searchKeys;

  const CommunityCategoryCatalog({
    required this.lookup,
    required this.label,
    required this.searchKeys,
  });

  static List<CommunityCategoryCatalog> fromLookups(
    List<LookupModel> lookups,
    String? localeCode,
  ) {
    final active = lookups.where((item) => item.active).toList();
    active.sort((a, b) => a.order.compareTo(b.order));

    return active
        .map(
          (lookup) => CommunityCategoryCatalog(
            lookup: lookup,
            label: lookup.displayFor(localeCode),
            searchKeys: _buildSearchKeys(lookup),
          ),
        )
        .toList(growable: false);
  }

  static List<String> _buildSearchKeys(LookupModel lookup) {
    final keys = <String>{};

    for (final raw in [lookup.value, lookup.label, lookup.labelAr]) {
      final normalized = raw
          .toLowerCase()
          .replaceAll(RegExp(r'[^a-z0-9\u0600-\u06FF]+'), ' ')
          .trim();
      if (normalized.isEmpty) continue;

      for (final token in normalized.split(RegExp(r'\s+'))) {
        final clean = token.trim();
        if (clean.isEmpty) continue;

        keys.add(clean);
        if (clean.contains('she')) keys.add('she');
        if (clean.contains('ride')) keys.add('ride');
      }
    }

    final fallback = lookup.label.toLowerCase().trim();
    if (fallback.isNotEmpty) {
      keys.add(fallback);
      if (fallback.contains('she')) keys.add('she');
      if (fallback.contains('ride')) keys.add('ride');
    }

    return keys.toList()..sort();
  }

  bool matchesRawValue(String? rawValue) {
    final value = rawValue?.trim();
    if (value == null || value.isEmpty) return false;

    final lower = value.toLowerCase();
    if (lower == lookup.value.toLowerCase() ||
        lower == lookup.label.toLowerCase() ||
        lower == lookup.labelAr.toLowerCase()) {
      return true;
    }

    return searchKeys.any((key) => lower.contains(key));
  }

  static String? normalizeLabel(
    String? rawValue,
    List<CommunityCategoryCatalog> categories,
  ) {
    if (rawValue == null || rawValue.trim().isEmpty) return null;

    for (final category in categories) {
      if (category.matchesRawValue(rawValue)) {
        return category.label;
      }
    }

    return null;
  }
}

