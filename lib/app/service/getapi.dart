import 'package:clima_app2/app/service/models.dart';
import 'package:clima_app2/app/service/weekly.dart';
import 'package:dio/dio.dart';

class WeatherService {
  static const String _baseUrl = 
      'https://api.openweathermap.org/data/2.5/weather';
  static const String _apiKey = 'cee0977430f5831b5e35250897e0dac5';
  
  final Dio _dio;
  
  WeatherService({Dio? dio}) : _dio = dio ?? Dio();

  /// Busca dados meteorológicos para uma cidade específica
  /// [city] no formato "Cidade,País" (ex: "São Paulo,BR")
  /// Retorna [WeatherModel] ou null em caso de falha
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
        options: Options(
          receiveTimeout: const Duration(seconds: 10),
        ),
      );

      if (response.statusCode != 200) {
        throw Exception('Erro na API: ${response.statusCode}');
      }

      return WeatherModel.fromJson(response.data);
    } on DioException catch (e) {
      
      return null;
    } catch (e) {
      return null;
    }
  }
  // No WeatherService
Future<WeeklyForecast> getWeeklyForecast({required String city}) async {
  final response = await _dio.get(
    'https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=SUA_CHAVE&units=metric&lang=pt_br'
  );
  return WeeklyForecast.fromJson(response.data);
}
}