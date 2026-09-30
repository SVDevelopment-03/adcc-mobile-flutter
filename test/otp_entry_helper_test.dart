import 'package:adcc/features/auth/view/otpScreen/otp_entry_helper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OtpEntryHelper', () {
    test('sanitizes digits from pasted or SMS values', () {
      expect(OtpEntryHelper.sanitizeDigits('12a3b4c5d6'), '123456');
    });

    test('fills six digits and marks completion', () {
      final split = OtpEntryHelper.splitCode('123456');
      expect(split, ['1', '2', '3', '4', '5', '6']);
      expect(OtpEntryHelper.isCompleteCode('123456'), isTrue);
    });

    test('moves focus to the next box for non-empty entry', () {
      expect(OtpEntryHelper.nextIndexAfterEntry(2, '7'), 3);
      expect(OtpEntryHelper.nextIndexAfterEntry(5, '9'), isNull);
    });
  });
}
