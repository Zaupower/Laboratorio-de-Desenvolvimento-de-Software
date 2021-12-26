import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageHelper {
  static final _storage = FlutterSecureStorage();
  static final String _jwtTokenKey = "JWT";
  static final String _jwtTokenDataIDKey = "ID";
  static final String _jwtTokenDataEmailKey = "EMAIL";

  static void storeToken(String token) {
    _storage.write(key: _jwtTokenKey, value: token);
  }

  static Future<String> readToken() async {
    String token = await _storage.read(key: _jwtTokenKey);

    if (token == null) {
      return null;
    }

    return token;
  }

  static void storeTokenData(String tokenData) {
    _storage.write(
        key: _jwtTokenDataIDKey,
        value: jsonDecode(tokenData)["certserialnumber"]);
    _storage.write(
        key: _jwtTokenDataEmailKey, value: jsonDecode(tokenData)["email"]);
  }

  static Future<String> readTokenID() async {
    return await _storage.read(key: _jwtTokenDataIDKey);
  }

  static Future<String> readTokenEmail() async {
    return await _storage.read(key: _jwtTokenDataEmailKey);
  }

  static Future<void> deleteAllTokenData() async {
    await _storage.deleteAll();
  }
}

