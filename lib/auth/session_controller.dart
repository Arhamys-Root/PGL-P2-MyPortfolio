import 'package:flutter/foundation.dart';

import 'auth_api.dart';
import 'session_token_store.dart';

typedef AuthOutcome = ({bool success, String message});

class SessionController extends ChangeNotifier {
  SessionController(this._api, this._tokenStore);

  final AuthApi _api;
  final SessionTokenStore _tokenStore;
  String? _token;
  String? _pendingToken;
  bool _restoring = true;
  String? _restoreError;
  bool _disposed = false;

  bool get isAuthenticated => _token != null;
  bool get isRestoring => _restoring;
  String? get restoreError => _restoreError;

  Future<void> restore() async {
    try {
      final token = await _tokenStore.read();
      if (token == null || token.isEmpty) return;

      final response = await _api.checkToken(token);
      if (response.isSuccess) {
        _token = token;
        return;
      }
      if (response.statusCode == 401) {
        await _tokenStore.delete();
      }
      _restoreError = response.message;
    } catch (_) {
      _restoreError = 'No se pudo recuperar la sesión guardada.';
    } finally {
      _restoring = false;
      if (!_disposed) notifyListeners();
    }
  }

  Future<AuthOutcome> register(
    String name,
    String email,
    String password,
  ) async {
    final response = await _api.register(name, email, password);
    return (success: response.isSuccess, message: response.message);
  }

  Future<AuthOutcome> signIn(String email, String password) async {
    final response = await _api.login(email, password);
    if (!response.isSuccess) {
      return (success: false, message: response.message);
    }
    final token = response.token;
    if (token == null) {
      return (
        success: false,
        message: 'La API no devolvió un token de sesión.',
      );
    }
    try {
      await _tokenStore.write(token);
    } catch (_) {
      return (
        success: false,
        message: 'No se pudo guardar la sesión de forma segura.',
      );
    }

    _pendingToken = token;
    return (success: true, message: response.message);
  }

  // Keep the login in view until the user acknowledges the result.
  void completeSignIn() {
    final token = _pendingToken;
    if (token == null) return;
    _pendingToken = null;
    _restoreError = null;
    _token = token;
    if (!_disposed) notifyListeners();
  }

  Future<AuthResponse> welcome() async {
    final token = _token;
    if (token == null) return const AuthResponse(401, 'Inicia sesión.');
    return _api.welcome(token);
  }

  Future<void> signOut() async {
    await _tokenStore.delete();
    _token = null;
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
