import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pgl_p2_myportfolio/app.dart';

Future<void> openDestination(WidgetTester tester, String label) async {
  await tester.tap(find.byTooltip('Open navigation menu'));
  await tester.pumpAndSettle();
  await tester.tap(find.widgetWithText(ListTile, label));
  await tester.pumpAndSettle();
}

Future<void> addElement(WidgetTester tester, String name) async {
  await tester.tap(find.widgetWithText(FilledButton, 'Añadir elemento'));
  await tester.pumpAndSettle();
  await tester.enterText(find.byType(TextFormField).first, name);
  await tester.enterText(find.byType(TextFormField).last, 'Una descripción');
  await tester.tap(find.text('Ocio nocturno'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Videojuegos').last);
  await tester.pumpAndSettle();
  await tester.tap(find.text('Guardar'));
  await tester.pumpAndSettle();
}

NocheIslasApp signedInApp() {
  FlutterSecureStorage.setMockInitialValues({'session_jwt': 'saved-token'});
  return NocheIslasApp(
    client: MockClient((request) async {
      expect(request.url.path, '/users/check-token');
      expect(request.headers['authorization'], 'Bearer saved-token');
      return http.Response('{"message":"Token v?lido"}', 200);
    }),
  );
}

void main() {
  testWidgets('Valida, añade y borra elementos desde el menú', (tester) async {
    await tester.pumpWidget(signedInApp());
    await tester.pumpAndSettle();
    await openDestination(tester, 'Mis elementos');

    await tester.tap(find.widgetWithText(FilledButton, 'Añadir elemento'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, '   ');
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();
    expect(find.text('Este campo es obligatorio'), findsNWidgets(2));
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();

    await addElement(tester, '  Plan uno  ');
    await addElement(tester, 'Plan dos');
    expect(find.text('Plan uno'), findsOneWidget);
    expect(find.text('Videojuegos'), findsNWidgets(2));
    expect(find.text('Total de elementos: 2'), findsOneWidget);

    await openDestination(tester, 'Mis elementos');
    expect(find.text('Total de elementos: 2'), findsOneWidget);
    await tester.tap(find.byTooltip('Borrar Plan uno'));
    await tester.pumpAndSettle();
    expect(find.text('Total de elementos: 1'), findsOneWidget);

    await tester.tap(find.text('Borrar todos'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();
    expect(find.text('Plan dos'), findsOneWidget);

    await tester.tap(find.text('Borrar todos'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Confirmar borrado'));
    await tester.pumpAndSettle();
    expect(find.text('Total de elementos: 0'), findsOneWidget);
    expect(
      tester.widget<OutlinedButton>(find.byType(OutlinedButton)).onPressed,
      isNull,
    );

    await addElement(tester, 'Plan temporal');
    await openDestination(tester, 'Inicio');
    await openDestination(tester, 'Mis elementos');
    expect(find.text('Total de elementos: 0'), findsOneWidget);
  });

  testWidgets('Permite navegar por el portfolio con texto ampliado', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 600));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(
          size: Size(320, 600),
          textScaler: TextScaler.linear(2),
        ),
        child: signedInApp(),
      ),
    );
    await tester.pumpAndSettle();
    await openDestination(tester, 'Mi portfolio');
    expect(find.textContaining('Arhamys'), findsOneWidget);
    await tester.tap(find.text('Hobbies'));
    await tester.pumpAndSettle();
    expect(find.text('Beber ánima'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
