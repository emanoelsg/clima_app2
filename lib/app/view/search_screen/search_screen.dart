// app/view/search_screen/search_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:clima_app2/app/controller/weather_controller.dart';

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

      return Scaffold(
        backgroundColor: Colors.black87,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text('Buscar cidade'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
              ElevatedButton.icon(
                onPressed:
                    isLoading
                        ? null
                        : () async {
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
                            Get.back();
                          } else {
                            Get.snackbar(
                              'Erro',
                              controller.errorMessage.value,
                              backgroundColor: Colors.redAccent,
                              colorText: Colors.white,
                            );
                          }
                        },
                icon: const Icon(Icons.search),
                label: const Text('Buscar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              TextButton.icon(
                onPressed:
                    isLoading
                        ? null
                        : () async {
                          await controller.loadAll();
                          if (controller.errorMessage.isEmpty) {
                            Get.back();
                          } else {
                            Get.snackbar(
                              'Erro',
                              controller.errorMessage.value,
                              backgroundColor: Colors.redAccent,
                              colorText: Colors.white,
                            );
                          }
                        },
                icon:
                    isLoading
                        ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                        : const Icon(Icons.gps_fixed, color: Colors.white),
                label: const Text(
                  'Detectar minha localização',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }
}
