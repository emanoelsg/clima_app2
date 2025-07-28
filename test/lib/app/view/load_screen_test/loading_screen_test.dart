// test/lib/app/view/load_screen_test/loading_screen_test.dart

import 'package:clima_app2/app/controller/weather_controller.dart';
import 'package:clima_app2/app/models/weather_model/weather_model.dart';
import 'package:clima_app2/app/view/load_screen/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
void main() {
  testWidgets('LoadingScreen mostra logo, frase e barra de progresso', (tester) async {
  Get.put(WeatherController());

  await tester.pumpWidget(GetMaterialApp(home: LoadingScreen()));

  expect(find.byType(Image), findsOneWidget);
  expect(find.byType(LinearProgressIndicator), findsOneWidget);
  expect(find.textContaining('Buscando clima'), findsOneWidget);
});
  testWidgets('LoadingScreen navega para Home quando dados são carregados', (tester) async {
  final controller = Get.put(WeatherController());

  await tester.pumpWidget(GetMaterialApp(
    initialRoute: '/',
    getPages: [
      GetPage(name: '/', page: () => const LoadingScreen()),
      GetPage(name: '/home', page: () => const Scaffold(body: Text('Home'))),
    ],
  ));

  controller.weather.value = WeatherModel(
    name: 'Caratinga',
    main: Main(
      temp: 25.0,
      feelsLike: 26.0,
      tempMin: 22.0,
      tempMax: 28.0,
      pressure: 1013,
      humidity: 60,
      seaLevel: 1015,
      grndLevel: 1008,
    ),
    weather: [Weather(id: 800, main: 'Clear', description: 'céu limpo', icon: '01d')],
    wind: Wind(speed: 5.0, deg: 180, gust: 7.0),
    coord: Coord(lon: -42.0, lat: -19.0),
    base: 'stations',
    visibility: 10000,
    rain: Rain(the1H: 0.0),
    clouds: Clouds(all: 0),
    dt: 1690000000,
    sys: Sys(type: 1, id: 1234, country: 'BR', sunrise: 1690000000, sunset: 1690040000),
    timezone: -10800,
    id: 123456,
    cod: 200,
  );

  controller.isLoading.value = false;

  await tester.pump(); // inicia o Obx
  await tester.pump(const Duration(milliseconds: 100)); // tempo para microtask

  expect(find.text('Home'), findsOneWidget);
});
}