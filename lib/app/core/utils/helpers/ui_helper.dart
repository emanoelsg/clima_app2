// app/core/utils/helpers/ui_helper.dart
import 'package:clima_app2/app/core/utils/helpers/get_background/background_theme.dart';
import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';


class WeatherUIHelper {
  static IconData getIcon(String code) {
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


  static Gradient getGradient(String condition) {
    final colors = WeatherBackground.getGradient(condition);
    return LinearGradient(
      colors: colors,
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
  }
}