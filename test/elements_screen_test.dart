import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pgl_p2_myportfolio/screens/elements/elements_screen.dart';

void main() {
  testWidgets('Valida, crea y borra elementos con contador e imagen', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: ElementsScreen())),
    );
    expect(find.text('Total de elementos: 0'), findsOneWidget);
    await tester.tap(find.text('Añadir elemento'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();
    expect(find.text('Este campo es obligatorio'), findsNWidgets(2));
    await tester.enterText(find.byType(TextFormField).at(0), 'Mi juego');
    await tester.enterText(find.byType(TextFormField).at(1), 'Una aventura');
    await tester.tap(find.byType(DropdownButtonFormField<ElementCategory>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Videojuegos').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();
    expect(find.text('Total de elementos: 1'), findsOneWidget);
    expect(find.text('Mi juego'), findsOneWidget);
    expect(find.text('Videojuegos'), findsOneWidget);
    final image = tester.widget<Image>(find.byType(Image));
    expect(
      (image.image as AssetImage).assetName,
      'assets/images/denathrius.jpg',
    );

    expect(find.byIcon(Icons.edit_outlined), findsNothing);

    await tester.tap(find.text('Añadir elemento'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();
    expect(find.text('Total de elementos: 1'), findsOneWidget);
    await tester.tap(find.byTooltip('Borrar Mi juego'));
    await tester.pumpAndSettle();
    expect(find.text('Total de elementos: 0'), findsOneWidget);
    expect(find.text('Mi juego'), findsNothing);
  });
}
