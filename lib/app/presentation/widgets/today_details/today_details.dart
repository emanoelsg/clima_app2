// app/presentation/widgets/today_details/today_details.dart

import 'package:clima_app2/app/core/helpers/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:clima_app2/app/presentation/controller/weather_controller.dart';
import 'package:clima_app2/app/data/models/hourly_model/hourly_model.dart';


class TodayForecastList extends StatelessWidget {
  const TodayForecastList({
    super.key,
    required this.forecast,
  });

  final List<HourlyForecast> forecast;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyMedium;
    final controller = Get.find<WeatherController>();

    return Obx(() {
      final Color accent = WeatherVisualHelper.getAccentColor(controller.condition);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🗓️ Título da seção
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Hoje',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // ⏰ Lista horizontal de previsões por hora
          SizedBox(
            height: 120,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: forecast.length,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final hour = forecast[index];
                final icon = controller.getWeatherIcon(hour.iconCode);

                return Container(
                  width: 72,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: accent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(hour.time, style: textStyle),
                      const SizedBox(height: 8),
                      Icon(icon, size: 28, color: Colors.white),
                      const SizedBox(height: 8),
                      Text('${hour.temp}°', style: textStyle),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }
}