import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clima_app2/main.dart' as app;
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('App inicia e mostra loading', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}