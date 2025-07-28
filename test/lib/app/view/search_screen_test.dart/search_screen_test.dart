// test/lib/app/view/search_screen_test.dart/search_screen_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:clima_app2/app/controller/weather_controller.dart';
import 'package:clima_app2/app/view/search_screen/search_screen.dart';

void main() {
  testWidgets('SearchScreen UI and interaction test', (WidgetTester tester) async {
    // Mock controller
    final controller = WeatherController();
    Get.put(controller);

    await tester.pumpWidget(
      GetMaterialApp(home: const SearchScreen()),
    );

    // Verifica se o campo de texto está presente
    expect(find.byType(TextField), findsOneWidget);

    // Digita uma cidade
    await tester.enterText(find.byType(TextField), 'São Paulo');

    // Pressiona o botão de buscar
    await tester.tap(find.widgetWithText(ElevatedButton, 'Buscar'));
    await tester.pump(); // atualiza a UI

    // Verifica se o controller foi chamado
    expect(controller.isLoading.value, true);
  });
}