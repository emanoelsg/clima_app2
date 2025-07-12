import 'package:clima_app2/app/core/utils/helpers/get_background/background_theme.dart';
import 'package:clima_app2/app/core/widgets/forecast_details/forecast_details.dart';
import 'package:clima_app2/app/core/widgets/minimal_details/minimal_details.dart';
import 'package:clima_app2/app/core/widgets/today_details/today_details.dart';
import 'package:clima_app2/app/models/weather_model/weather_model_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:clima_app2/app/controller/api_controller.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = Get.put(WeatherController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final weather = controller.weather.value;
      final condition = weather?.main ?? 'clear';
      final gradient = WeatherBackground.getGradient(condition.toString().toLowerCase());
      

      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradient,
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: weather == null
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Top bar
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.location_on, color: Colors.white),
                                label: Text(
                                  weather.city,
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.notifications_none, color: Colors.white),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Clima atual
                        Icon(
                          controller.getWeatherIcon(weather.icon),
                          size: 96,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '${weather.temperature.toStringAsFixed(0)}°',
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                        Text(
                          weather.description,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),

                        // Detalhes
                        WeatherDetailsRow(
                          humidity: weather.humidity,
                          pressure: weather.pressure,
                          windSpeed: weather.windSpeed,
                        ),

                        // Previsão por hora
                        TodayForecastList(forecast: controller.hourlyForecast.toList()),

                        const SizedBox(height: 24),

                        // Previsão semanal
                        ForecastList(forecast: controller.dailyForecast.toList()),
                      ],
                    ),
                  ),
          ),
        ),
      );
    });
  }
}