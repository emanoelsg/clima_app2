// app/presentation/view/load_screen/loading_screen.dart

// 🌐 Imports de pacotes externos
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// 📦 Imports internos do projeto
import 'package:clima_app2/app/presentation/controller/weather_controller.dart';
import 'package:clima_app2/app/core/theme/colors/app_colors.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> with TickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;
  late final AnimationController _tapController;
  late final Animation<double> _tapAnimation;

  late final WeatherController controller;
  late Timer _phraseTimer;
  late Timer _timeoutTimer;
  late Timer _gpsCheckTimer;

  final List<String> _phrases = [
    'Você sabia? Já nevou em Curitiba em 1975! 🌨️',
    'Dica: Toque no nome da cidade para buscar outro lugar 🗺️',
    'Curiosidade: A menor temperatura registrada no Brasil foi -8.4°C em SC ❄️',
    'Se for sua primeira vez, isso pode demorar um pouco. Aguarde...',
  ];

  int _phraseIndex = 0;
  String _loadingText = '';

  @override
  void initState() {
    super.initState();

    controller = Get.find<WeatherController>();

    _loadingText = 'Buscando clima em ${controller.city}...';

    // ⏳ Verifica GPS a cada 10 segundos
    _gpsCheckTimer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      if (controller.weather.value == null && !controller.isLoading.value) {
        final sucesso = await controller.loadAll();
        if (sucesso && mounted) {
          Get.offAllNamed('/home');
        }
      }
    });

    // 🎞️ Animação de fade-in
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    _fadeController.forward();

    // 👆 Animação de toque no logo
    _tapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _tapController.reverse();
        }
      });
    _tapAnimation = Tween<double>(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(parent: _tapController, curve: Curves.easeOut),
    );

    // ⏱️ Troca de frases a cada 12 segundos
    _phraseTimer = Timer.periodic(const Duration(seconds: 12), (timer) {
      if (mounted) {
        setState(() {
          _phraseIndex = (_phraseIndex + 1) % _phrases.length;
          _loadingText = _phrases[_phraseIndex];
        });
      }
    });

    // ⏳ Timeout de 60 segundos sem resposta
    _timeoutTimer = Timer(const Duration(seconds: 60), () {
      if (mounted && controller.weather.value == null) {
        Get.defaultDialog(
          title: 'Sem conexão 😕',
          middleText: 'Não conseguimos buscar o clima. Verifique sua internet ou GPS.',
          backgroundColor: Colors.grey[900],
          titleStyle: const TextStyle(color: Colors.white),
          middleTextStyle: const TextStyle(color: Colors.white70),
          confirm: ElevatedButton(
            onPressed: () {
              controller.loadAll();
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
    _fadeController.dispose();
    _tapController.dispose();
    _phraseTimer.cancel();
    _timeoutTimer.cancel();
    _gpsCheckTimer.cancel(); // ✅ cancelamento adicionado
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
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🌧️ Logo animado com toque
                AnimatedBuilder(
                  animation: _tapAnimation,
                  builder: (_, child) => Transform.scale(
                    scale: _tapAnimation.value,
                    child: child,
                  ),
                  child: GestureDetector(
                    onTap: () => _tapController.forward(),
                    child: Image.asset(
                      'assets/splash_logo/logo.png',
                      width: 140,
                      height: 140,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // 💬 Frase animada
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: Text(
                    _loadingText,
                    key: ValueKey(_loadingText),
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

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
      ),
    );
  }
}