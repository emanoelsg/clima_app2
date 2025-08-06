// app/presentation/view/load_screen/loading_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:clima_app2/app/presentation/controller/weather_controller.dart';
import 'package:clima_app2/app/core/theme/colors/app_colors.dart';
import 'package:clima_app2/app/presentation/view/home_page/home_page.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  late final WeatherController controller;
  late Timer _phraseTimer;
  late Timer _timeoutTimer;

  final List<String> _phrases = [
    'Você sabia? Já nevou em Curitiba em 1975! 🌨️',
    'Dica: Toque no nome da cidade para buscar outro lugar 🗺️',
    'Curiosidade: A menor temperatura registrada no Brasil foi -8.4°C em SC ❄️',
    'Se for sua primeira vez, isso pode demorar um pouco. Aguarde...',
  ];

  int _phraseIndex = 0;

  @override
  void initState() {
    super.initState();

    controller = Get.put(WeatherController());
    controller.loadingText.value = 'Buscando clima em ${controller.city}...';

    _startPhraseTimer();
    _startTimeoutTimer();
ever(controller.weather, (weatherData) {
  if (weatherData != null) {
    Get.off(() => const HomeScreen());
  }
});
  }



  void _startPhraseTimer() {
    _phraseTimer = Timer.periodic(const Duration(seconds: 8), (timer) {
      if (!mounted) return;

      final nextIndex = (_phraseIndex + 1) % _phrases.length;
      final nextPhrase = _phrases[nextIndex];

      if (nextPhrase != controller.loadingText.value) {
        _phraseIndex = nextIndex;
        controller.loadingText.value = nextPhrase;
      }
    });
  }

  void _startTimeoutTimer() {
    _timeoutTimer = Timer(const Duration(seconds: 40), () {
      if (mounted && controller.weather.value == null) {
        Get.defaultDialog(
          title: 'Sem conexão 😕',
          middleText: 'Não conseguimos buscar o clima. Verifique sua internet ou GPS.',
          backgroundColor: Colors.grey[900],
          titleStyle: const TextStyle(color: Colors.white),
          middleTextStyle: const TextStyle(color: Colors.white70),
          confirm: ElevatedButton(
            onPressed: () {
              Get.back();
   
            },
            child: const Text('Tentar novamente'),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _phraseTimer.cancel();
    _timeoutTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.backgroundTop,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 🌧️ Logo estático
              Image.asset(
                'assets/splash_logo/logo.png',
                width: 140,
                height: 140,
              ),

              const SizedBox(height: 24),

              // 💬 Frase reativa
              Obx(() => AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: Text(
                      controller.loadingText.value,
                      key: ValueKey(controller.loadingText.value),
                      textAlign: TextAlign.center,
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )),

              const SizedBox(height: 32),

              // 📊 Barra de progresso
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    color: colorScheme.primary,
                    backgroundColor: colorScheme.primary.withOpacity(0.2),
                    minHeight: 6,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // 📢 Aviso sobre GPS e internet
              Text(
                'Verifique se seu GPS e internet estão ligados',
                textAlign: TextAlign.center,
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}