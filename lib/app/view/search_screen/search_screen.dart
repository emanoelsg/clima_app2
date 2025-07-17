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
    return Obx(() => Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: controller.backgroundGradient,
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent, // importante!
            appBar: AppBar(
              title: const Text('Buscar cidade'),
              backgroundColor: Colors.black,
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
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
                  Obx(() {
                    return controller.isLoading.value
                        ? const CircularProgressIndicator()
                        : ElevatedButton.icon(
                            onPressed: () async {
                              final city = _cityController.text.trim();
                              if (city.isNotEmpty) {
                                await controller.fetchWeatherByCity(city);
                                if (controller.errorMessage.isEmpty) {
                                  Get.back(); // Volta para a tela anterior
                                } else {
                                  Get.snackbar(
                                    'Erro',
                                    controller.errorMessage.value,
                                    backgroundColor: Colors.redAccent,
                                    colorText: Colors.white,
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
                          );
                  }),
                ],
              ),
            ),
          ),
        ));
  }
}