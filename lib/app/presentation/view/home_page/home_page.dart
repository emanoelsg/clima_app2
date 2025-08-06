// app/presentation/view/home_page/home_page.dart

// 🌐 Imports de pacotes externos
import 'package:clima_app2/app/core/helpers/ui_helper.dart';
import 'package:clima_app2/app/presentation/view/search_screen/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// 📦 Imports internos do projeto
import 'package:clima_app2/app/presentation/controller/weather_controller.dart';
import 'package:clima_app2/app/presentation/widgets/forecast_details/forecast_details.dart';
import 'package:clima_app2/app/presentation/widgets/minimal_details/minimal_details.dart';
import 'package:clima_app2/app/presentation/widgets/today_details/today_details.dart';
import 'package:clima_app2/app/data/models/weather_model/weather_model_extension.dart';


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
      final Color accent = WeatherVisualHelper.getAccentColor(controller.condition);
      final weather = controller.weather.value;
      final isLoading = controller.isLoading.value;
      final hasError = controller.errorMessage.isNotEmpty;
      final String today = DateFormat('EEEE, d MMMM', 'pt_BR').format(DateTime.now());

      return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: accent,
          foregroundColor: Colors.white,
          onPressed: () {
            if (!controller.isLoading.value) {
              controller.loadAll();
            }
          },
          child: const Icon(Icons.refresh),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: controller.backgroundGradient.value,
          ),
          child: SafeArea(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: Builder(
                key: ValueKey(isLoading || hasError || weather == null),
                builder: (_) {
                  if (isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          controller.errorMessage.value.replaceAll('Exception:', '').trim(),
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
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
//to( SearchScreen()),
                  return ListView(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    children: [
                      // 🔍 Barra superior com cidade e data
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: TextButton.icon(
                                onPressed: isLoading ? null : () => Get.dialog( const SearchScreen()),
                                icon: const Icon(Icons.search, color: Colors.white),
                                label: Text(
                                  weather.city,
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
                                ),
                              ),
                            ),
                            Text(
                              today,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.white70,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // 🌡️ Clima atual
                      Icon(
                        controller.getWeatherIcon(weather.icon),
                        size: 96,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '${weather.temperature.toStringAsFixed(0)}°',
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        weather.description,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 24),

                      // 📊 Detalhes em card
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Card(
                          color: accent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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

                      // ⏱️ Previsão por hora
                      RepaintBoundary(
                        child: TodayForecastList(forecast: controller.hourlyForecast),
                      ),

                      const SizedBox(height: 24),

                      // 📅 Previsão semanal
                      RepaintBoundary(
                        child: ForecastList(forecast: controller.dailyForecast),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );
    });
  }
}