import 'package:clima_app2/app/controller/api_controller.dart';

import 'package:clima_app2/app/view/weather_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Center(
                  // Centraliza todo o conteúdo
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Consumer<WeatherController>(
                      builder: (context, value, child) {
                        // Widgets que não dependem do estado
                        if (value.isLoading) {
                          return const CircularProgressIndicator();
                        }

                        if (value.error != null) {
                          return Text(
                            'Erro: ${value.error}',
                            textAlign: TextAlign.center,
                          );
                        }

                        if (value.weather == null) {
                          return const Text(
                            'Nenhum dado disponível',
                            textAlign: TextAlign.center,
                          );
                        }

                        return WeatherDetails(weatherDetails: value.weather);
                      },
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<WeatherController>().fetchWeather(),
        tooltip: 'Atualizar dados',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
