// app/presentation/controller/weather_controller.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:geolocator/geolocator.dart';

import 'package:clima_app2/app/data/service/weather_service.dart';
import 'package:clima_app2/app/data/models/weather_model/weather_model.dart';
import 'package:clima_app2/app/data/models/hourly_model/hourly_model.dart';
import 'package:clima_app2/app/data/models/weekly_model/weekly_forecast_model.dart';
import 'package:clima_app2/app/data/models/daily_forecast/daily_forecast.dart';

import 'package:clima_app2/app/core/helpers/ui_helper.dart';
import 'package:clima_app2/app/core/helpers/localization/localization.dart';

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
  final isOfflineMode = false.obs;

  WeatherController({WeatherService? service, GetStorage? storage})
      : weatherService = service ?? WeatherService(),
        storage = storage ?? GetStorage();

  String get condition => weather.value?.weather.first.main ?? 'Clear';

  @visibleForTesting
  set testCity(String city) => _currentCity = city;

  @override
  void onInit() {
    super.onInit();
    debugPrint('[WeatherController] onInit chamado');
    loadAll();
  }

  /// 🔐 Verifica permissão de localização
  Future<bool> verificarPermissaoLocalizacao() async {
    LocationPermission status = await Geolocator.checkPermission();
    if (status == LocationPermission.denied) {
      status = await Geolocator.requestPermission();
    }
    return status == LocationPermission.always || status == LocationPermission.whileInUse;
  }

  /// 🔄 Carrega todos os dados climáticos
  Future<bool> loadAll() async {
    debugPrint('[WeatherController] Iniciando loadAll');
    isLoading.value = true;
    errorMessage.value = '';
    isOfflineMode.value = false;

    try {
      final permissao = await verificarPermissaoLocalizacao();
      if (!permissao) {
        errorMessage.value = 'Permissão de localização negada.';
        debugPrint('[WeatherController] Permissão negada');
        carregarClimaLocal();
        isOfflineMode.value = true;
        return false;
      }

      if (_currentCity == null || _currentCity!.isEmpty) {
        _currentCity = await getCurrentCity();
      }

      if (_currentCity == null || _currentCity!.isEmpty) {
        errorMessage.value = 'Localização não disponível. Ligue o GPS.';
        debugPrint('[WeatherController] GPS falhou');
        carregarClimaLocal();
        isOfflineMode.value = true;
        return false;
      }

      debugPrint('[WeatherController] Cidade detectada: $_currentCity');

      await fetchWeather();
      await Future.wait([
        fetchHourlyForecast(),
        fetchWeeklyForecast(),
      ]);

      return true;
    } catch (e) {
      errorMessage.value = 'Erro ao carregar dados: $e';
      debugPrint('[WeatherController] Erro: $e');
      carregarClimaLocal();
      isOfflineMode.value = true;
      return false;
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
        throw Exception('Dados não encontrados');
      }

      weather.value = result;
      salvarClimaLocal();
      updateBackgroundGradient();

      debugPrint('[WeatherController] Clima: ${result.main?.temp}°C');
    } on TimeoutException {
      errorMessage.value = 'Tempo esgotado. Verifique sua conexão com a internet.';
    } catch (e) {
      errorMessage.value = 'Erro ao buscar clima: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchWeatherByCity(String city) async {
    debugPrint('[WeatherController] Buscando clima manual para: $city');
    isLoading.value = true;
    errorMessage.value = '';
    isOfflineMode.value = false;

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

      await Future.wait([
        fetchHourlyForecast(),
        fetchWeeklyForecast(),
      ]);
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
      updateBackgroundGradient();
      debugPrint('[WeatherController] Cache carregado');
    } else {
      debugPrint('[WeatherController] Nenhum cache disponível');
    }
  }

  void updateBackgroundGradient() {
    backgroundGradient.value = WeatherVisualHelper.getGradient(condition);
    debugPrint('[WeatherController] Gradiente para $condition');
  }

  IconData getWeatherIcon(String code) {
    return WeatherVisualHelper.getIconFromCode(code);
  }
}