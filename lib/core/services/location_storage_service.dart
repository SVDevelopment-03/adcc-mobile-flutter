import 'package:shared_preferences/shared_preferences.dart';

class LocationStorageService {
  static const _latKey = 'latitude';
  static const _lngKey = 'longitude';
  static const _cityKey = 'city';

  static Future<void> saveLocation({
    required double latitude,
    required double longitude,
    required String city,

  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_latKey, latitude);
    await prefs.setDouble(_lngKey, longitude);
    await prefs.setString(_cityKey, city);
  }

  static Future<Map<String, dynamic>?> getLocation() async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey(_latKey)) return null;

    return {
      'latitude': prefs.getDouble(_latKey),
      'longitude': prefs.getDouble(_lngKey),
      'city': prefs.getString(_cityKey),
    };
  }

  static Future<void> clearLocation() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_latKey);
    await prefs.remove(_lngKey);
    await prefs.remove(_cityKey);
  }
}
