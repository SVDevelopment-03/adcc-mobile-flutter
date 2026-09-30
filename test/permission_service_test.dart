import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:adcc/core/services/permission_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PermissionService.requestAppTrackingPermission', () {
    test('returns true when authorization is granted', () async {
      final result = await PermissionService.requestAppTrackingPermission(
        requestAuthorization: () async => TrackingStatus.authorized,
      );

      expect(result, isTrue);
    });

    test('returns false when authorization is denied', () async {
      final result = await PermissionService.requestAppTrackingPermission(
        requestAuthorization: () async => TrackingStatus.denied,
      );

      expect(result, isFalse);
    });
  });
}
