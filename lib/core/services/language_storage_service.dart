import 'package:shared_preferences/shared_preferences.dart';

class LanguageStorageService {
  static const _keyLocaleCode = 'app_locale_code';

  static Future<String?> getLocaleCode() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_keyLocaleCode);
    if (code == null || code.trim().isEmpty) return null;
    return code;
  }

  static Future<bool> hasLocaleCode() async {
    final code = await getLocaleCode();
    return code != null && code.isNotEmpty;
  }

  static Future<void> setLocaleCode(String code) async {
    final normalized = code.trim();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLocaleCode, normalized);
  }
}

