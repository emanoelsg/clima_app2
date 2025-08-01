// main.dart

// 🌐 Imports de pacotes externos
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';

// 📦 Imports internos do projeto
import 'package:clima_app2/app/core/theme/app_theme.dart';
import 'package:clima_app2/app/presentation/view/home_page/home_page.dart';
import 'package:clima_app2/app/presentation/view/load_screen/loading_screen.dart';
import 'package:clima_app2/app/presentation/view/search_screen/search_screen.dart';

Future<void> main() async {
  // 🔧 Inicializa bindings do Flutter (necessário para chamadas assíncronas antes do runApp)
  WidgetsFlutterBinding.ensureInitialized();

  // 🌍 Inicializa formatação de datas para o Brasil
  await initializeDateFormatting('pt_BR', null);

  // 💾 Inicializa armazenamento local com GetStorage
  await GetStorage.init();

  // 🚀 Inicia o app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,

      // 🧭 Define rotas nomeadas para navegação
      routes: {
        '/': (context) => LoadingScreen(),
        '/home': (context) => const HomeScreen(),
        '/search': (context) => SearchScreen(),
      },
    );
  }
}