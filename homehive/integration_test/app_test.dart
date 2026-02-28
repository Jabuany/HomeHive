import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:homehive/main/mainPage.dart';
import 'package:integration_test/integration_test.dart';
import 'package:homehive/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Login correcto inquilino', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('emailField')), 'inquilino');
    print('Email ingresado');

    await tester.enterText(
      find.byKey(const Key('passwordField')),
      'inquilino123',
    );

    await tester.tap(find.byKey(const Key('loginButton')));
    print('Botón presionado');

    await tester.pumpAndSettle();

   final mainPageFinder = find.byType(MainPage);

    if (mainPageFinder.evaluate().isNotEmpty) {
      print("Login exitoso");
    } else {
      print("Login falló");
    }

    expect(mainPageFinder, findsOneWidget);
  });
}
