<<<<<<< HEAD
import 'package:flutter/material.dart';

import 'dart:async';
=======
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:clima_app2/app/controller/api_controller.dart';
import 'package:clima_app2/app/core/theme/colors/app_colors.dart';
>>>>>>> 906cca7 (Initial commit)

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
<<<<<<< HEAD
    with SingleTickerProviderStateMixin {
  late AnimationController _logoController;
  late Animation<double> _pulseAnimation;
  String _loadingText = 'Carregando clima...';
=======
    with TickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;
    final controller = Get.find<WeatherController>();

  late final AnimationController _tapController;
  late final Animation<double> _tapAnimation;

  String _loadingText = '';
>>>>>>> 906cca7 (Initial commit)

  @override
  void initState() {
    super.initState();

<<<<<<< HEAD
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _pulseAnimation =
        Tween<double>(begin: 0.9, end: 1.1).animate(_logoController);

    // Mensagem alternativa se demorar demais
    Timer(const Duration(seconds: 10), () {
      if (mounted) {
        setState(() {
          _loadingText =
              'Isso está demorando... verifique sua conexão ou GPS.';
=======
    final weatherCtrl = Get.find<WeatherController>();
    _loadingText = 'Buscando clima em ${weatherCtrl.currentCity}...';

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    _fadeController.forward();

    _tapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _tapController.reverse();
        }
      });
    _tapAnimation = Tween<double>(begin: 1.0, end: 0.7)
        .animate(CurvedAnimation(parent: _tapController, curve: Curves.easeOut));

    Timer(const Duration(seconds: 15), () {
      if (mounted) {
        setState(() {
          _loadingText =
              'Ei... ainda carregando! Dá uma olhadinha na sua conexão ou GPS 😉';
        });
      }
    });
    Timer(const Duration(seconds: 35), () {
      if (mounted) {
        setState(() {
          _loadingText =
              'se for sua primeira vez isso pode demorar um pouco, aguarde...';
>>>>>>> 906cca7 (Initial commit)
        });
      }
    });
  }

  @override
  void dispose() {
<<<<<<< HEAD
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 800),

      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _pulseAnimation,
                child: Image.asset('assets/splash_logo/logo.png', ),
              ),
              const SizedBox(height: 20),
              Text(
                _loadingText,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(height: 30),
              const CircularProgressIndicator(color: Colors.white),
            ],
=======
    _fadeController.dispose();
    _tapController.dispose();
    super.dispose();
  }
@override
@override
Widget build(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;
  final textTheme = Theme.of(context).textTheme;

  return Obx(() {
    if (!controller.isLoading.value && controller.weather.value != null) {
      Future.microtask(() => Get.offAllNamed('/home'));
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundTop,
      body: SafeArea(
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedBuilder(
                  animation: _tapAnimation,
                  builder: (_, child) => Opacity(
                    opacity: _tapAnimation.value,
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
                Text(
                  _loadingText,
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 32),
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
              ],
            ),
>>>>>>> 906cca7 (Initial commit)
          ),
        ),
      ),
    );
<<<<<<< HEAD
  }
=======
  });
}
>>>>>>> 906cca7 (Initial commit)
}