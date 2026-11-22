import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:pgl_p2_myportfolio/app.dart';

http.Response reply(int status, String message, {String? token}) =>
    http.Response.bytes(
      utf8.encode(jsonEncode({'message': message, 'token': ?token})),
      status,
      headers: {'content-type': 'application/json; charset=utf-8'},
    );

Future<void> press(WidgetTester tester, String label) async {
  await tester.tap(find.text(label));
  await tester.pumpAndSettle();
}

Future<void> enterCredentials(WidgetTester tester, String password) async {
  final fields = find.byType(TextFormField);
  await tester.enterText(
    fields.at(fields.evaluate().length - 2),
    'prueba@example.com',
  );
  await tester.enterText(fields.last, password);
}

void main() {
  testWidgets('Registro, login fallido, login correcto, bienvenida y logout', (
    tester,
  ) async {
    FlutterSecureStorage.setMockInitialValues({});
    const storage = FlutterSecureStorage();
    final requests = <String>[];
    final client = MockClient((request) async {
      requests.add(request.url.path);
      switch (request.url.path) {
        case '/users/register':
          expect(request.method, 'POST');
          expect(jsonDecode(request.body), {
            'fullName': 'Prueba Canaria',
            'email': 'prueba@example.com',
            'pwd': 'Segura123!',
          });
          return reply(201, 'Usuario registrado');
        case '/users/login':
          final data = jsonDecode(request.body) as Map<String, dynamic>;
          if (data['pwd'] != 'Segura123!') {
            return reply(409, 'Credenciales incorrectas');
          }
          return reply(200, 'Inicio correcto', token: 'test-jwt');
        case '/users/welcome':
          expect(request.headers['authorization'], 'Bearer test-jwt');
          return reply(200, 'Bienvenido, Prueba Canaria');
        default:
          fail('Ruta inesperada: ${request.url.path}');
      }
    });

    await tester.pumpWidget(NocheIslasApp(client: client));
    await tester.pumpAndSettle();
    expect(find.text('Iniciar sesión'), findsOneWidget);
    expect(find.byTooltip('Open navigation menu'), findsNothing);
    await press(tester, 'Crear cuenta');
    await tester.enterText(find.byType(TextFormField).first, 'Prueba Canaria');
    await enterCredentials(tester, 'débil');
    await press(tester, 'Registrar cuenta');
    expect(requests, isEmpty);
    await enterCredentials(tester, 'Segura123!');
    await press(tester, 'Registrar cuenta');
    expect(find.text('Usuario registrado'), findsOneWidget);
    await press(tester, 'Aceptar');
    expect(find.text('Iniciar sesión'), findsOneWidget);

    await enterCredentials(tester, 'incorrecta');
    await press(tester, 'Entrar');
    expect(find.text('Credenciales incorrectas'), findsOneWidget);
    await press(tester, 'Aceptar');
    await enterCredentials(tester, 'Segura123!');
    await press(tester, 'Entrar');
    expect(find.text('Inicio correcto'), findsOneWidget);
    await press(tester, 'Aceptar');
    expect(await storage.read(key: 'session_jwt'), 'test-jwt');

    await tester.scrollUntilVisible(find.text('Mensaje de bienvenida'), 150);
    await press(tester, 'Mensaje de bienvenida');
    expect(find.text('Bienvenido, Prueba Canaria'), findsOneWidget);
    await press(tester, 'Aceptar');
    await press(tester, 'Cerrar sesión');
    expect(find.text('Iniciar sesión'), findsOneWidget);
    expect(find.byTooltip('Open navigation menu'), findsNothing);
    expect(await storage.read(key: 'session_jwt'), isNull);
  });

  testWidgets('Elimina el token rechazado y mantiene el login', (tester) async {
    FlutterSecureStorage.setMockInitialValues({'session_jwt': 'expired-jwt'});
    const storage = FlutterSecureStorage();
    final client = MockClient((request) async {
      expect(request.url.path, '/users/check-token');
      expect(request.headers['authorization'], 'Bearer expired-jwt');
      return reply(401, 'Token caducado');
    });
    await tester.pumpWidget(NocheIslasApp(client: client));
    await tester.pumpAndSettle();
    expect(find.text('Iniciar sesión'), findsOneWidget);
    expect(find.text('Token caducado'), findsOneWidget);
    expect(find.byTooltip('Open navigation menu'), findsNothing);
    expect(await storage.read(key: 'session_jwt'), isNull);
  });
}
