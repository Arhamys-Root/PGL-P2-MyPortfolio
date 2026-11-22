import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class AuthResponse {
  const AuthResponse(this.statusCode, this.message, {this.token});

  final int statusCode;
  final String message;
  final String? token;

  bool get isSuccess => statusCode >= 200 && statusCode < 300;
}

class AuthApi {
  AuthApi(this._client);

  static const _baseUrl = String.fromEnvironment(
    'AUTH_API_URL',
    defaultValue: 'https://my-users-api.onrender.com',
  );
  final http.Client _client;

  Future<AuthResponse> register(
    String fullName,
    String email,
    String password,
  ) {
    return _request(
      'register',
      body: {'fullName': fullName, 'email': email, 'pwd': password},
    );
  }

  Future<AuthResponse> login(String email, String password) {
    return _request('login', body: {'email': email, 'pwd': password});
  }

  Future<AuthResponse> checkToken(String token) =>
      _request('check-token', token: token);

  Future<AuthResponse> welcome(String token) =>
      _request('welcome', token: token);

  Future<AuthResponse> _request(
    String endpoint, {
    Map<String, String>? body,
    String? token,
  }) async {
    try {
      final request = http.Request(
        body == null ? 'GET' : 'POST',
        Uri.parse(_baseUrl).resolve('/users/$endpoint'),
      );
      request.followRedirects = false;
      request.headers['Accept'] = 'application/json';
      if (token != null) request.headers['Authorization'] = 'Bearer $token';
      if (body != null) {
        request.headers['Content-Type'] = 'application/json';
        request.body = jsonEncode(body);
      }
      final response = await _client
          .send(request)
          .then(http.Response.fromStream)
          .timeout(const Duration(seconds: 30));
      return _decodeResponse(response);
    } on FormatException {
      return const AuthResponse(0, 'La API devolvió una respuesta inesperada.');
    } on TimeoutException {
      return const AuthResponse(0, 'La API tardó demasiado en responder.');
    } on http.ClientException {
      return const AuthResponse(0, 'No se pudo conectar con la API.');
    }
  }

  AuthResponse _decodeResponse(http.Response response) {
    final data = jsonDecode(utf8.decode(response.bodyBytes));
    if (data is Map<String, dynamic> && data['message'] is String) {
      final jwt = data['token'];
      return AuthResponse(
        response.statusCode,
        data['message'] as String,
        token: jwt is String && jwt.trim().isNotEmpty ? jwt : null,
      );
    }
    return const AuthResponse(0, 'La API devolvió una respuesta inesperada.');
  }
}
