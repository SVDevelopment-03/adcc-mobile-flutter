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

const List<String> purposeBasedCommunityCategories = [
  'Racing & Performance',
  'Family & Leisure',
  'Women (SheRides)',
  'Youth',
  'Social / Weekend',
  'Night Riders',
  'MTB / Trail',
  'Training & Clinics',
  'Awareness & Charity',
  'Corporate',
  'Education',
  'Health',
];

const Map<String, String> purposeBasedCommunityCategoryImages = {
  'Racing & Performance': 'assets/images/racing.png',
  'Family & Leisure': 'assets/images/family-rides.png',
  'Women (SheRides)': 'assets/images/she-rides.png',
  'Youth': 'assets/images/youth.png',
  'Social / Weekend': 'assets/images/family_ride.png',
  'Night Riders': 'assets/images/night-ride.png',
  'MTB / Trail': 'assets/images/mtb-ride.png',
  'Training & Clinics': 'assets/images/bike_experience.png',
  'Awareness & Charity': 'assets/images/ride_events.png',
  'Corporate': 'assets/images/no-img.jpg',
  'Education': 'assets/images/bike.png',
  'Health': 'assets/images/ride.png',
};

const Map<String, List<String>> purposeBasedCommunityCategoryKeys = {
  'Racing & Performance': ['racing', 'performance'],
  'Family & Leisure': ['family', 'leisure', 'kids'],
  'Women (SheRides)': ['women', 'she', 'ladies'],
  'Youth': ['youth', 'cycling'],
  'Social / Weekend': ['social', 'weekend'],
  'Night Riders': ['night'],
  'MTB / Trail': ['mtb', 'trail'],
  'Training & Clinics': ['training', 'clinic'],
  'Awareness & Charity': ['awareness', 'charity', 'special', 'fundraising'],
  'Corporate': ['corporate', 'partner'],
  'Education': ['education', 'learn'],
  'Health': ['health', 'wellness'],
};
