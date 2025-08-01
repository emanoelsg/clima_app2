// app/presentation/view/home_page/home_page.dart

// 🌐 Imports de pacotes externos
import 'package:clima_app2/app/core/helpers/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// 📦 Imports internos do projeto
import 'package:clima_app2/app/presentation/controller/weather_controller.dart';

import 'package:clima_app2/app/presentation/widgets/forecast_details/forecast_details.dart';
import 'package:clima_app2/app/presentation/widgets/minimal_details/minimal_details.dart';
import 'package:clima_app2/app/presentation/widgets/today_details/today_details.dart';
import 'package:clima_app2/app/data/models/weather_model/weather_model_extension.dart';
import 'package:clima_app2/app/presentation/view/search_screen/search_screen.dart';

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
    _cityController.dispose(); // Libera o controlador ao sair da tela
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
          onPressed: () => controller.loadAll(), // Atualiza os dados
          child: const Icon(Icons.refresh),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: WeatherVisualHelper.getGradient(controller.condition),
          ),
          child: SafeArea(
            child: Builder(
              builder: (_) {
                // ⏳ Estado de carregamento
                if (isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                // ⚠️ Estado de erro
                if (hasError) {
                  return Center(
                    child: Text(
                      controller.errorMessage.value,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                // 📭 Sem dados
                if (weather == null) {
                  return const Center(
                    child: Text(
                      'Sem dados disponíveis.',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }

                // 🌤️ Dados disponíveis — exibe a tela principal
                return ListView(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  children: [
                    // 🔍 Barra superior com cidade e data
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton.icon(
                            onPressed: isLoading ? null : () => Get.dialog(const SearchScreen()),
                            icon: const Icon(Icons.search, color: Colors.white),
                            label: Text(
                              weather.city,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
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

                    // 📊 Detalhes em card (umidade, pressão, vento)
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
      );
    });
  }
}