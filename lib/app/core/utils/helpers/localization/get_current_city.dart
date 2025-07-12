import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

Future<String?> getCurrentCity() async {
  try {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('❌ Serviço de localização desativado');
      return null;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('❌ Permissão de localização negada');
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('❌ Permissão negada permanentemente');
      return null;
    }

    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    );

    print('📍 Coordenadas: ${position.latitude}, ${position.longitude}');

    final placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    final place = placemarks.first;

    print('🧾 Placemark: ${place.toString()}');

    // Fallback inteligente para cidade
    final cityCandidate = [
      place.locality,
      place.subAdministrativeArea,
      place.administrativeArea,
      place.name,
    ].firstWhere(
      (value) => value != null && value.trim().isNotEmpty,
      orElse: () => '',
    );

    if (cityCandidate!.isEmpty || place.isoCountryCode == null) {
      print('❌ Cidade inválida ou país ausente');
      return null;
    }

    final city = '$cityCandidate,${place.isoCountryCode}';
    print('🏙️ Cidade detectada: $city');

    return city;
  } catch (e) {
    print('❌ Erro ao obter cidade: $e');
    return null;
  }
}