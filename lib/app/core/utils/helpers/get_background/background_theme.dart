// app/core/utils/helpers/get_background/background_theme.dart
import 'package:flutter/material.dart';

class WeatherBackground {
  static List<Color> getGradient(String condition) {
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
static Color getAccent(String condition) {
  final cond = condition.toLowerCase();

  if (cond.contains('clear')) {
    return const Color(0xFF0D47A1); // azul profundo
  } else if (cond.contains('cloud')) {
    return const Color(0xFF1C1C1E); // cinza quase preto
  } else if (cond.contains('rain') || cond.contains('drizzle')) {
    return const Color(0xFF263238); // azul acinzentado escuro
  } else if (cond.contains('snow')) {
    return const Color(0xFF37474F); // cinza azulado médio
  } else if (cond.contains('thunder')) {
    return const Color(0xFF1A237E); // azul escuro intenso
  } else if (cond.contains('fog') || cond.contains('mist') || cond.contains('haze')) {
    return const Color(0xFF212121); // cinza carvão
  } else {
    return const Color(0xFF2C3E50); // azul petróleo escuro
  }
}
}