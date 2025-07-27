// test/lib/app/controllers/weather_controller_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:clima_app2/app/controller/weather_controller.dart';
import 'package:clima_app2/app/models/weather_model/weather_model.dart';
import 'package:clima_app2/app/models/hourly_model/hourly_model.dart';
import 'package:clima_app2/app/models/weekly_model/weekly_forecast_model.dart';
import 'package:clima_app2/app/service/weather_service.dart';
import 'weather_controller_test.mocks.dart';





@GenerateMocks([WeatherService])


void main() {TestWidgetsFlutterBinding.ensureInitialized();
  late WeatherController controller;
  late MockWeatherService mockService;
  setUpAll(() {

  });


  setUp(() {
    Get.reset();
    mockService = MockWeatherService();
    when(mockService.fetchWeather(city: argThat(isA<String>(), named: 'city')
))
        .thenAnswer((_) async => WeatherModel(
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
                pressure: 1013,
                humidity: 60,
                seaLevel: 1013,
                grndLevel: 1000,
              ),
              visibility: 10000,
              wind: Wind(speed: 5.0, deg: 180, gust: 7.0),
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
              name: 'Caratinga',
              cod: 200,
            ));

    when(mockService.getHourlyForecast(city:argThat(isA<String>(), named: 'city')
))
        .thenAnswer((_) async => [
              HourlyForecast(time: '12:00', iconCode: '01d', temp: 25)
            ]);

    when(mockService.getWeeklyForecast(city: argThat(isA<String>(), named: 'city')
))
        .thenAnswer((_) async => WeeklyForecast(daily: []));

    controller = WeatherController(service: mockService);

    // Adiciona setter para testes (caso não exista no controller)
    controller.testCity = 'Caratinga';
  });

  test('loadAll com erro retorna mensagem de erro', () async {
    when(mockService.fetchWeather(city:argThat(isA<String>(), named: 'city')
))
        .thenThrow(Exception('Erro de rede'));

    controller.testCity = 'Caratinga';

    await controller.loadAll();

    expect(controller.errorMessage.value, isNotEmpty);
  });

  test('loadAll com cidade detectada atualiza dados corretamente', () async {
    controller.testCity = 'Caratinga';

    await controller.loadAll();

    expect(controller.weather.value?.name, 'Caratinga');
    expect(controller.hourlyForecast.length, greaterThan(0));
    expect(controller.weeklyForecast.value, isA<WeeklyForecast>());
    expect(controller.errorMessage.value, isEmpty);
  });
}

