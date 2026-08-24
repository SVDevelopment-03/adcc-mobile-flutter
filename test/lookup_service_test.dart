import 'package:adcc/core/services/lookup_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LookupService community type fallbacks', () {
    test('translates city community variants to Arabic', () {
      expect(
        LookupService.fallbackLocalizedCategoryAr('City Communities'),
        'مجتمع المدينة',
      );
      expect(
        LookupService.fallbackLocalizedCategoryAr('city community'),
        'مجتمع المدينة',
      );
    });

    test('translates interest and purpose community variants to Arabic', () {
      expect(
        LookupService.fallbackLocalizedCategoryAr('Interest / Type Community'),
        'مجتمع الاهتمامات / النوع',
      );
      expect(
        LookupService.fallbackLocalizedCategoryAr('special purpose community'),
        'مجتمع ذو غرض خاص',
      );
    });

    test('translates missing values to Arabic not available text', () {
      expect(
        LookupService.fallbackLocalizedCategoryAr('N/A'),
        'غير متاح',
      );
      expect(
        LookupService.fallbackLocalizedCategoryAr('not available'),
        'غير متاح',
      );
    });
  });
}
