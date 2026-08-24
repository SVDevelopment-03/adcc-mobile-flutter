import 'package:adcc/core/models/lookup_model.dart';
import 'package:adcc/features/communities/constants/community_categories.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CommunityCategoryCatalog', () {
    test('builds bilingual labels and search keys from lookup data', () {
      final lookups = [
        const LookupModel(
          id: '1',
          type: 'community_category',
          value: 'racing_performance',
          label: 'Racing & Performance',
          labelAr: 'سباق وأداء',
          parentValue: null,
          icon: 'https://example.com/racing.png',
          order: 1,
          active: true,
        ),
        const LookupModel(
          id: '2',
          type: 'community_category',
          value: 'women_sherides',
          label: 'Women (SheRides)',
          labelAr: 'النساء (شيرايدز)',
          parentValue: null,
          icon: 'https://example.com/women.png',
          order: 2,
          active: true,
        ),
      ];

      final categories = CommunityCategoryCatalog.fromLookups(lookups, 'ar');

      expect(categories.map((item) => item.label).toList(),
          ['سباق وأداء', 'النساء (شيرايدز)']);
      expect(categories.first.searchKeys, contains('racing'));
      expect(categories[1].searchKeys, contains('she'));
    });
  });
}
