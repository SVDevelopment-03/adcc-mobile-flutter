import 'package:flutter_test/flutter_test.dart';
import 'package:adcc/core/services/app_update_service.dart';

void main() {
  group('AppUpdateService.compareVersions', () {
    test('compares semantic versions with build suffixes', () {
      expect(AppUpdateService.compareVersions('2.2.7', '2.2.7'), 0);
      expect(AppUpdateService.compareVersions('2.2.7+53', '2.2.7'), 0);
      expect(AppUpdateService.compareVersions('2.2.6', '2.2.7'), -1);
      expect(AppUpdateService.compareVersions('2.3.0', '2.2.7'), 1);
      expect(AppUpdateService.compareVersions('1.10.0', '1.9.9'), 1);
    });

    test('pads missing segments to zero', () {
      expect(AppUpdateService.compareVersions('1.0', '1.0.0'), 0);
      expect(AppUpdateService.compareVersions('1.0.0', '1.0.1'), -1);
    });
  });
}
