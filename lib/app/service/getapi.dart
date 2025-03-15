import 'package:clima_app2/app/service/model.dart';
 import 'package:dio/dio.dart';
 
 class WeatherService {
   final Dio dio = Dio();
   final String key = 'cee0977430f5831b5e35250897e0dac5';
   final String language ='&lang=pt_br';
   final String unidMedida ='&units=metric';
   final String city = '&q=Caratinga,BR';
   late final String url =
       'http://api.openweathermap.org/data/2.5/forecast?$city&appid=$key$language$unidMedida';
 
   Future<WeatherModel?> fetchWeather() async {
     try {
       final response = await dio.get(url);
 
       if (response.statusCode == 200) {
         return WeatherModel.fromJson(response.data);
       } else {
         print('Erro de status code: ${response.statusCode}');
         return null;
       }
     } catch (e) {
       print('Erro na requisição: $e');
       return null;
     }
   }
 }