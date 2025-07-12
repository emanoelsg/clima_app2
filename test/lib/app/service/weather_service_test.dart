import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:clima_app2/app/models/weather_model/weather_model.dart';
import 'package:clima_app2/app/models/weather_model/weather_model_extension.dart';

import 'package:clima_app2/app/models/weekly_model/weekly_forecast_model.dart';
import 'package:clima_app2/app/service/weather_service.dart';
import 'weather_service_test.mocks.dart';


  @GenerateMocks([Dio])
void main() {
  group('WeatherService', () {
    late MockDio mockDio;
    late WeatherService service;

    setUp(() {
      mockDio = MockDio();
      service = WeatherService(dio: mockDio, apiKey: 'fake_key');
    });
   
   test('fetchWeather retorna WeatherModel com cidade válida', () async {
  final mockResponse = Response(
    requestOptions: RequestOptions(path: ''),
    statusCode: 200,
    data: {
      "coord": {"lon": -43.2, "lat": -22.9},
      "weather": [
        {
          "id": 800,
          "main": "Clear",
          "description": "céu limpo",
          "icon": "01d"
        }
      ],
      "main": {
        "temp": 25.0,
        "feels_like": 26.0,
        "temp_min": 24.0,
        "temp_max": 27.0,
        "pressure": 1012,
        "humidity": 60
      },
      "name": "Rio de Janeiro"
    },
  );

  when(
    mockDio.get(
      any,
      queryParameters: anyNamed('queryParameters'),
      options: anyNamed('options'),
    ),
  ).thenAnswer((_) async => mockResponse);

  final result = await service.fetchWeather(city: 'Rio de Janeiro,BR');

  expect(result, isA<WeatherModel>());
  expect(result?.city, 'Rio de Janeiro');

});

   test('getWeeklyForecast retorna dados com cidade válida', () async {
  final mockResponse = Response(
  requestOptions: RequestOptions(path: ''),
  statusCode: 200,
  data: {
    "list": [
      {
        "dt": 1751880000, // 2025-07-07 12:00:00 UTC
        "dt_txt": "2025-07-07 12:00:00",
        "main": {"temp": 25.0},
        "weather": [
          {"description": "ensolarado", "icon": "01d"}
        ]
      },
      {
        "dt": 1751966400, // 2025-07-08 12:00:00 UTC
        "dt_txt": "2025-07-08 12:00:00",
        "main": {"temp": 22.0},
        "weather": [
          {"description": "nublado", "icon": "02d"}
        ]
      },
      {
        "dt": 1752052800, // 2025-07-09 12:00:00 UTC
        "dt_txt": "2025-07-09 12:00:00",
        "main": {"temp": 20.0},
        "weather": [
          {"description": "chuva", "icon": "09d"}
        ]
      },
    ]
  },
);


  when(
    mockDio.get(
      any,
      queryParameters: anyNamed('queryParameters'),
      options: anyNamed('options'),
    ),
  ).thenAnswer((_) async => mockResponse);

  final result = await service.getWeeklyForecast(city: 'Rio de Janeiro');


  expect(result, isA<WeeklyForecast>());
  expect(result.daily, hasLength(3));
});
    test('fetchWeather retorna null com cidade inválida', () async {
      when(
        mockDio.get(
          any,
          queryParameters: anyNamed('queryParameters'),
          options: anyNamed('options'),
        ),
      ).thenThrow(DioException(requestOptions: RequestOptions(path: '')));

      final result = await service.fetchWeather(city: 'CidadeInvalida');

      expect(result, isNull);
    });
  });

 
}
