import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SessionTokenStore {
  const SessionTokenStore(this._storage);

  static const _key = 'session_jwt';
  final FlutterSecureStorage _storage;

  Future<String?> read() => _storage.read(key: _key);

  Future<void> write(String token) => _storage.write(key: _key, value: token);

  Future<void> delete() => _storage.delete(key: _key);
}
