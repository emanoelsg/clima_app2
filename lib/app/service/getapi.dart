import 'package:clima_app2/app/models/weather_model/weather_model.dart';
import 'package:dio/dio.dart';
import 'package:clima_app2/app/models/weekly_model/weekly_forecast_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherService {
  static const String _baseUrl =
      'https://api.openweathermap.org/data/2.5/weather';
  final _apiKey = dotenv.env['OPENWEATHER_API_KEY']!;
  static const String _weeklyBaseUrl =
      'https://api.openweathermap.org/data/2.5/forecast';
  final Dio _dio;

  WeatherService({Dio? dio}) : _dio = dio ?? Dio();
  Future<WeatherModel?> fetchWeather({required String city}) async {
    try {
      final params = {
        'q': city,
        'appid': _apiKey,
        'lang': 'pt_br',
        'units': 'metric',
      };

      final response = await _dio.get(
        _baseUrl,
        queryParameters: params,
        options: Options(receiveTimeout: const Duration(seconds: 10)),
      );

      if (response.statusCode != 200) {
        throw Exception('Erro na API: ${response.statusCode}');
      }

      return WeatherModel.fromJson(response.data);
    } on DioException {
      return null;
    } catch (e) {
      return null;
    }
  }

  // No WeatherService
  Future<WeeklyForecast> getWeeklyForecast({required String city}) async {
    try {
      final params = {
        'q': city,
        'appid': _apiKey,
        'lang': 'pt_br',
        'units': 'metric',
      };
      final response = await _dio.get(
        _weeklyBaseUrl,
        queryParameters: params,
        options: Options(receiveTimeout: const Duration(seconds: 10)),
      );
      if (response.statusCode != 200) {
        throw Exception('Erro na API: ${response.statusCode}');
      }
      return WeeklyForecast.fromJson(response.data);
    } on DioException {
      return WeeklyForecast(daily: []);
    }
  }
}
