import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';
import '../services/location_service.dart';

class UserLocationProvider extends ChangeNotifier {
  LatLng? current;

  Future<void> update() async {
    current = await LocationService.getCurrentLocation();
    notifyListeners();
  }
}
