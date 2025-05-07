import 'package:clima_app2/app/service/getapi.dart';
import 'package:clima_app2/app/service/models.dart';
import 'package:clima_app2/app/service/weekly.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class WeatherController extends ChangeNotifier {
  final WeatherService _service;
  WeatherModel? _weather;
  WeeklyForecast? _weeklyForecast;
  bool _isLoading = false;
  String? _error;

  WeatherController({WeatherService? service}) : _service = service ?? WeatherService();

  // Getters
  WeatherModel? get weather => _weather;
  WeeklyForecast? get weeklyForecast => _weeklyForecast;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Método para carregar todos os dados
  Future<void> fetchAllData() async {
    await fetchWeather();
    await fetchWeeklyForecast();
  }

  // Carrega dados atuais
  Future<void> fetchWeather({String city = 'Caratinga,BR'}) async {
    if (_isLoading) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _weather = await _service.fetchWeather(city: city);
    } catch (e) {
      _error = (e is DioException) ? "Erro de conexão." : "Dados não encontrados.";
      debugPrint('Erro ao buscar clima: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Carrega previsão semanal (APENAS UMA DECLARAÇÃO)
  Future<void> fetchWeeklyForecast({String city = 'Caratinga,BR'}) async {
    try {
      _isLoading = true;
      notifyListeners();

      _weeklyForecast = await _service.getWeeklyForecast(city: city);
    } catch (e) {
      _error = "Erro ao buscar previsão semanal";
      debugPrint('Erro na previsão semanal: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}