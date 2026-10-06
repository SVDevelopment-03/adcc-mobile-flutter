import 'package:adcc/features/auth/Services/auth_services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthService OTP normalization', () {
    test('normalizes international phone numbers for OTP requests', () {
      expect(AuthService.normalizeRecipient('+966 50 123 4567'), '966501234567');
      expect(AuthService.normalizeRecipient('0501234567'), '0501234567');
      expect(AuthService.normalizeRecipient('  +971 5 555 8888  '), '97155558888');
    });

    test('returns empty string for blank values', () {
      expect(AuthService.normalizeRecipient(''), '');
      expect(AuthService.normalizeRecipient('   '), '');
      expect(AuthService.normalizeRecipient('+'), '');
    });
  });
}
