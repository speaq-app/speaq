import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Handles the authentication, storage and usage of the users jwt token.
class TokenUtils {
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  static const String _tokenKey = "token";
  static String? _token;

  static init() async {
    _token = await _secureStorage.read(key: _tokenKey);
  }

  static Future<void> setToken(String? token) async {
    _token = token;
    await _secureStorage.write(key: _tokenKey, value: token);
  }

  static String? getToken() {
    return _token;
  }
}
