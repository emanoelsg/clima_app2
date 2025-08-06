// app/presentation/widgets/forecast_details/forecast_details.dart

// 🌐 Imports de pacotes externos
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

// 📦 Imports internos do projeto
import 'package:clima_app2/app/data/models/daily_forecast/daily_forecast.dart';
import 'package:clima_app2/app/presentation/controller/weather_controller.dart';

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
            // 📅 Formata o dia da semana (ex: Seg, Ter, Qua)
            final dayLabel = DateFormat('EEE', 'pt_BR').format(day.date);

            // 🌤️ Ícone do clima
            final icon = controller.getWeatherIcon(day.icon);

            return ListTile(
              leading: Icon(icon, color: Colors.white),
              title: Text(
                dayLabel,
                style: const TextStyle(color: Colors.white),
              ),
              trailing: Text(
                'Min ${day.minTemp.round()}° / Max ${day.maxTemp.round()}°',
                style: const TextStyle(color: Colors.white),
              ),
            );
          }).toList(),
    );
  }
}
