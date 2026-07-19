import 'package:shared_preferences/shared_preferences.dart';

class TokenStorageService {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _tokenExpiryKey = 'token_expiry';
  static const String _userIdKey = 'user_id';
  static const String _firebaseTokenKey = 'firebase_id_token';
  static const String _userNameKey = 'user_name';
  static const String _guestUserKey = 'is_guest_user';

  static Future<void> saveAccessToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, token);
  }

  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  static Future<void> saveRefreshToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_refreshTokenKey, token);
  }

  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

  static Future<void> saveFirebaseToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_firebaseTokenKey, token);
  }

  static Future<String?> getFirebaseToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_firebaseTokenKey);
  }

  static Future<void> saveTokenExpiry(int timestamp) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_tokenExpiryKey, timestamp);
  }

  static Future<int?> getTokenExpiry() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_tokenExpiryKey);
  }

  static Future<bool> isTokenExpired() async {
    final expiry = await getTokenExpiry();
    if (expiry == null) return false;
    return DateTime.now().millisecondsSinceEpoch >= expiry;
  }

  static Future<void> saveUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, userId);
  }

  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  static Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
    await prefs.remove(_tokenExpiryKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_firebaseTokenKey);
    await prefs.remove(_userNameKey);
    await prefs.remove(_guestUserKey);
  }

  static Future<void> saveUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userNameKey, name);
  }

  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userNameKey);
  }

  static Future<bool> isAuthenticated() async {
    final token = await getFirebaseToken();
    if (token == null || token.isEmpty) return false;
    return true;
  }

  static Future<void> saveGuestUser(bool isGuest) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_guestUserKey, isGuest);
  }

  static Future<bool> isGuestUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_guestUserKey) ?? false;
  }
}
