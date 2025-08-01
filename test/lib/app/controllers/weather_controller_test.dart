// test/lib/app/controllers/weather_controller_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_icons/weather_icons.dart';

import 'package:clima_app2/app/presentation/controller/weather_controller.dart';
import 'package:clima_app2/app/core/helpers/ui_helper.dart';
import 'package:clima_app2/app/data/models/daily_forecast/daily_forecast.dart';
import 'package:clima_app2/app/data/models/hourly_model/hourly_model.dart';
import 'package:clima_app2/app/data/models/weather_model/weather_model.dart';
import 'package:clima_app2/app/data/models/weekly_model/weekly_forecast_model.dart';
import 'package:clima_app2/app/data/service/weather_service.dart';

class MockStorage extends Mock implements GetStorage {}

class MockWeatherService extends Mock implements WeatherService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;

  late MockStorage mockStorage;
  late MockWeatherService mockService;
  late WeatherController controller;

  setUp(() {
    mockStorage = MockStorage();
    mockService = MockWeatherService();

    when(() => mockStorage.read(any())).thenReturn(null);
    when(() => mockStorage.write(any(), any())).thenAnswer((_) async {});

    controller = WeatherController(service: mockService, storage: mockStorage);
  });

  group('WeatherController - Propriedades básicas', () {
    test('testCity altera _currentCity corretamente', () {
      controller.testCity = 'Belo Horizonte';
      expect(controller.city, 'Belo Horizonte');
    });
  });

  group('WeatherController - salvar e carregar clima local', () {
    test('salvarClimaLocal salva dados no storage', () {
      final mockWeather = WeatherModel(
        coord: Coord(lon: -42.0, lat: -19.0),
        weather: [
          Weather(
            id: 800,
            main: 'Clear',
            description: 'céu limpo',
            icon: '01d',
          ),
        ],
        base: 'stations',
        main: Main(
          temp: 25.0,
          feelsLike: 26.0,
          tempMin: 22.0,
          tempMax: 28.0,
          pressure: 1012,
          humidity: 60,
          seaLevel: 1012,
          grndLevel: 1000,
        ),
        visibility: 10000,
        wind: Wind(speed: 3.5, deg: 180, gust: 5.0),
        rain: Rain(the1H: 0.0),
        clouds: Clouds(all: 0),
        dt: 1627776000,
        sys: Sys(
          type: 1,
          id: 1234,
          country: 'BR',
          sunrise: 1627730000,
          sunset: 1627776000,
        ),
        timezone: -10800,
        id: 123456,
        name: 'Caratinga',
        cod: 200,
      );

      controller.weather.value = mockWeather;
      controller.salvarClimaLocal();

      verify(
        () => mockStorage.write('clima_salvo', mockWeather.toJson()),
      ).called(1);
    });

    test('carregarClimaLocal lê dados do storage', () {
      final json = {
        'name': 'Caratinga',
        'weather': [
          {
            'id': 800,
            'main': 'Clear',
            'description': 'céu limpo',
            'icon': '01d',
          },
        ],
      };

      when(() => mockStorage.read('clima_salvo')).thenReturn(json);

      controller.carregarClimaLocal();

      expect(controller.weather.value?.name, 'Caratinga');
      expect(controller.weather.value?.weather.first.main, 'Clear');
    });
  });

  group('WeatherController - updateBackgroundGradient', () {
    test('atualiza gradiente com base na condição', () {
      controller.weather.value = WeatherModel(
        coord: null,
        weather: [Weather(id: 800, main: 'Clear', description: '', icon: '')],
        base: null,
        main: null,
        visibility: null,
        wind: null,
        rain: null,
        clouds: null,
        dt: null,
        sys: null,
        timezone: null,
        id: null,
        name: 'Caratinga',
        cod: null,
      );

      controller.updateBackgroundGradient();

      final gradient = controller.backgroundGradient.value as LinearGradient;
      expect(gradient.colors.first, const Color(0xFF47BFDF));
    });
  });

  group('WeatherController - fetchHourlyForecast', () {
    test('atualiza hourlyForecast com dados válidos', () async {
      final mockHourly = [
        HourlyForecast(time: '14:00', iconCode: '01d', temp: 26),
        HourlyForecast(time: '15:00', iconCode: '02d', temp: 27),
      ];

      when(
        () => mockService.getHourlyForecast(city: any(named: 'city')),
      ).thenAnswer((_) async => mockHourly);

      controller.weather.value = WeatherModel(
        name: 'Caratinga',
        coord: null,
        weather: [],
        base: '',
        main: null,
        visibility: null,
        wind: null,
        rain: null,
        clouds: null,
        dt: null,
        sys: null,
        timezone: null,
        id: null,
        cod: null,
      );

      await controller.fetchHourlyForecast();

      expect(controller.hourlyForecast.isNotEmpty, true);
      expect(controller.hourlyForecast.first.temp, 26);
    });

    test('mantém hourlyForecast vazio em caso de erro', () async {
      when(
        () => mockService.getHourlyForecast(city: any(named: 'city')),
      ).thenThrow(Exception('Erro'));

      controller.weather.value = WeatherModel(
        name: 'Caratinga',
        coord: null,
        weather: [],
        base: '',
        main: null,
        visibility: null,
        wind: null,
        rain: null,
        clouds: null,
        dt: null,
        sys: null,
        timezone: null,
        id: null,
        cod: null,
      );

      await controller.fetchHourlyForecast();

      expect(controller.hourlyForecast.isEmpty, true);
    });
  });

  group('WeatherController - fetchWeeklyForecast', () {
    test('atualiza weeklyForecast com dados válidos', () async {
      final mockWeekly = WeeklyForecast(
        daily: [
          DailyForecast(
            date: DateTime.fromMillisecondsSinceEpoch(1234567890),
            maxTemp: 28.0,
            minTemp: 18.0,
            condition: 'Clear',
            icon: '01d',
            precipitation: 0.0,
          ),
        ],
      );

      when(
        () => mockService.getWeeklyForecast(city: any(named: 'city')),
      ).thenAnswer((_) async => mockWeekly);

      controller.weather.value = WeatherModel(
        name: 'Caratinga',
        coord: null,
        weather: [],
        base: '',
        main: null,
        visibility: null,
        wind: null,
        rain: null,
        clouds: null,
        dt: null,
        sys: null,
        timezone: null,
        id: null,
        cod: null,
      );

      await controller.fetchWeeklyForecast();

      expect(controller.weeklyForecast.value, isNotNull);
      expect(controller.weeklyForecast.value!.daily.first.maxTemp, 28.0);
    });

    test('mantém weeklyForecast como null em caso de erro', () async {
      when(
        () => mockService.getWeeklyForecast(city: any(named: 'city')),
      ).thenThrow(Exception('Erro'));

      controller.weather.value = WeatherModel(
        name: 'Caratinga',
        coord: null,
        weather: [],
        base: '',
        main: null,
        visibility: null,
        wind: null,
        rain: null,
        clouds: null,
        dt: null,
        sys: null,
        timezone: null,
        id: null,
        cod: null,
      );

      await controller.fetchWeeklyForecast();

      expect(controller.weeklyForecast.value, isNull);
    });
  });

group('WeatherVisualHelper', () {
    test('getIconFromCode retorna ícone correto para 01d', () {
      final icon = WeatherVisualHelper.getIconFromCode('01d');
      expect(icon, WeatherIcons.day_sunny);
    });

    test('getIconFromCode retorna ícone padrão para código desconhecido', () {
      final icon = WeatherVisualHelper.getIconFromCode('xyz');
      expect(icon, WeatherIcons.na);
    });

    test('getGradient retorna gradiente correto para "Clear"', () {
      final gradient = WeatherVisualHelper.getGradient('Clear');
      expect(gradient, isA<LinearGradient>());
      expect((gradient as LinearGradient).colors.first, const Color(0xFF47BFDF));
    });

    test('getAccentColor retorna cor para "Thunderstorm"', () {
      final accent = WeatherVisualHelper.getAccentColor('Thunderstorm');
      expect(accent, const Color(0xFF1A237E));
    });

    test('getAccentColor retorna cor padrão para condição desconhecida', () {
      final accent = WeatherVisualHelper.getAccentColor('Volcanic Ash');
      expect(accent, const Color(0xFF2C3E50));
    });
  });

  group('WeatherController', () {
    test('fetchWeather atualiza weather e salva no cache', () async {
      final mockWeather = WeatherModel(name: 'Caratinga', weather: [], coord: null, base: '', main: null, visibility: null, wind: null, rain: null, clouds: null, dt: null, sys: null, timezone: null, id: null, cod: null);
      when(() => mockService.fetchWeather(city: any(named: 'city')))
          .thenAnswer((_) async => mockWeather);

      controller.testCity = 'Caratinga';
      await controller.fetchWeather();

      expect(controller.weather.value?.name, 'Caratinga');
      verify(() => mockStorage.write('clima_salvo', mockWeather.toJson())).called(1);
    });

    test('fetchWeather trata cidade nula', () async {
      controller.testCity = '';
      await controller.fetchWeather();
      expect(controller.errorMessage.value.contains('Cidade nula'), true);
    });

    test('fetchWeather trata timeout', () async {
      controller.testCity = 'Caratinga';
      when(() => mockService.fetchWeather(city: any(named: 'city')))
          .thenAnswer((_) => Future.delayed(const Duration(seconds: 10)));

      await controller.fetchWeather();
      expect(controller.errorMessage.value.contains('Tempo esgotado'), true);
    });

    test('fetchWeatherByCity atualiza cidade e salva cache', () async {
      final mockWeather = WeatherModel(name: 'BH', weather: [], coord: null, base: '', main: null, visibility: null, wind: null, rain: null, clouds: null, dt: null, sys: null, timezone: null, id: null, cod: null);
      when(() => mockService.fetchWeather(city: any(named: 'city')))
          .thenAnswer((_) async => mockWeather);

      await controller.fetchWeatherByCity('BH');

      expect(controller.weather.value?.name, 'BH');
      expect(controller.city, 'BH');
    });

    test('fetchWeatherByCity trata erro de cidade inválida', () async {
      when(() => mockService.fetchWeather(city: any(named: 'city')))
          .thenAnswer((_) async => null);

      await controller.fetchWeatherByCity('CidadeInexistente');
      expect(controller.errorMessage.value.contains('Cidade não encontrada'), true);
    });

    test('salvarClimaLocal não salva se weather for nulo', () {
      controller.weather.value = null;
      controller.salvarClimaLocal();
      verifyNever(() => mockStorage.write(any(), any()));
    });

    test('carregarClimaLocal carrega dados do storage', () {
      final json = {'name': 'Caratinga', 'weather': []};
      when(() => mockStorage.read('clima_salvo')).thenReturn(json);

      controller.carregarClimaLocal();
      expect(controller.weather.value?.name, 'Caratinga');
    });

    test('updateBackgroundGradient atualiza gradiente corretamente', () {
      controller.weather.value = WeatherModel(
        name: 'Caratinga',
        weather: [Weather(main: 'Clear', id: 0, description: '', icon: '')], coord: null, base: '', main: null, visibility: null, wind: null, rain: null, clouds: null, dt: null, sys: null, timezone: null, id: null, cod: null,
      );

      controller.updateBackgroundGradient();
      expect(controller.backgroundGradient.value.colors.first.value, isNotNull);
    });

    test('getWeatherIcon retorna ícone válido', () {
      final icon = controller.getWeatherIcon('01d');
      expect(icon.codePoint, isNotNull);
    });
  });

}
