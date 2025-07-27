// integration_test/weather_controller_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:clima_app2/app/controller/weather_controller.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('WeatherController salva clima local', (WidgetTester tester) async {
    final controller = WeatherController();

     controller.salvarClimaLocal();

    final climaSalvo = controller.weather.value;
expect(climaSalvo?.main?.temp, 25.0);

  });
}
