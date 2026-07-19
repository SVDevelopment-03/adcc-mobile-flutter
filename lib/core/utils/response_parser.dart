class ResponseParser {
  ResponseParser._();

  static List<dynamic> extractList(
    dynamic response,
    List<String> candidateKeys,
  ) {
    if (response is List) return response;
    if (response is! Map<String, dynamic>) return const [];

    for (final key in candidateKeys) {
      final value = response[key];
      if (value is List) return value;

      if (value is Map<String, dynamic>) {
        for (final nestedKey in candidateKeys) {
          final nested = value[nestedKey];
          if (nested is List) return nested;
        }
      }
    }

    final data = response['data'];
    if (data is List) return data;

    if (data is Map<String, dynamic>) {
      for (final key in candidateKeys) {
        final value = data[key];
        if (value is List) return value;
      }
    }

    return const [];
  }

  static Map<String, dynamic>? extractMap(
    dynamic response,
    List<String> candidateKeys,
  ) {
    if (response is Map<String, dynamic>) {
      for (final key in candidateKeys) {
        final value = response[key];
        if (value is Map<String, dynamic>) return value;
      }

      final data = response['data'];
      if (data is Map<String, dynamic>) {
        for (final key in candidateKeys) {
          final nested = data[key];
          if (nested is Map<String, dynamic>) return nested;
        }
        return data;
      }

      return response;
    }
    return null;
  }

  static String asString(dynamic value, {String fallback = ''}) {
    if (value == null) return fallback;
    final str = value.toString().trim();
    return str.isEmpty ? fallback : str;
  }

  static int asInt(dynamic value, {int fallback = 0}) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? fallback;
    return fallback;
  }

  static double asDouble(dynamic value, {double fallback = 0}) {
    if (value is double) return value;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? fallback;
    return fallback;
  }

  static bool asBool(dynamic value, {bool fallback = false}) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      final normalized = value.trim().toLowerCase();
      if (normalized == 'true' || normalized == '1' || normalized == 'yes') {
        return true;
      }
      if (normalized == 'false' || normalized == '0' || normalized == 'no') {
        return false;
      }
    }
    return fallback;
  }
}
