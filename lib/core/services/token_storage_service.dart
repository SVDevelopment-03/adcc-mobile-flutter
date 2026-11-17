import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Stores sign-in tokens in the platform's secure storage (Android Keystore /
/// iOS Keychain). Non-secret flags (guest, profile complete, user name) stay
/// in SharedPreferences.
///
/// Tokens saved by older app versions in SharedPreferences are moved to secure
/// storage the first time they are read, so existing users stay signed in.
class TokenStorageService {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _tokenExpiryKey = 'token_expiry';
  static const String _userIdKey = 'user_id';
  static const String _firebaseTokenKey = 'firebase_id_token';
  static const String _userNameKey = 'user_name';
  static const String _guestUserKey = 'is_guest_user';
  static const String _profileCompleteKey = 'profile_complete';

  /// Set in SharedPreferences once secure storage has been checked on this
  /// install. SharedPreferences is wiped on uninstall but the iOS Keychain is
  /// not, so a missing marker means "fresh install": stale Keychain tokens
  /// from a previous install are cleared instead of auto-signing the user in.
  static const String _secureReadyKey = 'secure_token_storage_ready';

  static const FlutterSecureStorage _secure = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  static const List<String> _secureKeys = [
    _accessTokenKey,
    _refreshTokenKey,
    _firebaseTokenKey,
    _userIdKey,
  ];

  static Future<void>? _ready;

  static Future<void> _ensureReady() => _ready ??= _prepare();

  static Future<void> _prepare() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_secureReadyKey) == true) return;

    // Tokens from an older app version (SharedPreferences) - keep them.
    final legacy = <String, String>{};
    for (final key in _secureKeys) {
      final value = prefs.getString(key);
      if (value != null && value.isNotEmpty) legacy[key] = value;
    }

    try {
      // Fresh install (or first run of this version): drop anything left in
      // the Keychain by a previous install, then move the legacy tokens.
      for (final key in _secureKeys) {
        await _secure.delete(key: key);
      }
      for (final entry in legacy.entries) {
        await _secure.write(key: entry.key, value: entry.value);
      }
      for (final key in legacy.keys) {
        await prefs.remove(key);
      }
      await prefs.setBool(_secureReadyKey, true);
    } catch (e) {
      // Leave the legacy values in place so the user is not signed out; the
      // migration is retried on the next app start.
      debugPrint('TokenStorageService: secure storage unavailable: $e');
      _ready = null;
    }
  }

  static Future<void> _writeSecure(String key, String value) async {
    await _ensureReady();
    try {
      await _secure.write(key: key, value: value);
    } catch (e) {
      // Keep the user signed in rather than losing the token.
      debugPrint('TokenStorageService: secure write failed for $key: $e');
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, value);
    }
  }

  static Future<String?> _readSecure(String key) async {
    await _ensureReady();
    try {
      final value = await _secure.read(key: key);
      if (value != null) return value;
    } catch (e) {
      debugPrint('TokenStorageService: secure read failed for $key: $e');
    }
    // Not migrated yet (secure storage failed earlier): fall back to legacy.
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<void> saveAccessToken(String token) =>
      _writeSecure(_accessTokenKey, token);

  static Future<String?> getAccessToken() => _readSecure(_accessTokenKey);

  static Future<void> saveRefreshToken(String token) =>
      _writeSecure(_refreshTokenKey, token);

  static Future<String?> getRefreshToken() => _readSecure(_refreshTokenKey);

  static Future<void> saveFirebaseToken(String token) =>
      _writeSecure(_firebaseTokenKey, token);

  static Future<String?> getFirebaseToken() => _readSecure(_firebaseTokenKey);

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

  static Future<void> saveUserId(String userId) =>
      _writeSecure(_userIdKey, userId);

  static Future<String?> getUserId() => _readSecure(_userIdKey);

  static Future<void> clearTokens() async {
    await _ensureReady();
    for (final key in _secureKeys) {
      try {
        await _secure.delete(key: key);
      } catch (e) {
        debugPrint('TokenStorageService: secure delete failed for $key: $e');
      }
    }
    final prefs = await SharedPreferences.getInstance();
    // Legacy copies too, in case secure storage was unavailable.
    for (final key in _secureKeys) {
      await prefs.remove(key);
    }
    await prefs.remove(_tokenExpiryKey);
    await prefs.remove(_userNameKey);
    await prefs.remove(_guestUserKey);
    await prefs.remove(_profileCompleteKey);
  }

  static Future<void> saveProfileComplete(bool isComplete) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_profileCompleteKey, isComplete);
  }

  static Future<bool> isProfileComplete() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_profileCompleteKey) ?? false;
  }

  static Future<void> saveUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userNameKey, name);
  }

  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userNameKey);
  }

  static Future<bool> hasValidAccessToken() async {
    final token = await getAccessToken();
    if (token == null || token.isEmpty) return false;

    final expiry = await getTokenExpiry();
    if (expiry == null) {
      // No expiry metadata was saved, so we cannot confirm expiration.
      // Assume the stored access token is still valid until the backend rejects it.
      return true;
    }

    final now = DateTime.now().millisecondsSinceEpoch;
    return now < expiry;
  }

  static Future<bool> isAuthenticated() async {
    final hasAccessToken = await hasValidAccessToken();
    if (hasAccessToken) return true;

    final firebaseToken = await getFirebaseToken();
    if (firebaseToken != null && firebaseToken.isNotEmpty) return true;

    final refreshToken = await getRefreshToken();
    if (refreshToken != null && refreshToken.isNotEmpty) return true;

    return false;
  }

  /// A guest session should not auto-route users into the home screen just
  /// because a guest token exists. Only a full registered user session should be
  /// treated as an automatic login state.
  static Future<bool> isRegisteredUserSession() async {
    if (await isGuestUser()) {
      return false;
    }

    return isAuthenticated();
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
