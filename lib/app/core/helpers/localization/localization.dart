// app/utils/helpers/localization/localization.dart

import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

/// 📍 Obtém a cidade atual do usuário com base na geolocalização
Future<String?> getCurrentCity() async {
  try {
    // Verifica se o serviço de localização está ativado
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    // Verifica e solicita permissão de localização
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return null;
    }
    if (permission == LocationPermission.deniedForever) return null;

    // Obtém a posição atual com alta precisão
    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    );

    // Converte coordenadas em informações de local
    final placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    final place = placemarks.first;

    // 🧠 Fallback inteligente para nome da cidade
    final cityCandidate = [
      place.locality,
      place.subAdministrativeArea,
      place.administrativeArea,
      place.name,
    ].firstWhere(
      (value) => value != null && value.trim().isNotEmpty,
      orElse: () => '',
    );

    // Validação final
    if (cityCandidate!.isEmpty || place.isoCountryCode == null) return null;

    // Ex: "Caratinga,BR"
    return '$cityCandidate,${place.isoCountryCode}';
  } catch (e) {
    // Em caso de erro (ex: sem internet, timeout)
    return null;
  }
}