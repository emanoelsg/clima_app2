// app/utils/widgets/minimal_details/minimal_details.dart

import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';

class WeatherDetailsRow extends StatelessWidget {
  final int humidity;
  final int pressure;
  final double windSpeed;

  const WeatherDetailsRow({
    super.key,
    required this.humidity,
    required this.pressure,
    required this.windSpeed,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyMedium;

    // 🔧 Construtor de item individual (ícone + label + valor)
    Widget buildItem(IconData icon, String label, String value) {
      return Column(
        children: [
          Icon(icon, size: 24, color: Colors.white70),
          const SizedBox(height: 4),
          Text(label, style: textStyle),
          Text(value, style: textStyle?.copyWith(fontWeight: FontWeight.bold)),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // 💧 Umidade
          buildItem(WeatherIcons.humidity, 'Humidity', '$humidity%'),

          // 🌡️ Pressão atmosférica
          buildItem(WeatherIcons.barometer, 'Pressure', '$pressure hPa'),

          // 💨 Velocidade do vento
          buildItem(
            WeatherIcons.strong_wind,
            'Wind',
            '${windSpeed.toStringAsFixed(1)} m/s',
          ),
        ],
      ),
    );
  }
}
