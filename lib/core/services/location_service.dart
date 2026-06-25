import 'dart:math';

import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class LocationService {
  // -----------------------------
  // GET CURRENT POSITION
  // -----------------------------
  static Future<LatLng> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      throw Exception("Location services are disabled.");
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("Location permission denied.");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
      throw Exception("Location permission permanently denied.");
    }

    final pos = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );

    return LatLng(pos.latitude, pos.longitude);
  }

  // -----------------------------
  // HAVERSINE DISTANCE
  // -----------------------------
  double _degToRad(double deg) => deg * (pi / 180.0);

  double distanceInMeters({
    required double lat1,
    required double lon1,
    required double lat2,
    required double lon2,
  }) {
    const R = 6371000; // Earth radius in meters

    final dLat = _degToRad(lat2 - lat1);
    final dLon = _degToRad(lon2 - lon1);

    final a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_degToRad(lat1)) *
            cos(_degToRad(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return R * c;
  }

  // -----------------------------
  // GEOFENCE CHECK
  // -----------------------------
  Future<bool> isWithinGeofence({
    required double targetLat,
    required double targetLng,
    double radiusMeters = 80, // default radius
  }) async {
    final pos = await getCurrentLocation();

    final distance = distanceInMeters(
      lat1: pos.latitude,
      lon1: pos.longitude,
      lat2: targetLat,
      lon2: targetLng,
    );

    return distance <= radiusMeters;
  }
}
