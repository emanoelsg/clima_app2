// test/lib/app/controllers/weather_controller_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_icons/weather_icons.dart';

import 'package:clima_app2/app/controller/weather_controller.dart';
import 'package:clima_app2/app/core/utils/helpers/get_background/background_theme.dart';
import 'package:clima_app2/app/core/utils/helpers/get_icon/weather_icon.dart';
import 'package:clima_app2/app/core/utils/helpers/ui_helper.dart';
import 'package:clima_app2/app/models/daily_forecast/daily_forecast.dart';
import 'package:clima_app2/app/models/hourly_model/hourly_model.dart';
import 'package:clima_app2/app/models/weather_model/weather_model.dart';
import 'package:clima_app2/app/models/weekly_model/weekly_forecast_model.dart';
import 'package:clima_app2/app/service/weather_service.dart';

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
        weather: [Weather(id: 800, main: 'Clear', description: 'céu limpo', icon: '01d')],
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
        sys: Sys(type: 1, id: 1234, country: 'BR', sunrise: 1627730000, sunset: 1627776000),
        timezone: -10800,
        id: 123456,
        name: 'Caratinga',
        cod: 200,
      );

      controller.weather.value = mockWeather;
      controller.salvarClimaLocal();

      verify(() => mockStorage.write('clima_salvo', mockWeather.toJson())).called(1);
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
          }
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

      when(() => mockService.getHourlyForecast(city: any(named: 'city')))
          .thenAnswer((_) async => mockHourly);

      controller.weather.value = WeatherModel(name: 'Caratinga', coord: null, weather: [], base: '', main: null, visibility: null, wind: null, rain: null, clouds: null, dt: null, sys: null, timezone: null, id: null, cod: null);

      await controller.fetchHourlyForecast();

      expect(controller.hourlyForecast.isNotEmpty, true);
      expect(controller.hourlyForecast.first.temp, 26);
    });

    test('mantém hourlyForecast vazio em caso de erro', () async {
      when(() => mockService.getHourlyForecast(city: any(named: 'city')))
          .thenThrow(Exception('Erro'));

      controller.weather.value = WeatherModel(name: 'Caratinga', coord: null, weather: [], base: '', main: null, visibility: null, wind: null, rain: null, clouds: null, dt: null, sys: null, timezone: null, id: null, cod: null);

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
          )
        ],
      );

      when(() => mockService.getWeeklyForecast(city: any(named: 'city')))
          .thenAnswer((_) async => mockWeekly);

      controller.weather.value = WeatherModel(name: 'Caratinga', coord: null, weather: [], base: '', main: null, visibility: null, wind: null, rain: null, clouds: null, dt: null, sys: null, timezone: null, id: null, cod: null);

      await controller.fetchWeeklyForecast();

      expect(controller.weeklyForecast.value, isNotNull);
      expect(controller.weeklyForecast.value!.daily.first.maxTemp, 28.0);
    });

    test('mantém weeklyForecast como null em caso de erro', () async {
      when(() => mockService.getWeeklyForecast(city: any(named: 'city')))
          .thenThrow(Exception('Erro'));

      controller.weather.value = WeatherModel(name: 'Caratinga', coord: null, weather: [], base: '', main: null, visibility: null, wind: null, rain: null, clouds: null, dt: null, sys: null, timezone: null, id: null, cod: null);

      await controller.fetchWeeklyForecast();

      expect(controller.weeklyForecast.value, isNull);
    });
  });

  group('WeatherUIHelper', () {
    test('getIcon retorna ícone correto para 01d', () {
      final icon = WeatherUIHelper.getIcon('01d');
      expect(icon, WeatherIcons.day_sunny);
    });

    test('getGradient retorna gradiente correto para "clear"', () {
      final gradient = WeatherUIHelper.getGradient('clear');
      expect(gradient.colors.first, const Color(0xFF47BFDF));
    });
  });

  group('WeatherIconMapper', () {
    test('retorna ícone correto para código 01d', () {
      final icon = WeatherIconMapper.fromCode('01d');
      expect(icon, WeatherIcons.day_sunny);
    });

    test('retorna ícone padrão para código desconhecido', () {
      final icon = WeatherIconMapper.fromCode('xyz');
      expect(icon, WeatherIcons.na);
    });
  });

  group('WeatherBackground', () {
    test('getGradient retorna gradiente para condição conhecida', () {
      final gradient = WeatherBackground.getGradient('clear sky');
      expect(gradient, [Color(0xFF47BFDF), Color(0xFF4A91FF)]);
    });

    test('getAccent retorna cor para condição thunderstorm', () {
      final accent = WeatherBackground.getAccent('thunderstorm');
      expect(accent, const Color(0xFF1A237E));
    });

    test('getAccent retorna cor padrão para condição desconhecida', () {
      final accent = WeatherBackground.getAccent('volcanic ash');
      expect(accent, const Color(0xFF2C3E50));
    });
  });
}