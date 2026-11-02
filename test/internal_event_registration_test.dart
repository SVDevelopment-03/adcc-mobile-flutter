import 'package:adcc/core/constants/nationalities.dart';
import 'package:adcc/features/event_details/view/sections/internal_event_registration_section.dart';
import 'package:adcc/features/events/Model/model_events.dart';
import 'package:flutter_test/flutter_test.dart';

Event _event({String? status, DateTime? date}) => Event.fromJson({
      '_id': 'event-1',
      'title': 'Laffah Ride',
      'status': status,
      'eventDate': date?.toIso8601String(),
      'isInternal': true,
    });

void main() {
  final today = DateTime.now();
  final yesterday = today.subtract(const Duration(days: 1));
  final tomorrow = today.add(const Duration(days: 1));

  group('isRegistrationClosed', () {
    test('stays open through the whole event day', () {
      final startOfToday = DateTime(today.year, today.month, today.day);
      expect(
        _event(status: 'Open', date: startOfToday).isRegistrationClosed,
        isFalse,
      );
    });

    test('closes once the date has passed, even if the status says Open', () {
      expect(
        _event(status: 'Open', date: yesterday).isRegistrationClosed,
        isTrue,
      );
    });

    test('a full event still takes registrations', () {
      expect(
        _event(status: 'Full', date: tomorrow).isRegistrationClosed,
        isFalse,
      );
    });

    for (final status in kRegistrationClosedStatuses) {
      test('closed by the $status status', () {
        expect(
          _event(status: status, date: tomorrow).isRegistrationClosed,
          isTrue,
        );
      });
    }

    test('an event without a date stays open', () {
      expect(_event(status: 'Open').isRegistrationClosed, isFalse);
    });
  });

  group('normalizePhoneForCountry', () {
    test('accepts the same formats as the website', () {
      for (final input in [
        '050 123 4567',
        '50 123 4567',
        '+971 50 123 4567',
        '00971501234567',
      ]) {
        expect(normalizePhoneForCountry('971', input), '+971 501234567');
      }
    });

    test('rejects invalid numbers and other countries', () {
      expect(normalizePhoneForCountry('971', ''), isNull);
      expect(normalizePhoneForCountry('971', '123'), isNull);
      expect(normalizePhoneForCountry('971', '+44 7911 123456'), isNull);
    });
  });

  test('nationalities match the website list', () {
    expect(kNationalityCountries, hasLength(196));
    expect(kNationalityCountries, contains('United Arab Emirates'));
  });
}
