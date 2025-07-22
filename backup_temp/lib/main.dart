<<<<<<< HEAD
=======
import 'package:clima_app2/app/controller/api_controller.dart';
>>>>>>> 906cca7 (Initial commit)
import 'package:clima_app2/app/core/theme/app_theme.dart';
import 'package:clima_app2/app/view/home_page/home_page.dart';
import 'package:clima_app2/app/view/load_screen/loading_screen.dart';
import 'package:flutter/material.dart';
<<<<<<< HEAD
=======
import 'package:flutter/services.dart';
>>>>>>> 906cca7 (Initial commit)
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:clima_app2/app/view/search_screen/search_screen.dart';
import 'package:get_storage/get_storage.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
<<<<<<< HEAD
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
  };
  await initializeDateFormatting('pt_BR', null);
await GetStorage.init();
  runApp( MyApp());
}

=======
  await initializeDateFormatting('pt_BR', null);
  await GetStorage.init();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);


  Get.put(WeatherController());

  runApp( MyApp());
}


>>>>>>> 906cca7 (Initial commit)
class MyApp extends StatelessWidget {

   const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
<<<<<<< HEAD
      themeMode: ThemeMode.system,
      theme: AppTheme.dark,
      routes: {
        '/home': (context) => const HomeScreen(),
=======
      theme: AppTheme.dark,
      routes: {
        '/home': (context) => HomeScreen(),
>>>>>>> 906cca7 (Initial commit)
        '/search': (context) => SearchScreen(),
        '/': (context) => LoadingScreen(),
      },
    );
  }
}
