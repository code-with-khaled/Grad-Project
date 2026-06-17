import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:grad_project/features/visits/models/visit_model.dart';
import 'package:grad_project/features/customers/providers/customer_provider.dart';
import 'package:latlong2/latlong.dart';
import '../../customers/models/customer.dart';

class VisitProvider extends ChangeNotifier {
  Visit? currentVisit;

  // NEW: store all visits
  final List<Visit> _visits = [];

  List<Visit> get allVisits => _visits;
  List<Visit> get completedVisits =>
      _visits.where((v) => v.status == "completed").toList();
  List<Visit> get inProgressVisits =>
      _visits.where((v) => v.status == "in_progress").toList();
  List<Visit> get pendingVisits =>
      _visits.where((v) => v.status == "pending").toList();

  bool get hasActiveVisit => currentVisit != null;

  void startVisit(Customer customer, LatLng gps) {
    if (isVisited(customer.id)) {
      // Optionally, you can throw an error or just return
      return;
    }

    currentVisit = Visit(
      id: _generateId(),
      customerId: customer.id,
      startTime: DateTime.now(),
      startLat: gps.latitude,
      startLng: gps.longitude,
    );

    _visits.add(currentVisit!); // NEW: store visit
    notifyListeners();
  }

  void startVisitOffline(Customer customer) {
    if (isVisited(customer.id)) {
      // Optionally, you can throw an error or just return
      return;
    }

    currentVisit = Visit(
      id: _generateId(),
      customerId: customer.id,
      startTime: DateTime.now(),
      startLat: null,
      startLng: null,
    );

    _visits.add(currentVisit!); // NEW: store visit
    notifyListeners();
  }

  void cancelVisit() {
    if (currentVisit != null) {
      currentVisit!.status = "canceled";
    }
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

  List<Visit> getVisitsForCustomer(String customerId) {
    return _visits.where((v) => v.customerId == customerId).toList();
  }

  bool isVisited(String customerId) {
    return _visits.any(
      (visit) => visit.customerId == customerId && visit.status == "completed",
    );
  }

  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString() +
        Random().nextInt(9999).toString();
  }

  Map<String, dynamic> get visitData {
    final v = currentVisit;
    if (v == null) return {};

    return {
      "id": v.id,
      "visitId": v.id,
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
