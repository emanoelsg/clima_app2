import 'package:clima_app2/app/models/weather_model/weather_model.dart';
import 'package:clima_app2/app/service/weather_service.dart';
import 'package:clima_app2/app/utils/helpers/localization/get_current_city.dart';
import 'package:get/get.dart';

class WeatherController extends GetxController {
  final WeatherService weatherService = WeatherService();

  var weather = Rxn<WeatherModel>();
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var _initialized = false;

  Future<void> fetchWeather() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final city = await getCurrentCity();
      if (city == null) {
        errorMessage.value = 'Não foi possível obter a localização.';
        return;
      }

      final result = await weatherService.fetchWeather(city: city);
      if (result == null) {
        errorMessage.value = 'Não foi possível obter os dados do clima.';
      } else {
        weather.value = result;
      }
    } catch (e) {
      errorMessage.value = 'Ocorreu um erro inesperado: $e';
    } finally {
      isLoading.value = false;
    }
  }

@override
void onInit() {
  super.onInit();
  if (!_initialized) {
    fetchWeather();
    _initialized = true;
  }
}

}
