import 'package:clima_app2/app/controller/api_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('')),
      body: SafeArea(
        child: Column(
          children: [
            Consumer<WeatherController>(
              builder: (context, value, child) {
                if (value.isLoading == true) {
                  return Center(child: CircularProgressIndicator());
                }
                if (value.error != null) {
                  return Center(child: Text(value.error.toString()));
                }
                if (value.weather == null) {
                  return Center(child: Text('Não foi possível carregar dados'));
                }return Center(child:Text('dados carregados'));
              },
            ),],
          
        ),
      ),
    floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<WeatherController>().fetchWeather(),
        child: Icon(Icons.refresh),
      ),);
  }
}
