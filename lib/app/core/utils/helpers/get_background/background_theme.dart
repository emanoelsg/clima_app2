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
  }}