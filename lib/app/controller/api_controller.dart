import 'package:clima_app2/app/service/getapi.dart';
import 'package:clima_app2/app/service/models.dart';
import 'package:flutter/material.dart';

class Weather extends ChangeNotifier {
  final WeatherService _service = WeatherService();
  WeatherModel? _weather;
  bool _isLoading = false;
  String? _error;

  
  WeatherModel? get weather => _weather;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchWeather()async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final WeatherModel? result = await _service.fetchWeather();

      if (result != null) {
        _weather = result;
      } else {
        _error = 'Erro ao carregar os dados do clima.';
      }
    } catch (e) {
      _error = 'Erro inesperado: $e';
    }

    _isLoading = false;
  }
}