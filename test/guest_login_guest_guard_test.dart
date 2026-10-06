import 'package:adcc/core/services/token_storage_service.dart';
import 'package:adcc/features/communities/view/community_screen.dart';
import 'package:adcc/features/notifications/repositories/push_notification_repository.dart';
import 'package:adcc/features/profile/view/screens/profile_screen.dart';
import 'package:adcc/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Guest login guard', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
    });

    test('guest users skip protected push registration', () async {
      await TokenStorageService.saveGuestUser(true);
      await TokenStorageService.saveAccessToken('guest-token');
      final result = await PushNotificationRepository()
          .registerCurrentDeviceTokenIfAuthenticated();

      expect(result, isNull);
      expect(await TokenStorageService.isGuestUser(), isTrue);
    });

    test('guest sessions do not count as registered auto-login', () async {
      await TokenStorageService.saveGuestUser(true);
      await TokenStorageService.saveAccessToken('guest-token');
      await TokenStorageService.saveProfileComplete(true);

      expect(await TokenStorageService.isRegisteredUserSession(), isFalse);
    });

    testWidgets('guest profile explore community opens community screen',
        (tester) async {
      final binding = TestWidgetsFlutterBinding.ensureInitialized();
      binding.window.physicalSizeTestValue = const Size(800, 1600);
      binding.window.devicePixelRatioTestValue = 1.0;
      addTearDown(() {
        binding.window.clearPhysicalSizeTestValue();
        binding.window.clearDevicePixelRatioTestValue();
      });

      await TokenStorageService.saveGuestUser(true);

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const ProfileScreen(),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Explore Community'), findsOneWidget);
      await tester.tap(find.text('Explore Community'));
      await tester.pumpAndSettle();

      expect(find.byType(CommunitiesScreen), findsOneWidget);
    });
  });
}
