// test/lib/app/view/home_page_test.dart/home_page_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:clima_app2/app/controller/weather_controller.dart';
import 'package:clima_app2/app/models/weather_model/weather_model.dart';
import 'package:clima_app2/app/view/home_page/home_page.dart';
import 'package:clima_app2/app/view/search_screen/search_screen.dart';

void main() {
  setUp(() {
    Get.reset();
    Get.put(WeatherController());
  });

  testWidgets('Botão de cidade abre SearchScreen', (WidgetTester tester) async {
    final controller = Get.find<WeatherController>();

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
      weather: [
        Weather(
          id: 800,
          main: 'Clear',
          description: 'céu limpo',
          icon: '01d',
        )
      ],
      wind: Wind(speed: 5.0, deg: 180, gust: 7.0),
      coord: Coord(lon: -42.0, lat: -19.0),
      base: 'stations',
      visibility: 10000,
      rain: Rain(the1H: 0.0),
      clouds: Clouds(all: 0),
      dt: 1690000000,
      sys: Sys(
        type: 1,
        id: 1234,
        country: 'BR',
        sunrise: 1690000000,
        sunset: 1690040000,
      ),
      timezone: -10800,
      id: 123456,
      cod: 200,
    );

    await tester.pumpWidget(GetMaterialApp(home: HomeScreen()));
    await tester.tap(find.byIcon(Icons.location_on));
    await tester.pumpAndSettle();

    expect(find.byType(SearchScreen), findsOneWidget);
  });

  testWidgets('HomeScreen mostra dados de clima', (WidgetTester tester) async {
    final controller = Get.find<WeatherController>();

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
      weather: [
        Weather(
          id: 800,
          main: 'Clear',
          description: 'céu limpo',
          icon: '01d',
        )
      ],
      wind: Wind(speed: 5.0, deg: 180, gust: 7.0),
      coord: Coord(lon: -42.0, lat: -19.0),
      base: 'stations',
      visibility: 10000,
      rain: Rain(the1H: 0.0),
      clouds: Clouds(all: 0),
      dt: 1690000000,
      sys: Sys(
        type: 1,
        id: 1234,
        country: 'BR',
        sunrise: 1690000000,
        sunset: 1690040000,
      ),
      timezone: -10800,
      id: 123456,
      cod: 200,
    );

    await tester.pumpWidget(GetMaterialApp(home: HomeScreen()));

    expect(find.text('céu limpo'), findsOneWidget);
    expect(find.text('25°'), findsOneWidget);
    expect(find.textContaining('Umidade'), findsOneWidget);
    expect(find.textContaining('Pressão'), findsOneWidget);
    expect(find.textContaining('Vento'), findsOneWidget);
    expect(find.textContaining('1015'), findsOneWidget); // seaLevel
    expect(find.textContaining('1008'), findsOneWidget); // grndLevel
  });

  testWidgets('HomeScreen mostra mensagem de dados ausentes', (WidgetTester tester) async {
    final controller = Get.find<WeatherController>();
    controller.weather.value = null;

    await tester.pumpWidget(GetMaterialApp(home: HomeScreen()));
    expect(find.text('Sem dados disponíveis.'), findsOneWidget);
  });

  testWidgets('HomeScreen mostra mensagem de erro', (WidgetTester tester) async {
    final controller = Get.find<WeatherController>();
    controller.errorMessage.value = 'Erro ao carregar dados';

    await tester.pumpWidget(GetMaterialApp(home: HomeScreen()));
    expect(find.text('Erro ao carregar dados'), findsOneWidget);
  });

  testWidgets('HomeScreen mostra indicador de carregamento', (WidgetTester tester) async {
    final controller = Get.find<WeatherController>();
    controller.isLoading.value = true;

    await tester.pumpWidget(GetMaterialApp(home: HomeScreen()));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}