// app/core/utils/helpers/localization/get_current_city.dart
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

Future<String?> getCurrentCity() async {
  try {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return null;
    }

    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    );



    final placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    final place = placemarks.first;


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
      return null;
    }

    final city = '$cityCandidate,${place.isoCountryCode}';


    return city;
  } catch (e) {
    return null;
  }
}