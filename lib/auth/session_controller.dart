import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'auth_api.dart';

class SessionController extends ChangeNotifier {
  SessionController(this.api, this._storage);

  static const _tokenKey = 'session_jwt';
  final AuthApi api;
  final FlutterSecureStorage _storage;
  String? _token;
  bool _restoring = true;
  String? restoreError;
  bool _disposed = false;

  bool get isAuthenticated => _token != null;
  bool get isRestoring => _restoring;

  Future<void> restore() async {
    try {
      final token = await _storage.read(key: _tokenKey);
      if (token == null || token.isEmpty) return;

      final response = await api.checkToken(token);
      if (response.isSuccess) {
        _token = token;
        return;
      }
      if (response.statusCode == 401) {
        await _storage.delete(key: _tokenKey);
      }
      restoreError = response.message;
    } catch (_) {
      restoreError = 'No se pudo recuperar la sesión guardada.';
    } finally {
      _restoring = false;
      if (!_disposed) notifyListeners();
    }
  }

  Future<void> start(String token) async {
    await _storage.write(key: _tokenKey, value: token);
    _token = token;
    if (!_disposed) notifyListeners();
  }

  Future<AuthResponse> welcome() async {
    final token = _token;
    if (token == null) return const AuthResponse(401, 'Inicia sesión.');
    return api.welcome(token);
  }

  Future<void> signOut() async {
    await _storage.delete(key: _tokenKey);
    _token = null;
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
