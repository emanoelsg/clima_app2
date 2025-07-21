import 'package:flutter/material.dart';

import 'dart:async';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _logoController;
  late Animation<double> _pulseAnimation;
  String _loadingText = 'Carregando clima...';

  @override
  void initState() {
    super.initState();

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
        });
      }
    });
  }

  @override
  void dispose() {
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
          ),
        ),
      ),
    );
  }
}