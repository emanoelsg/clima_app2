// app/core/widgets/forecast_details/forecast_details.dart
import 'package:clima_app2/app/models/daily_forecast/daily_forecast.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:get/get.dart';

import 'package:clima_app2/app/controller/weather_controller.dart';

class ForecastList extends StatelessWidget {
  final List<DailyForecast> forecast;

  const ForecastList({super.key, required this.forecast});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WeatherController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          forecast.map((day) {
            final icon = controller.getWeatherIcon(day.icon);
            final dayLabel = DateFormat('EEE', 'pt_BR').format(day.date);
            return ListTile(
              leading: Icon(icon, color: Colors.white),
              title: Text(
                dayLabel,
                style: const TextStyle(color: Colors.white),
              ),
              trailing: Text(
                ' Min ${day.minTemp.round()}° / Max ${day.maxTemp.round()}°',
                style: const TextStyle(color: Colors.white),
              ),
            );
          }).toList(),
    );
  }
}
