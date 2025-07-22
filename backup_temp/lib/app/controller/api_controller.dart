import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:weather_icons/weather_icons.dart';

import 'package:clima_app2/app/models/weather_model/weather_model.dart';
import 'package:clima_app2/app/models/hourly_model/hourly_model.dart';
import 'package:clima_app2/app/models/weekly_model/weekly_forecast_model.dart';
import 'package:clima_app2/app/models/daily_forecast/daily_forecast.dart';
import 'package:clima_app2/app/service/weather_service.dart';
import 'package:clima_app2/app/core/utils/helpers/localization/get_current_city.dart';
import 'package:clima_app2/app/core/utils/helpers/get_background/background_theme.dart';

class WeatherController extends GetxController {
  final WeatherService weatherService;
  final GetStorage storage;

  WeatherController({
    WeatherService? weatherService,
    GetStorage? storage,
  })  : weatherService = weatherService ?? WeatherService(),
        storage = storage ?? GetStorage();

  final weather = Rxn<WeatherModel>();
  final weeklyForecast = Rxn<WeeklyForecast>();
  final hourlyForecast = <HourlyForecast>[].obs;
  final dailyForecast = <DailyForecast>[].obs;

  final backgroundGradient = Rx<Gradient>(
    const LinearGradient(
      colors: [Color(0xFF1E3C72), Color(0xFF2A5298)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
  );

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  String? _currentCity;
  String get condition => weather.value?.weather.first.main ?? 'Clear';

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
      _currentCity = await getCurrentCity();
      if (_currentCity == null || _currentCity!.isEmpty) {
        errorMessage.value = 'Localização não disponível. Ligue o GPS.';
        carregarClimaLocal();
        return;
      }

      debugPrint('[WeatherController] Cidade detectada: $_currentCity');
      await fetchWeather();
      await Future.wait([
        fetchHourlyForecast(),
        fetchWeeklyForecast(),
      ]);
    } catch (e) {
      errorMessage.value = 'Erro ao carregar dados: $e';
      carregarClimaLocal();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchWeather() async {
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
        carregarClimaLocal();
      } else {
        weather.value = result;
        salvarClimaLocal();
        debugPrint('[WeatherController] Clima: ${result.main?.temp}°C');
      }

      updateBackgroundGradient();
    } on TimeoutException {
      errorMessage.value = 'Conexão lenta. Exibindo dados salvos.';
      carregarClimaLocal();
    } catch (e) {
      errorMessage.value = 'Erro inesperado: $e';
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
    }
  }

  Future<void> fetchWeeklyForecast() async {
    try {
      final city = weather.value?.name ?? _currentCity;
      if (city == null) throw Exception('Cidade nula');

      final wf = await weatherService.getWeeklyForecast(city: city);
      weeklyForecast.value = wf;
      dailyForecast.value = wf.daily;

      debugPrint('[WeatherController] Dias recebidos: ${wf.daily.length}');
    } catch (e) {
      errorMessage.value = 'Erro na previsão semanal: $e';
    }
  }

  void updateBackgroundGradient() {
    final colors = WeatherBackground.getGradient(condition);
    backgroundGradient.value = LinearGradient(
      colors: colors,
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
    debugPrint('[WeatherController] Gradiente para $condition');
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

  IconData getWeatherIcon(String code) {
    switch (code) {
      case '01d': return WeatherIcons.day_sunny;
      case '01n': return WeatherIcons.night_clear;
      case '02d': return WeatherIcons.day_cloudy;
      case '02n': return WeatherIcons.night_alt_cloudy;
      case '03d':
      case '03n': return WeatherIcons.cloud;
      case '04d':
      case '04n': return WeatherIcons.cloudy;
      case '09d':
      case '09n': return WeatherIcons.showers;
      case '10d': return WeatherIcons.day_rain;
      case '10n': return WeatherIcons.night_alt_rain;
      case '11d':
      case '11n': return WeatherIcons.thunderstorm;
      case '13d':
      case '13n': return WeatherIcons.snow;
      case '50d':
      case '50n': return WeatherIcons.fog;
      default: return WeatherIcons.na;
    }
  }
}