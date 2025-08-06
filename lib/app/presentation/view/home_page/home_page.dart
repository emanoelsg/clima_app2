// app/presentation/view/home_page/home_page.dart
import 'package:clima_app2/app/core/helpers/ui_helper.dart';
import 'package:clima_app2/app/presentation/view/search_screen/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

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

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final controller = Get.find<WeatherController>();
  final TextEditingController _cityController = TextEditingController();
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _cityController.dispose();
    _fadeController.dispose();
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

                  return ListView(
                    padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
                    children: [
                      // 🔍 Cabeçalho com cidade e data
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: isLoading ? null : () => Get.dialog(const SearchScreen()),
                              splashColor: Colors.white24,
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.search, color: Colors.white),
                                    const SizedBox(width: 8),
                                    Hero(
                                      tag: 'city-name',
                                      child: Material(
                                        color: Colors.transparent,
                                        child: Text(
                                          weather.city,
                                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            today,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white70,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // 🌡️ Clima atual com animação
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        child: Hero(
                          tag: 'weather-icon',
                          child: Icon(
                            controller.getWeatherIcon(weather.icon),
                            key: ValueKey(weather.icon),
                            size: 100,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Column(
                          children: [
                            Text(
                              '${weather.temperature.toStringAsFixed(0)}°',
                              style: GoogleFonts.lato(
                                fontSize: 72,
                                color: Colors.white,
                                fontWeight: FontWeight.w300,
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
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // 📊 Card de detalhes com sombra
                      Container(
                        decoration: BoxDecoration(
                          color: accent,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: WeatherDetailsRow(
                            humidity: weather.humidity,
                            pressure: weather.pressure,
                            windSpeed: weather.windSpeed,
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // ⏱️ Previsão por hora
                      RepaintBoundary(
                        child: TodayForecastList(
                          forecast: controller.hourlyForecast,
                        ),
                      ),

                      const SizedBox(height: 32),

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