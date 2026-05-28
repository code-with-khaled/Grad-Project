import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:grad_project/models/visit_model.dart';
import 'package:grad_project/providers/customer_provider.dart';
import 'package:latlong2/latlong.dart';
import '../models/customer.dart';

class VisitProvider extends ChangeNotifier {
  Visit? currentVisit;

  bool get hasActiveVisit => currentVisit != null;

  void startVisit(Customer customer, LatLng gps) {
    // If a visit is already active, ignore or cancel it
    currentVisit = Visit(
      id: _generateId(),
      customerId: customer.id,
      startTime: DateTime.now(),
      startLat: gps.latitude,
      startLng: gps.longitude,
    );

    notifyListeners();
  }

  void cancelVisit() {
    currentVisit = null;
    notifyListeners();
  }

  void finishVisit(LatLng gps, CustomerProvider customerProvider) {
    if (currentVisit == null) return;

    currentVisit!.endTime = DateTime.now();
    currentVisit!.endLat = gps.latitude;
    currentVisit!.endLng = gps.longitude;
    currentVisit!.status = "completed";

    customerProvider.markVisited(currentVisit!.customerId);

    notifyListeners();
  }

  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString() +
        Random().nextInt(9999).toString();
  }

  // for debugging/demo purposes, returns current visit data as a map
  Map<String, dynamic> get visitData {
    final v = currentVisit;
    if (v == null) return {};

    return {
      "id": v.id,
      "customerId": v.customerId,
      "startTime": v.startTime.toIso8601String(),
      "startLat": v.startLat,
      "startLng": v.startLng,
      "endTime": v.endTime?.toIso8601String(),
      "endLat": v.endLat,
      "endLng": v.endLng,
      "status": v.status,
    };
  }
}
