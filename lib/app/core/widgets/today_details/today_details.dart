import 'package:clima_app2/app/models/hourly_model/hourly_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:clima_app2/app/controller/api_controller.dart';

class TodayForecastList extends StatelessWidget {
  final List<HourlyForecast> forecast;

  const TodayForecastList({super.key, required this.forecast});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyMedium;
    final controller = Get.find<WeatherController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text('Today', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: forecast.length,
            itemBuilder: (context, index) {
              final hour = forecast[index];
              final icon = controller.getWeatherIcon(hour.iconCode);

              return Container(
                width: 72,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black54,
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
  }
}