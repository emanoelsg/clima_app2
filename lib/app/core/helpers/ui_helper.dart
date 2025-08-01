// app/utils/helpers/ui_helper.dart

import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';

class WeatherVisualHelper {
  /// 🌤️ Mapeia códigos climáticos (ex: '01d', '10n') para ícones visuais
  static IconData getIconFromCode(String code) {
    const iconMap = {
      '01d': WeatherIcons.day_sunny,
      '01n': WeatherIcons.night_clear,
      '02d': WeatherIcons.day_cloudy,
      '02n': WeatherIcons.night_alt_cloudy,
      '03d': WeatherIcons.cloud,
      '03n': WeatherIcons.cloud,
      '04d': WeatherIcons.cloudy,
      '04n': WeatherIcons.cloudy,
      '09d': WeatherIcons.showers,
      '09n': WeatherIcons.showers,
      '10d': WeatherIcons.day_rain,
      '10n': WeatherIcons.night_alt_rain,
      '11d': WeatherIcons.thunderstorm,
      '11n': WeatherIcons.thunderstorm,
      '13d': WeatherIcons.snow,
      '13n': WeatherIcons.snow,
      '50d': WeatherIcons.fog,
      '50n': WeatherIcons.fog,
    };
    return iconMap[code] ?? WeatherIcons.na;
  }

  /// 🌈 Retorna gradiente de fundo com base na condição textual (ex: 'Rain', 'Clear')
  static List<Color> getGradientColors(String condition) {
    final cond = condition.toLowerCase();

    if (cond.contains('clear')) {
      return [Color(0xFF47BFDF), Color(0xFF4A91FF)];
    } else if (cond.contains('cloud')) {
      return [Color(0xFF4C566A), Color(0xFF2E3440)];
    } else if (cond.contains('rain') || cond.contains('drizzle')) {
      return [Color(0xFF283E51), Color(0xFF485563)];
    } else if (cond.contains('snow')) {
      return [Color(0xFF3C3F41), Color(0xFF5C6370)];
    } else if (cond.contains('thunder')) {
      return [Color(0xFF373B44), Color(0xFF4286f4)];
    } else if (cond.contains('fog') || cond.contains('mist') || cond.contains('haze')) {
      return [Color(0xFF606c88), Color(0xFF3f4c6b)];
    } else {
      return [Color(0xFF1E3C72), Color(0xFF2A5298)];
    }
  }

  /// 🎨 Retorna cor de destaque para cards e elementos com base na condição
  static Color getAccentColor(String condition) {
    final cond = condition.toLowerCase();

    if (cond.contains('clear')) {
      return const Color.fromARGB(255, 57, 105, 177);
    } else if (cond.contains('cloud')) {
      return const Color(0xFF1C1C1E);
    } else if (cond.contains('rain') || cond.contains('drizzle')) {
      return const Color(0xFF263238);
    } else if (cond.contains('snow')) {
      return const Color(0xFF37474F);
    } else if (cond.contains('thunder')) {
      return const Color(0xFF1A237E);
    } else if (cond.contains('fog') || cond.contains('mist') || cond.contains('haze')) {
      return const Color(0xFF212121);
    } else {
      return const Color(0xFF2C3E50);
    }
  }

  /// 🔁 Retorna gradiente pronto para uso em `Container` ou `BoxDecoration`
  static Gradient getGradient(String condition) {
    final colors = getGradientColors(condition);
    return LinearGradient(
      colors: colors,
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
  }
}