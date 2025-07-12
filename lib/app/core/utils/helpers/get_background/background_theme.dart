import 'package:flutter/material.dart';

class WeatherBackground {
  static List<Color> getGradient(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return [Color(0xFF47BFDF), Color(0xFF4A91FF)];
      case 'clouds':
        return [Color(0xFF757F9A), Color(0xFFD7DDE8)];
      case 'rain':
        return [Color(0xFF283E51), Color(0xFF485563)];
      case 'snow':
        return [Color(0xFFE6DADA), Color(0xFF274046)];
      case 'thunderstorm':
        return [Color(0xFF373B44), Color(0xFF4286f4)];
      case 'night':
        return [Color(0xFF0F2027), Color(0xFF203A43)];
      default:
        return [Color(0xFF1E3C72), Color(0xFF2A5298)];
    }
  }
}