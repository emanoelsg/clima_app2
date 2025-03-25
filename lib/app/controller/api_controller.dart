import 'package:clima_app2/app/service/getapi.dart';
import 'package:clima_app2/app/service/models.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class WeatherController extends ChangeNotifier {
  final WeatherService _service;
  WeatherModel? _weather;
  bool _isLoading = false;
  String? _error;

  WeatherController({WeatherService? service}) : _service = service ?? WeatherService();

  WeatherModel? get weather => _weather;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchWeather({String city = 'Caratinga,BR'}) async {
    if (_isLoading) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _weather = await _service.fetchWeather(city: city); // Passa a cidade para o serviço
    } catch (e) {
      _error = (e is DioException) ? "Erro de conexão." : "Dados não encontrados.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}