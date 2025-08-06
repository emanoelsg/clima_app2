// app/service/weather_service.dart
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:clima_app2/app/data/models/weather_model/weather_model.dart';
import 'package:clima_app2/app/data/models/hourly_model/hourly_model.dart';
import 'package:clima_app2/app/data/models/weekly_model/weekly_forecast_model.dart';
import 'package:clima_app2/app/core/config/api_keys/api_keys.dart';

class WeatherService {
  static const String _baseUrl =
      'https://api.openweathermap.org/data/2.5/weather';
  static const String _forecastUrl =
      'https://api.openweathermap.org/data/2.5/forecast';
  static const Duration _timeout = Duration(seconds: 10);

  final Dio _dio;
  final String _apiKey;

  WeatherService({Dio? dio, String? apiKey})
    : _dio = dio ?? Dio(),
      _apiKey = apiKey ?? ApiKeys.openWeather;

  /// 🔧 Constrói os parâmetros da requisição
  Map<String, dynamic> _buildQuery(String city) => {
    'q': city,
    'appid': _apiKey,
    'units': 'metric',
    'lang': 'pt_br',
  };

  /// 🌤️ Busca o clima atual
  Future<WeatherModel?> fetchWeather({required String city}) async {
    try {
      final response = await _dio.get(
        _baseUrl,
        queryParameters: _buildQuery(city),
        options: Options(receiveTimeout: _timeout),
      );

      if (response.statusCode != 200) return null;

      return WeatherModel.fromJson(response.data);
    } on DioException {
      return null;
    }
  }

  /// 📅 Busca a previsão semanal (agrupada por dia)
  Future<WeeklyForecast> getWeeklyForecast({required String city}) async {
    try {
      final response = await _dio.get(
        _forecastUrl,
        queryParameters: _buildQuery(city),
        options: Options(receiveTimeout: _timeout),
      );

      if (response.statusCode != 200) return WeeklyForecast(daily: []);

      return WeeklyForecast.fromJson(response.data);
    } on DioException {
      return WeeklyForecast(daily: []);
    }
  }

  /// ⏰ Busca a previsão por hora (próximas 8 horas)
  Future<List<HourlyForecast>> getHourlyForecast({required String city}) async {
    try {
      final response = await _dio.get(
        _forecastUrl,
        queryParameters: _buildQuery(city),
        options: Options(receiveTimeout: _timeout),
      );

      final List list = response.data['list'];

      return list.take(8).map((item) {
        final dt = DateTime.parse(item['dt_txt']);
        final weatherList = item['weather'] as List?;
        final iconCode =
            weatherList?.isNotEmpty == true
                ? weatherList![0]['icon'] as String? ?? '01d'
                : '01d';
        final temp = (item['main']['temp'] as num).round();

        return HourlyForecast(
          time: '${dt.hour.toString().padLeft(2, '0')}:00',
          iconCode: iconCode,
          temp: temp,
        );
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao buscar previsão por hora: $e');
      }
      return [];
    }
  }
}
