// app/presentation/view/bindings/weather_binding.dart
import 'package:get/get.dart';
import 'package:clima_app2/app/presentation/controller/weather_controller.dart';

class WeatherBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(WeatherController(), permanent: true);
  }
}
