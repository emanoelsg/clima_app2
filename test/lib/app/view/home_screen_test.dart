import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:clima_app2/app/controller/api_controller.dart';
import 'package:clima_app2/app/view/home_page/home_page.dart';
import 'package:clima_app2/app/core/theme/app_theme.dart';


void main() {
  testWidgets('HomeScreen mostra loading quando weather é null', (tester) async {
    Get.put(WeatherController());

    await tester.pumpWidget(GetMaterialApp
    (
    theme: AppTheme.test,       
    home: const HomeScreen(),

));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}