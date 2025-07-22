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
<<<<<<< HEAD
  Widget build(BuildContext context) {
    // Obx só onde precisa: o AnimatedContainer depende do gradiente
=======
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  Future<void> buscarCidade() async {
  final city = _cityController.text.trim();

  if (city.isEmpty) {
    exibirErro('Digite o nome de uma cidade para buscar 🌍');
    return;
  }

  if (city.length < 3 || RegExp(r'[0-9@#\$%&*]').hasMatch(city)) {
    exibirErro('Hmm... isso não parece uma cidade válida 🤔');
    return;
  }

  // Detecta siglas de estado
  final estados = ['SP', 'RJ', 'MG', 'BA', 'RS', 'SC', 'PR', 'PE', 'CE'];
  if (estados.contains(city.toUpperCase())) {
    exibirErro('Você digitou um estado. Tente uma cidade como "Belo Horizonte" 😉');
    return;
  }

  await controller.fetchWeatherByCity(city);
  if (controller.errorMessage.isEmpty) {
    Get.back();
  } else {
    exibirErro('Cidade não encontrada. Tente outra ou verifique a ortografia 🧐');
  }
}


  Future<void> buscarPorGPS() async {
    await controller.loadAll();
    if (controller.errorMessage.isEmpty) {
      Get.back();
    } else {
      exibirErro(controller.errorMessage.value);
    }
  }

  void exibirErro(String msg) {
    Get.defaultDialog(
      title: 'Oops!',
      middleText: msg,
      backgroundColor: Colors.grey[900],
      titleStyle: const TextStyle(color: Colors.white),
      middleTextStyle: const TextStyle(color: Colors.white70),
    );
  }

  @override
  Widget build(BuildContext context) {
>>>>>>> 906cca7 (Initial commit)
    return Obx(() => AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          decoration: BoxDecoration(
            gradient: controller.backgroundGradient.value,
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
<<<<<<< HEAD
              backgroundColor: Colors.black,
=======
              backgroundColor: Colors.black.withOpacity(0.6),
>>>>>>> 906cca7 (Initial commit)
              title: const Text('Buscar cidade'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _cityController,
<<<<<<< HEAD
=======
                    textInputAction: TextInputAction.search,
                    onSubmitted: (_) => buscarCidade(),
>>>>>>> 906cca7 (Initial commit)
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
<<<<<<< HEAD
                    return controller.isLoading.value
                        ? const CircularProgressIndicator()
                        : ElevatedButton.icon(
                            onPressed: () async {
                              final city = _cityController.text.trim();
                              if (city.isNotEmpty) {
                                await controller.fetchWeatherByCity(city);
                                if (controller.errorMessage.isEmpty) {
                                  Get.back(); // Volta para tela anterior
                                } else {
                                  Get.defaultDialog(
                                    title: 'Oops!',
                                    middleText:
                                        controller.errorMessage.value,
                                    backgroundColor: Colors.grey[900],
                                    titleStyle:
                                        const TextStyle(color: Colors.white),
                                    middleTextStyle: const TextStyle(
                                        color: Colors.white70),
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
=======
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: controller.isLoading.value
                          ? const CircularProgressIndicator()
                          : ElevatedButton.icon(
                              key: const ValueKey('buscar'),
                              onPressed: buscarCidade,
                              icon: const Icon(Icons.search),
                              label: const Text('Buscar'),
                            ),
                    );
>>>>>>> 906cca7 (Initial commit)
                  }),
                  const SizedBox(height: 12),
                  const Divider(color: Colors.white24),
                  const SizedBox(height: 12),
                  Obx(() => TextButton.icon(
                        onPressed: controller.isLoading.value
                            ? null
<<<<<<< HEAD
                            : () async {
                                await controller.loadAll();
                                if (controller.errorMessage.isEmpty) {
                                  Get.back();
                                } else {
                                  Get.defaultDialog(
                                    title: 'Oops!',
                                    middleText:
                                        controller.errorMessage.value,
                                    backgroundColor: Colors.grey[900],
                                    titleStyle:
                                        const TextStyle(color: Colors.white),
                                    middleTextStyle: const TextStyle(
                                        color: Colors.white70),
                                  );
                                }
                              },
                        icon: const Icon(Icons.gps_fixed,
                            color: Colors.white),
                        label: const Text('Detectar minha localização'),
                      )),
=======
                            : buscarPorGPS,
                        icon: const Icon(Icons.gps_fixed, color: Colors.white),
                        label: const Text('Detectar minha localização'),
                      )),
                  const SizedBox(height: 24),
                  const Text(
                    'Sugestões: Caratinga, São Paulo, Belém, Recife',
                    style: TextStyle(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
>>>>>>> 906cca7 (Initial commit)
                ],
              ),
            ),
          ),
        ));
  }
<<<<<<< HEAD

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }
=======
>>>>>>> 906cca7 (Initial commit)
}