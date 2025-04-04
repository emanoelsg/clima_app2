// ignore_for_file: unused_local_variable

import 'package:clima_app2/app/service/models.dart';
import 'package:dio/dio.dart';

class WeatherService {
  static const String _baseUrl =
      'http://api.openweathermap.org/data/2.5/forecast';
  static const String _apiKey = 'cee0977430f5831b5e35250897e0dac5';

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

      final response = await _dio.get(_baseUrl, queryParameters: params);

      if (response.statusCode != 200) {
        throw Exception('Failed to load weather: ${response.statusCode}');
      }

      return WeatherModel.fromJson(response.data);
    } on DioException catch (e) {
      String dioError= 'Network error: ${e.message}';
      return null;
    } catch (e) {
      String dioError=('Unexpected error: $e');
      return null;
    }
  }
}
