// app/view/search_screen/search_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:clima_app2/app/controller/api_controller.dart';

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

      return AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        decoration: BoxDecoration(
          gradient: controller.backgroundGradient.value,
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 30),
                TextField(
                  controller: _cityController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Digite o nome da cidade',
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey[900],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: isLoading
                      ? null
                      : () async {
                          final city = _cityController.text.trim();
                          if (city.isNotEmpty) {
                            await controller.fetchWeatherByCity(city);
                            if (controller.errorMessage.isEmpty) {
                              _cityController.clear();
                              Get.back();
                            } else {
                              Get.defaultDialog(
                                title: 'Oops!',
                                middleText: controller.errorMessage.value,
                                backgroundColor: Colors.grey[900],
                                titleStyle: const TextStyle(color: Colors.white),
                                middleTextStyle: const TextStyle(color: Colors.white70),
                              );
                            }
                          }
                        },
                  icon: const Icon(Icons.search),
                  label: const Text('Buscar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                const Divider(color: Colors.white24),
                const SizedBox(height: 12),
                TextButton.icon(
                  onPressed: isLoading
                      ? null
                      : () async {
                          await controller.loadAll();
                          if (controller.errorMessage.isEmpty) {
                            Get.back();
                          } else {
                            Get.defaultDialog(
                              title: 'Oops!',
                              middleText: controller.errorMessage.value,
                              backgroundColor: Colors.grey[900],
                              titleStyle: const TextStyle(color: Colors.white),
                              middleTextStyle: const TextStyle(color: Colors.white70),
                            );
                          }
                        },
                  icon: const Icon(Icons.gps_fixed, color: Colors.white),
                  label: const Text('Detectar minha localização'),
                ),
              ],
            ),
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