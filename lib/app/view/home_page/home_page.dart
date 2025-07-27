// app/view/home_page/home_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:clima_app2/app/controller/weather_controller.dart';
import 'package:clima_app2/app/core/utils/helpers/get_background/background_theme.dart';
import 'package:clima_app2/app/core/widgets/forecast_details/forecast_details.dart';
import 'package:clima_app2/app/core/widgets/minimal_details/minimal_details.dart';
import 'package:clima_app2/app/core/widgets/today_details/today_details.dart';
import 'package:clima_app2/app/models/weather_model/weather_model_extension.dart';
import 'package:clima_app2/app/view/search_screen/search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = Get.find<WeatherController>();
  final TextEditingController _cityController = TextEditingController();

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final Color accent = WeatherBackground.getAccent(controller.condition);
      final weather = controller.weather.value;
      final isLoading = controller.isLoading.value;
      final hasError = controller.errorMessage.isNotEmpty;

      return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: accent,
          child: const Icon(Icons.refresh),
          onPressed: () => controller.loadAll(),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: WeatherBackground.getGradient(controller.condition),
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Builder(
              builder: (_) {
                if (isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (hasError) {
                  return Center(
                    child: Text(
                      controller.errorMessage.value,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                if (weather == null) {
                  return const Center(
                    child: Text(
                      'Sem dados disponíveis.',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }

                return ListView(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  children: [
                    // Top bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton.icon(
                            onPressed: isLoading
                                ? null
                                : () => Get.dialog(const SearchScreen()),
                            icon: const Icon(
                              Icons.location_on,
                              color: Colors.white,
                            ),
                            label: Text(
                              weather.city,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(color: Colors.white),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.notifications_none,
                              color: Colors.white,
                            ),
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
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            color: Colors.white,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      weather.description,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                          ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 24),

                    // Detalhes em Card
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Card(
                        color: accent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: WeatherDetailsRow(
                            humidity: weather.humidity,
                            pressure: weather.pressure,
                            windSpeed: weather.windSpeed,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Previsão por hora
                    RepaintBoundary(
                      child: TodayForecastList(
                        forecast: controller.hourlyForecast,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Previsão semanal
                    RepaintBoundary(
                      child: ForecastList(
                        forecast: controller.dailyForecast,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );
    });
  }
}