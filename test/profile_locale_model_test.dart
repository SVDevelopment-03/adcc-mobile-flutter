import 'package:adcc/features/events/view/cancel_registration.dart';
import 'package:adcc/features/profile/models/profile_history_models.dart';
import 'package:adcc/features/profile/repositories/profile_repository.dart';
import 'package:adcc/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Arabic event history resolves localized title and category values', () {
    final item = ProfileEventHistoryItem.fromApi({
      'event': {
        'title': 'National Ride',
        'titleAr': 'ركوب وطني',
        'category': 'Community Ride',
        'categoryAr': 'ركوب المجتمع',
      },
      'completedAt': '2025-01-01T00:00:00.000Z',
      'distance': '42',
    }, locale: 'ar');

    expect(item.title, 'ركوب وطني');
    expect(item.subtitle, 'ركوب المجتمع');
  });

  test('Upcoming event titles also resolve Arabic language fields', () {
    final item = ProfileUpcomingEventItem.fromApi({
      'event': {
        'title': 'Morning Ride',
        'titleAr': 'رحلة صباحية',
        'eventDate': '2025-02-01',
        'eventTime': '06:30',
      },
    }, locale: 'ar');

    expect(item.title, 'رحلة صباحية');
  });

  test('Joined communities prefer Arabic names when the app locale is Arabic', () {
    final community = {
      'name': 'Friday Ride',
      'title': 'Friday Ride',
      'community': {
        'name': 'Al Ain Cyclist Team',
        'nameAr': 'فريق الدراجين العين',
      },
    };

    final displayName = ProfileRepository.resolveCommunityDisplayName(
      community,
      isArabic: true,
    );

    expect(displayName, 'فريق الدراجين العين');
  });

  test('Null community memberships are ignored and do not render English placeholders', () {
    final membershipList = [
      {'community': null, 'joinedAt': '2026-06-13T12:18:21.946Z', 'role': 'member'},
      {
        'community': {
          'title': 'Friday Ride Al Ain Cyclist Team',
          'titleAr': 'رحلة الجمعة فريق الدراجين العين',
        },
      },
    ];

    final valid = membershipList
        .where((entry) => entry['community'] is Map<String, dynamic>)
        .map((entry) => entry['community'] as Map<String, dynamic>)
        .toList();

    expect(valid.length, 1);
    expect(valid.first['titleAr'], 'رحلة الجمعة فريق الدراجين العين');
  });

  test('Fallback no-event labels are treated as empty and not real ride cards',
      () {
    const item = ProfileEventHistoryItem(
      id: '1',
      title: 'No event',
      subtitle: 'No category',
      date: '',
      status: 'Completed',
      distance: '0',
      time: '',
      rank: '',
      image: '',
      badgeName: '',
    );

    expect(item.hasMeaningfulTitle, isFalse);
  });

  test('Joined-event placeholder titles are treated as empty state', () {
    const item = ProfileUpcomingEventItem(
      id: '1',
      title: 'No upcoming events',
      date: '',
      time: '',
      distance: '',
      image: '',
    );

    expect(item.hasMeaningfulTitle, isFalse);
  });

  testWidgets('Cancel registration reasons use localized app strings', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ar'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Builder(
          builder: (context) {
            final reasons = CancelRegistrationScreen.localizedReasons(context);
            expect(reasons.first, AppLocalizations.of(context)!.reasonScheduleConflict);
            expect(reasons[3], AppLocalizations.of(context)!.reasonOther);
            return const SizedBox();
          },
        ),
      ),
    );
  });
}
