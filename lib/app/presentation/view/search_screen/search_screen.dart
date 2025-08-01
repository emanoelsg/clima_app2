// app/presentation/view/search_screen/search_screen.dart

// 🌐 Imports de pacotes externos
import 'dart:ui'; // necessário para o efeito de blur
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// 📦 Imports internos do projeto
import 'package:clima_app2/app/presentation/controller/weather_controller.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _cityController = TextEditingController();
  final WeatherController controller = Get.find<WeatherController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoading = controller.isLoading.value;

      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 🏷️ Título
                  const Text(
                    'Buscar cidade',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 20),

                  // 🔍 Campo de texto
                  TextField(
                    controller: _cityController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Digite o nome da cidade',
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey[850],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 🔘 Botão de busca
                  ElevatedButton.icon(
                    onPressed: isLoading ? null : _searchCity,
                    icon: const Icon(Icons.search),
                    label: const Text('Buscar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  // 🔎 Lógica de busca e validação
  void _searchCity() async {
    final city = _cityController.text.trim();

    if (city.length < 2) {
      Get.snackbar(
        'Aviso',
        'Digite pelo menos 2 letras.',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    await controller.fetchWeatherByCity(city);

    if (controller.errorMessage.isEmpty) {
      _cityController.clear();
      Get.back(); // Fecha o diálogo
    } else {
      Get.snackbar(
        'Erro',
        controller.errorMessage.value,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  @override
  void dispose() {
    _cityController.dispose(); // Libera o controlador ao sair
    super.dispose();
  }
}