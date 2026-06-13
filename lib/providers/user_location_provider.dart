import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';
import '../services/location_service.dart';

class UserLocationProvider extends ChangeNotifier {
  LatLng? current;

  Future<void> update() async {
    try {
      final pos = await LocationService.getCurrentLocation();
      current = pos;
      notifyListeners();
    } catch (e) {
      // ignore: avoid_print
      print("Location update failed: $e");
    }
  }
}
