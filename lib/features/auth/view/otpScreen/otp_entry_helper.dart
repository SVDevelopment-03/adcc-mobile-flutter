class OtpEntryHelper {
  static const int otpLength = 6;

  static String sanitizeDigits(String value) {
    return value.replaceAll(RegExp(r'\D'), '');
  }

  static String buildCode(List<String> values) {
    return values.map((value) => value.trim()).join();
  }

  static bool isCompleteCode(String code) {
    final digits = sanitizeDigits(code);
    return digits.length == otpLength;
  }

  static List<String> splitCode(String code, {int length = otpLength}) {
    final digits = sanitizeDigits(code);
    return List.generate(
      length,
      (index) => index < digits.length ? digits[index] : '',
    );
  }

  static int? nextIndexAfterEntry(
    int currentIndex,
    String rawValue, {
    int totalLength = otpLength,
  }) {
    if (sanitizeDigits(rawValue).isEmpty) {
      return null;
    }

    if (currentIndex >= totalLength - 1) {
      return null;
    }

    return currentIndex + 1;
  }
}
