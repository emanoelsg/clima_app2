// test/lib/app/core/utils/helpers/ui_helper_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:clima_app2/app/core/utils/helpers/ui_helper.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:flutter/material.dart';

void main() {
  group('WeatherUIHelper.getIcon', () {
    test('retorna ícone correto para códigos conhecidos', () {
      expect(WeatherUIHelper.getIcon('01d'), WeatherIcons.day_sunny);
      expect(WeatherUIHelper.getIcon('01n'), WeatherIcons.night_clear);
      expect(WeatherUIHelper.getIcon('02d'), WeatherIcons.day_cloudy);
      expect(WeatherUIHelper.getIcon('02n'), WeatherIcons.night_alt_cloudy);
      expect(WeatherUIHelper.getIcon('03d'), WeatherIcons.cloud);
      expect(WeatherUIHelper.getIcon('03n'), WeatherIcons.cloud);
      expect(WeatherUIHelper.getIcon('04d'), WeatherIcons.cloudy);
      expect(WeatherUIHelper.getIcon('04n'), WeatherIcons.cloudy);
      expect(WeatherUIHelper.getIcon('09d'), WeatherIcons.showers);
      expect(WeatherUIHelper.getIcon('09n'), WeatherIcons.showers);
      expect(WeatherUIHelper.getIcon('10d'), WeatherIcons.day_rain);
      expect(WeatherUIHelper.getIcon('10n'), WeatherIcons.night_alt_rain);
      expect(WeatherUIHelper.getIcon('11d'), WeatherIcons.thunderstorm);
      expect(WeatherUIHelper.getIcon('11n'), WeatherIcons.thunderstorm);
      expect(WeatherUIHelper.getIcon('13d'), WeatherIcons.snow);
      expect(WeatherUIHelper.getIcon('13n'), WeatherIcons.snow);
      expect(WeatherUIHelper.getIcon('50d'), WeatherIcons.fog);
      expect(WeatherUIHelper.getIcon('50n'), WeatherIcons.fog);
    });

    test('retorna ícone padrão para código desconhecido', () {
      expect(WeatherUIHelper.getIcon('xx'), WeatherIcons.na);
    });
  });

  group('WeatherUIHelper.getGradient', () {
    test('retorna gradiente válido para condição conhecida', () {
      final gradient = WeatherUIHelper.getGradient('Clear');
      expect(gradient, isA<LinearGradient>());
      expect((gradient as LinearGradient).colors.length, greaterThan(0));
    });

    test('retorna gradiente válido para condição desconhecida', () {
      final gradient = WeatherUIHelper.getGradient('AlienWeather');
      expect(gradient, isA<LinearGradient>());
    });
  });
}