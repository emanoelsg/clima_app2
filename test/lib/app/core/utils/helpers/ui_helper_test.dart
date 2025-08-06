// test/lib/app/core/utils/helpers/ui_helper_test.dart
import 'package:clima_app2/app/core/helpers/ui_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:flutter/material.dart';

void main() {
  group('WeatherVisualHelper.getIconFromCode', () {
    test('retorna ícone correto para códigos conhecidos', () {
      expect(
        WeatherVisualHelper.getIconFromCode('01d'),
        WeatherIcons.day_sunny,
      );
      expect(
        WeatherVisualHelper.getIconFromCode('01n'),
        WeatherIcons.night_clear,
      );
      expect(
        WeatherVisualHelper.getIconFromCode('02d'),
        WeatherIcons.day_cloudy,
      );
      expect(
        WeatherVisualHelper.getIconFromCode('02n'),
        WeatherIcons.night_alt_cloudy,
      );
      expect(WeatherVisualHelper.getIconFromCode('03d'), WeatherIcons.cloud);
      expect(WeatherVisualHelper.getIconFromCode('03n'), WeatherIcons.cloud);
      expect(WeatherVisualHelper.getIconFromCode('04d'), WeatherIcons.cloudy);
      expect(WeatherVisualHelper.getIconFromCode('04n'), WeatherIcons.cloudy);
      expect(WeatherVisualHelper.getIconFromCode('09d'), WeatherIcons.showers);
      expect(WeatherVisualHelper.getIconFromCode('09n'), WeatherIcons.showers);
      expect(WeatherVisualHelper.getIconFromCode('10d'), WeatherIcons.day_rain);
      expect(
        WeatherVisualHelper.getIconFromCode('10n'),
        WeatherIcons.night_alt_rain,
      );
      expect(
        WeatherVisualHelper.getIconFromCode('11d'),
        WeatherIcons.thunderstorm,
      );
      expect(
        WeatherVisualHelper.getIconFromCode('11n'),
        WeatherIcons.thunderstorm,
      );
      expect(WeatherVisualHelper.getIconFromCode('13d'), WeatherIcons.snow);
      expect(WeatherVisualHelper.getIconFromCode('13n'), WeatherIcons.snow);
      expect(WeatherVisualHelper.getIconFromCode('50d'), WeatherIcons.fog);
      expect(WeatherVisualHelper.getIconFromCode('50n'), WeatherIcons.fog);
    });

    test('retorna ícone padrão para código desconhecido', () {
      expect(WeatherVisualHelper.getIconFromCode('xx'), WeatherIcons.na);
    });
  });

  group('WeatherVisualHelper.getGradient', () {
    test('retorna gradiente válido para condição conhecida', () {
      final gradient = WeatherVisualHelper.getGradient('Clear');
      expect(gradient, isA<LinearGradient>());
      expect((gradient as LinearGradient).colors.length, greaterThan(0));
    });

    test('retorna gradiente válido para condição desconhecida', () {
      final gradient = WeatherVisualHelper.getGradient('AlienWeather');
      expect(gradient, isA<LinearGradient>());
    });
  });

  group('WeatherVisualHelper.getAccentColor', () {
    test('retorna cor válida para condição conhecida', () {
      final color = WeatherVisualHelper.getAccentColor('Rain');
      expect(color, isA<Color>());
    });

    test('retorna cor padrão para condição desconhecida', () {
      final color = WeatherVisualHelper.getAccentColor('AlienWeather');
      expect(color, isA<Color>());
    });
  });
}
