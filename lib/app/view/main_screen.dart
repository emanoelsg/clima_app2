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
            return Consumer<WeatherController>(
              builder: (context, value, child) {
                // Conteúdo principal com SingleChildScrollView
                return ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: _buildContent(value),
                    ),
                  );
                
              },
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
          child: Text(
            'Erro: ${value.error}',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (value.weather == null) {
      return SizedBox(
        height: 200, // Altura fixa para o estado vazio
        child: const Center(
          child: Text(
            'Nenhum dado disponível',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return WeatherDetails();
  }
}
      
    