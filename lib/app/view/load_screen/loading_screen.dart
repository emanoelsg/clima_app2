import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:clima_app2/app/controller/api_controller.dart';
import 'package:clima_app2/app/view/home_page/home_page.dart';

class LoadingScreen extends StatelessWidget {
  final WeatherController controller = Get.put(WeatherController());

  LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const CircularProgressIndicator(color: Colors.white);
          }

          if (controller.errorMessage.isNotEmpty) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  controller.errorMessage.value,
                  style: const TextStyle(color: Colors.redAccent),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => controller.loadAll(),
                  child: const Text('Tentar novamente'),
                ),
              ],
            );
          }

          // Se tudo deu certo, navega para a HomeScreen
          Future.microtask(() => Get.off(() => const HomeScreen()));
          return const SizedBox(); // placeholder enquanto navega
        }),
      ),
    );
  }
}