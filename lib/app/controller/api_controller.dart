import 'package:clima_app2/app/core/utils/helpers/get_background/background_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:clima_app2/app/service/weather_service.dart';
import 'package:clima_app2/app/models/weather_model/weather_model.dart';
import 'package:clima_app2/app/models/weekly_model/weekly_forecast_model.dart';
import 'package:clima_app2/app/models/hourly_model/hourly_model.dart';
import 'package:clima_app2/app/models/daily_forecast/daily_forecast.dart';
import 'package:clima_app2/app/core/utils/helpers/localization/get_current_city.dart';

class WeatherController extends GetxController {
  final WeatherService weatherService = WeatherService();

  final weather = Rxn<WeatherModel>();
  final weeklyForecast = Rxn<WeeklyForecast>();
  final hourlyForecast = <HourlyForecast>[].obs;
  final dailyForecast = <DailyForecast>[].obs;
  String get condition => weather.value?.weather.first.main ?? 'Clear';
  final backgroundGradient = <Color>[].obs;

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  String? _currentCity;

  @override
  void onInit() {
    super.onInit();
    debugPrint('[WeatherController] onInit chamado');
    loadAll();
  }

  void updateBackgroundGradient() {
    final condition = weather.value?.weather.first.main ?? 'Clear';
    final gradient = WeatherBackground.getGradient(condition);
    backgroundGradient.value = gradient;
    debugPrint('[WeatherController] Gradiente atualizado para $condition');
  }

  Future<void> fetchWeatherByCity(String city) async {
    debugPrint('[WeatherController] Buscando clima para cidade: $city');
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await weatherService.fetchWeather(city: city);
      if (result == null) {
        errorMessage.value = 'Cidade não encontrada ou erro na API.';
        debugPrint('[WeatherController] Clima não encontrado para $city');
      } else {
        weather.value = result;
        _currentCity = city;
        debugPrint(
          '[WeatherController] Clima atual recebido: ${result.main?.temp}°C',
        );
        await Future.wait([fetchHourlyForecast(), fetchWeeklyForecast()]);
      }
      updateBackgroundGradient();
    } catch (e) {
      errorMessage.value = 'Erro ao buscar clima: $e';
      debugPrint('[WeatherController] Erro ao buscar clima: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadAll() async {
    debugPrint('[WeatherController] Iniciando _loadAll');
    isLoading.value = true;
    errorMessage.value = '';

    try {
      _currentCity = await getCurrentCity();
      debugPrint('[WeatherController] Cidade atual detectada: $_currentCity');

      if (_currentCity == null) {
        errorMessage.value = 'Por favor ligue a localização ';
        debugPrint('[WeatherController] Localização não disponível');
        return;
      }

      await fetchWeather();
      await Future.wait([fetchHourlyForecast(), fetchWeeklyForecast()]);
    } catch (e) {
      errorMessage.value = 'Erro ao carregar dados: $e';
      debugPrint('[WeatherController] Erro ao carregar dados: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchWeather() async {
    debugPrint('[WeatherController] Buscando clima atual para $_currentCity');
    try {
      final result = await weatherService.fetchWeather(city: _currentCity!);
      if (result == null) {
        errorMessage.value = 'Não foi possível obter os dados do clima.';
        debugPrint('[WeatherController] Clima atual não encontrado');
      } else {
        weather.value = result;
        debugPrint(
          '[WeatherController] Clima atual recebido: ${result.main?.temp}°C',
        );
      }updateBackgroundGradient();
    } catch (e) {
      errorMessage.value = 'Erro ao buscar clima atual: $e';
      debugPrint('[WeatherController] Erro ao buscar clima atual: $e');
    }
  }

  Future<void> fetchHourlyForecast() async {
    try {
      final city = weather.value?.name ?? _currentCity;
      if (city == null) {
        debugPrint(
          '[WeatherController] Cidade nula ao buscar previsão por hora',
        );
        throw Exception('Cidade nula');
      }

      debugPrint('[WeatherController] Buscando previsão por hora para $city');
      final list = await weatherService.getHourlyForecast(city: city);
      hourlyForecast.value = list;
      debugPrint(
        '[WeatherController] Previsão por hora recebida: ${list.length} itens',
      );
    } catch (e) {
      errorMessage.value = 'Erro ao buscar previsão por hora: $e';
      debugPrint('[WeatherController] Erro ao buscar previsão por hora: $e');
    }
  }

  Future<void> fetchWeeklyForecast() async {
    try {
      final city = weather.value?.name ?? _currentCity;
      if (city == null) {
        debugPrint(
          '[WeatherController] Cidade nula ao buscar previsão semanal',
        );
        throw Exception('Cidade nula');
      }

      debugPrint('[WeatherController] Buscando previsão semanal para $city');
      final wf = await weatherService.getWeeklyForecast(city: city);
      weeklyForecast.value = wf;
      dailyForecast.value = wf.daily;
      debugPrint(
        '[WeatherController] Previsão semanal recebida: ${wf.daily.length} dias',
      );
    } catch (e) {
      errorMessage.value = 'Erro ao buscar previsão semanal: $e';
      debugPrint('[WeatherController] Erro ao buscar previsão semanal: $e');
    }
  }

  IconData getWeatherIcon(String code) {
    switch (code) {
      case '01d':
        return WeatherIcons.day_sunny;
      case '01n':
        return WeatherIcons.night_clear;
      case '02d':
        return WeatherIcons.day_cloudy;
      case '02n':
        return WeatherIcons.night_alt_cloudy;
      case '03d':
      case '03n':
        return WeatherIcons.cloud;
      case '04d':
      case '04n':
        return WeatherIcons.cloudy;
      case '09d':
      case '09n':
        return WeatherIcons.showers;
      case '10d':
        return WeatherIcons.day_rain;
      case '10n':
        return WeatherIcons.night_alt_rain;
      case '11d':
      case '11n':
        return WeatherIcons.thunderstorm;
      case '13d':
      case '13n':
        return WeatherIcons.snow;
      case '50d':
      case '50n':
        return WeatherIcons.fog;
      default:
        return WeatherIcons.na;
    }
  }
}
