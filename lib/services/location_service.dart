import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  
  Future<bool> requestPermission() async {
    try {
      final status = await Permission.location.request();
      return status.isGranted;
    } catch (e) {
      return false;
    }
  }

  
  Future<bool> hasPermission() async {
    try {
      final status = await Permission.location.status;
      return status.isGranted;
    } catch (e) {
      return false;
    }
  }

  
  Future<Position?> getCurrentPosition() async {
    try {
      final hasPermission = await this.hasPermission();
      if (!hasPermission) {
        final granted = await requestPermission();
        if (!granted) {
          return null;
        }
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 10),
      );
      return position;
    } catch (e) {
      return null;
    }
  }

  
  Future<String?> getAddressFromCoordinates(
      double latitude, double longitude) async {
    try {
      final placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isEmpty) {
        return null;
      }

      final place = placemarks.first;
      final parts = <String>[];

      if (place.locality != null && place.locality!.isNotEmpty) {
        parts.add(place.locality!);
      }
      if (place.street != null && place.street!.isNotEmpty) {
        parts.add(place.street!);
      }
      if (place.subLocality != null && place.subLocality!.isNotEmpty) {
        parts.add(place.subLocality!);
      }

      return parts.isNotEmpty ? parts.join(', ') : null;
    } catch (e) {
      return null;
    }
  }

  
  Future<Map<String, dynamic>?> getCurrentLocationWithAddress() async {
    try {
      final position = await getCurrentPosition();
      if (position == null) {
        return null;
      }

      final address =
          await getAddressFromCoordinates(position.latitude, position.longitude);

      return {
        'latitude': position.latitude,
        'longitude': position.longitude,
        'address': address ?? 'Unknown Location',
      };
    } catch (e) {
      return null;
    }
  }
}

