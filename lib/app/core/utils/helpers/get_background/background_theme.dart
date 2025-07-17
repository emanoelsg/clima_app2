import 'package:flutter/material.dart';

class WeatherBackground {
  static List<Color> getGradient(String condition) {
  final cond = condition.toLowerCase();

  if (cond.contains('clear')) {
    return [Color(0xFF47BFDF), Color(0xFF4A91FF)];
  } else if (cond.contains('cloud')) {
    return [Color(0xFF757F9A), Color(0xFFD7DDE8)];
  } else if (cond.contains('rain') || cond.contains('drizzle')) {
    return [Color(0xFF283E51), Color(0xFF485563)];
  } else if (cond.contains('snow')) {
    return [Color(0xFFE6DADA), Color(0xFF274046)];
  } else if (cond.contains('thunder')) {
    return [Color(0xFF373B44), Color(0xFF4286f4)];
  } else if (cond.contains('fog') || cond.contains('mist') || cond.contains('haze')) {
    return [Color(0xFF606c88), Color(0xFF3f4c6b)];
  } else {
    return [Color(0xFF1E3C72), Color(0xFF2A5298)];
  }
}
}