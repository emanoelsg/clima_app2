// app/controller/weather_controller.dart
import 'package:clima_app2/app/core/utils/helpers/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:async';
import 'package:clima_app2/app/models/weather_model/weather_model.dart';
import 'package:clima_app2/app/models/hourly_model/hourly_model.dart';
import 'package:clima_app2/app/models/weekly_model/weekly_forecast_model.dart';
import 'package:clima_app2/app/models/daily_forecast/daily_forecast.dart';
import 'package:clima_app2/app/service/weather_service.dart';
import 'package:clima_app2/app/core/utils/helpers/localization/localization.dart';

class WeatherController extends GetxController {

  final GetStorage storage;
  final WeatherService weatherService;

  final weather = Rxn<WeatherModel>();
  final weeklyForecast = Rxn<WeeklyForecast>();
  final hourlyForecast = <HourlyForecast>[].obs;
  final dailyForecast = <DailyForecast>[].obs;
  String? _currentCity;
  String get city => _currentCity ?? 'Cidade desconhecida';
  final backgroundGradient = Rx<Gradient>(
    const LinearGradient(
      colors: [Color(0xFF1E3C72), Color(0xFF2A5298)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
  );

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  WeatherController({WeatherService? service, GetStorage? storage})
    : weatherService = service ?? WeatherService(),
      storage = storage ?? GetStorage();

  String get condition => weather.value?.weather.first.main ?? 'Clear';
  @visibleForTesting
  set testCity(String city) {
    _currentCity = city;
  }

  @override
  void onInit() {
    super.onInit();
    debugPrint('[WeatherController] onInit chamado');
    loadAll();
  }

  Future<void> loadAll() async {
    debugPrint('[WeatherController] Iniciando loadAll');
    isLoading.value = true;
    errorMessage.value = '';

    try {
      if (_currentCity == null || _currentCity!.isEmpty) {
        _currentCity = await getCurrentCity();
      }

      if (_currentCity == null || _currentCity!.isEmpty) {
        errorMessage.value = 'Localização não disponível. Ligue o GPS.';
        debugPrint('[WeatherController] GPS falhou');
        carregarClimaLocal();
        return;
      }

      debugPrint('[WeatherController] Cidade detectada: $_currentCity');

      await fetchWeather();
      await Future.wait([fetchHourlyForecast(), fetchWeeklyForecast()]);
    } catch (e) {
      errorMessage.value = 'Erro ao carregar dados: $e';
      debugPrint('[WeatherController] Erro: $e');
      carregarClimaLocal();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchWeather() async {
    debugPrint('[WeatherController] Buscando clima para $_currentCity');
    isLoading.value = true;
    errorMessage.value = '';

    try {
      if (_currentCity == null || _currentCity!.isEmpty) {
        throw Exception('Cidade nula');
      }

      final result = await weatherService
          .fetchWeather(city: _currentCity!)
          .timeout(const Duration(seconds: 8));

      if (result == null) {
        errorMessage.value = 'Não foi possível obter os dados do clima.';
        debugPrint('[WeatherController] Clima não encontrado');
        carregarClimaLocal();
      } else {
        weather.value = result;
        salvarClimaLocal();
        debugPrint('[WeatherController] Clima: ${result.main?.temp}°C');
      }

      updateBackgroundGradient();
    } on TimeoutException {
      errorMessage.value =
          'Tempo esgotado. Verifique sua conexão com a internet.';
      carregarClimaLocal();
    } catch (e) {
      errorMessage.value = 'Erro ao buscar clima: $e';
      debugPrint('[WeatherController] Erro inesperado: $e');
      carregarClimaLocal();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchWeatherByCity(String city) async {
    debugPrint('[WeatherController] Buscando clima manual para: $city');
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await weatherService
          .fetchWeather(city: city)
          .timeout(const Duration(seconds: 8));

      if (result == null) {
        errorMessage.value = 'Cidade não encontrada ou erro na API.';
        debugPrint('[WeatherController] Falhou: $city');
        return;
      }

      weather.value = result;
      _currentCity = city;
      salvarClimaLocal();
      updateBackgroundGradient();

      debugPrint('[WeatherController] Clima manual: ${result.main?.temp}°C');

      await Future.wait([fetchHourlyForecast(), fetchWeeklyForecast()]);
    } catch (e) {
      errorMessage.value = 'Erro ao buscar clima: $e';
      debugPrint('[WeatherController] Erro: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchHourlyForecast() async {
    try {
      final city = weather.value?.name ?? _currentCity;
      if (city == null) throw Exception('Cidade nula');

      final list = await weatherService.getHourlyForecast(city: city);
      hourlyForecast.value = list;

      debugPrint('[WeatherController] Horas recebidas: ${list.length}');
    } catch (e) {
      errorMessage.value = 'Erro na previsão por hora: $e';
      debugPrint('[WeatherController] Forecast por hora falhou: $e');
    }
  }

  Future<void> fetchWeeklyForecast() async {
    try {
      final city = weather.value?.name ?? _currentCity;
      if (city == null) throw Exception('Cidade nula');

      final wf = await weatherService.getWeeklyForecast(city: city);
      weeklyForecast.value = wf;
      dailyForecast.value = wf.daily;

      debugPrint('[WeatherController] Semana recebida: ${wf.daily.length}');
    } catch (e) {
      errorMessage.value = 'Erro na previsão semanal: $e';
      debugPrint('[WeatherController] Forecast semanal falhou: $e');
    }
  }

  void salvarClimaLocal() {
    final data = weather.value?.toJson();
    if (data != null) {
      storage.write('clima_salvo', data);
      debugPrint('[WeatherController] Cache salvo');
    }
  }

  void carregarClimaLocal() {
    final json = storage.read('clima_salvo');
    if (json != null) {
      weather.value = WeatherModel.fromJson(json);
      debugPrint('[WeatherController] Cache carregado');
    } else {
      debugPrint('[WeatherController] Nenhum cache disponível');
    }
  }

  void updateBackgroundGradient() {
    backgroundGradient.value = WeatherUIHelper.getGradient(condition);
    debugPrint('[WeatherController] Gradiente para $condition');
  }

  IconData getWeatherIcon(String code) {
    return WeatherUIHelper.getIcon(code);
  }
}
