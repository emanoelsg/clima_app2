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
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<WeatherController>().fetchWeather();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 197, 211, 234),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Consumer<WeatherController>(
              builder: (context, value, child) {
                // Conteúdo principal com SingleChildScrollView
                return ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: _buildContent(value),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(WeatherController value) {
    if (value.isLoading) {
      return const SizedBox(
        height: 200, // Altura fixa para o loading
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (value.error != null) {
      return SizedBox(
        height: 200, // Altura fixa para a mensagem de erro
        child: Center(
          child: Text('Erro: ${value.error}', textAlign: TextAlign.center),
        ),
      );
    }

    if (value.weather == null) {
      return SizedBox(
        height: 200, // Altura fixa para o estado vazio
        child: const Center(
          child: Text('Nenhum dado disponível', textAlign: TextAlign.center),
        ),
      );
    }

    return WeatherDetails(weatherData: value.weather!);
  }
}
