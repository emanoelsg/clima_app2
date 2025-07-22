<<<<<<< HEAD
import 'package:clima_app2/app/models/hourly_model/hourly_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:clima_app2/app/controller/api_controller.dart';
=======
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:clima_app2/app/controller/api_controller.dart';
import 'package:clima_app2/app/models/hourly_model/hourly_model.dart';
import 'package:clima_app2/app/core/utils/helpers/get_background/background_theme.dart';
>>>>>>> 906cca7 (Initial commit)

class TodayForecastList extends StatelessWidget {
  final List<HourlyForecast> forecast;

  const TodayForecastList({super.key, required this.forecast});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyMedium;
    final controller = Get.find<WeatherController>();
<<<<<<< HEAD
=======
    final currentHour = TimeOfDay.now().hour;
>>>>>>> 906cca7 (Initial commit)

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
<<<<<<< HEAD
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text('Today', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
=======
        SizedBox(
          height: 130,
>>>>>>> 906cca7 (Initial commit)
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: forecast.length,
            itemBuilder: (context, index) {
              final hour = forecast[index];
              final icon = controller.getWeatherIcon(hour.iconCode);
<<<<<<< HEAD

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
=======
              final hourInt = int.tryParse(hour.time.split(':').first) ?? 0;
              final isNow = hourInt == currentHour;

              return AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: 1.0,
                child: GestureDetector(
                  onTap: () {
                    Get.dialog(
                      Dialog(
                        backgroundColor: WeatherBackground.getSecondColor(controller.condition),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${hour.time} - Detalhes',
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Icon(icon, size: 48, color: Colors.white),
                              const SizedBox(height: 12),
                              Text('Temperatura: ${hour.temp}°', style: const TextStyle(color: Colors.white70)),
                              const SizedBox(height: 8),
                              Text('Sensação térmica: ${hour.feelsLike}°', style: const TextStyle(color: Colors.white54)),
                              const SizedBox(height: 8),
                              Text('Vento: ${hour.windSpeed} km/h', style: const TextStyle(color: Colors.white54)),
                            ],
                          ),
                        ),
                      ),
                      barrierDismissible: true,
                    );
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOut,
                    width: 80,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isNow ? Colors.blueGrey[700] : Colors.black54,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        if (isNow)
                          BoxShadow(
                            color: Colors.blueAccent.withOpacity(0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          hour.time,
                          style: textStyle?.copyWith(
                            color: isNow ? Colors.white : Colors.white70,
                            fontWeight: isNow ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Icon(icon, size: 28, color: Colors.white),
                        const SizedBox(height: 8),
                        Text(
                          '${hour.temp}°',
                          style: textStyle?.copyWith(
                            fontWeight: isNow ? FontWeight.bold : FontWeight.normal,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
>>>>>>> 906cca7 (Initial commit)
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}