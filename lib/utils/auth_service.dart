import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../model/jwt_model.dart';

class AuthService {
  final _storage = const FlutterSecureStorage();

  Future<JwtToken?> tryAutoLogin() async {
    debugPrint('Attempting auto login...');
    final token = await _storage.read(key: 'jwt');
    debugPrint('Token: $token');
    if (token == null) {
      debugPrint('No token found, auto login failed.');
      return null;
    }

    if (JwtDecoder.isExpired(token)) {
      debugPrint('Token is expired, auto login failed.');
      await _storage.delete(key: 'jwt');
      return null;
    }

    final decodedToken = JwtDecoder.decode(token);
    return JwtToken.fromDecodedToken(decodedToken);
  }

  Future<void> saveToken(String jwt) async {
    await _storage.write(key: 'jwt', value: jwt);
  }

  Future<void> logout() async {
    await _storage.delete(key: 'jwt');
  }
}
