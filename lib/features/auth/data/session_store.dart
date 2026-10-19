import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:w2t_mobile/features/auth/data/models/auth_session.dart';

class SessionStore {
  SessionStore({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  static const _userIdKey = 'auth_user_id';
  static const _tokenKey = 'auth_access_token';
  static const _tokenTypeKey = 'auth_token_type';

  final FlutterSecureStorage _storage;

  Future<AuthSession?> read() async {
    try {
      final userId = await _storage.read(key: _userIdKey);
      final token = await _storage.read(key: _tokenKey);
      if (userId == null ||
          token == null ||
          userId.isEmpty ||
          token.isEmpty) {
        return null;
      }
      final tokenType = await _storage.read(key: _tokenTypeKey) ?? 'Bearer';
      return AuthSession(
        userId: userId,
        accessToken: token,
        tokenType: tokenType,
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> write(AuthSession session) async {
    await _storage.write(key: _userIdKey, value: session.userId);
    await _storage.write(key: _tokenKey, value: session.accessToken);
    await _storage.write(key: _tokenTypeKey, value: session.tokenType);
  }

  Future<void> clear() async {
    await _storage.delete(key: _userIdKey);
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _tokenTypeKey);
  }
}
