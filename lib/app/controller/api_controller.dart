import 'package:clima_app2/app/models/daily_forecast/daily_forecast.dart';
import 'package:clima_app2/app/models/hourly_model/hourly_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:weather_icons/weather_icons.dart';

import 'package:clima_app2/app/service/weather_service.dart';
import 'package:clima_app2/app/models/weather_model/weather_model.dart';
import 'package:clima_app2/app/models/weekly_model/weekly_forecast_model.dart';
import 'package:clima_app2/app/core/utils/helpers/localization/get_current_city.dart';

class WeatherController extends GetxController {
  final WeatherService weatherService = WeatherService();

  var weather = Rxn<WeatherModel>();
  var weeklyForecast = Rxn<WeeklyForecast>();

  var hourlyForecast = <HourlyForecast>[].obs;
  var dailyForecast = <DailyForecast>[].obs;

  var isLoading = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadAll();
  }

  Future<void> _loadAll() async {
    await fetchWeather();
    await Future.wait([fetchHourlyForecast(), fetchWeeklyForecast()]);
  }

  Future<void> fetchWeather() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final city = await getCurrentCity();
      if (city == null) {
        errorMessage.value = 'Não foi possível obter a localização.';
        return;
      }

      final result = await weatherService.fetchWeather(city: city);
      if (result == null) {
        errorMessage.value = 'Não foi possível obter os dados do clima.';
      } else {
        weather.value = result;
      }
    } catch (e) {
      errorMessage.value = 'Erro ao buscar clima atual: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchHourlyForecast() async {
    try {
      final city = weather.value?.name ?? await getCurrentCity();
      if (city == null) throw Exception('Cidade nula');

      final list = await weatherService.getHourlyForecast(city: city);
      hourlyForecast.value = list;
    } catch (e) {
      errorMessage.value = 'Erro ao buscar previsão por hora: $e';
    }
  }

  Future<void> fetchWeeklyForecast() async {
    try {
      final city = weather.value?.name ?? await getCurrentCity();
      if (city == null) throw Exception('Cidade nula');

      final wf = await weatherService.getWeeklyForecast(city: city);
      weeklyForecast.value = wf;

      dailyForecast.value = wf.daily;
    } catch (e) {
      errorMessage.value = 'Erro ao buscar previsão semanal: $e';
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
