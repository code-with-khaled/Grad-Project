// ignore_for_file: avoid_print

import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:grad_project/features/visits/data/visit_repository.dart';
import 'package:hive/hive.dart';
import 'package:latlong2/latlong.dart';

import '../models/visit_hive.dart';
import '../../customers/models/customer_hive.dart';
import '../../customers/providers/customer_provider.dart';
import '../../../core/services/location_service.dart';

class VisitProvider extends ChangeNotifier {
  final VisitRepository repo;
  final LocationService locationService;
  final Box<VisitHive> _box = Hive.box<VisitHive>('visitsBox');

  VisitHive? currentVisit;

  VisitProvider({required this.locationService, required this.repo});

  List<VisitHive> get allVisits => _box.values.toList();
  List<VisitHive> get completedVisits =>
      allVisits.where((v) => v.status == "completed").toList();
  List<VisitHive> get inProgressVisits =>
      allVisits.where((v) => v.status == "in_progress").toList();

  bool get hasActiveVisit => currentVisit != null;

  // --- START VISIT ---
  Future<bool> canStartVisit(CustomerHive c) async {
    return await locationService.isWithinGeofence(
      targetLat: c.lat,
      targetLng: c.lng,
      radiusMeters: 80,
    );
  }

  void startVisit(CustomerHive customer, LatLng gps) {
    final visit = VisitHive(
      customerId: customer.id,
      startTime: DateTime.now(),
      startLat: gps.latitude,
      startLng: gps.longitude,
      status: "in_progress",
      synced: true,
    );

    _box.add(visit);
    currentVisit = visit;
    notifyListeners();
  }

  void startVisitOffline(CustomerHive customer) {
    final visit = VisitHive(
      id: _generateId(),
      customerId: customer.id,
      startTime: DateTime.now(),
      startLat: 0,
      startLng: 0,
      status: "in_progress",
      synced: true,
    );

    _box.add(visit);
    currentVisit = visit;
    notifyListeners();
  }

  Future<void> setVisitId() async {
    currentVisit!.id = 2;
  }

  // --- CHECK IN ---
  Future<void> checkIn(int routeId, CustomerHive customer, LatLng gps) async {
    try {
      final visitId = await repo.checkIn(
        routeId,
        customer.id,
        gps.latitude,
        gps.longitude,
      );

      currentVisit!.id = visitId;
      await currentVisit!.save();
    } catch (e) {
      print("Check-in failed: $e");
    } finally {
      notifyListeners();
    }
  }

  // --- CHECK IN ---
  Future<void> checkOut(int routeId, CustomerHive customer, LatLng gps) async {
    try {
      await repo.checkOut(routeId, customer.id, gps.latitude, gps.longitude);
    } catch (e) {
      print("Check-out failed: $e");
    } finally {
      notifyListeners();
    }
  }

  // --- ATTACH INVOICE ---
  void attachInvoice(int invoiceId) {
    if (currentVisit == null) return;
    currentVisit!.invoiceId = invoiceId;
    currentVisit!.synced = false;
    currentVisit!.save();
    notifyListeners();
  }

  // --- ADD EPOD ---
  void addEPOD({
    required String signaturePath,
    required String photoPath,
    String? notes,
  }) {
    if (currentVisit == null) return;

    currentVisit!
      ..signaturePath = signaturePath
      ..photoPath = photoPath
      ..notes = notes
      ..synced = false;

    currentVisit!.save();
    notifyListeners();
  }

  // --- FINISH VISIT ---
  void finishVisit(LatLng gps, CustomerProvider customerProvider) {
    if (currentVisit == null) return;

    currentVisit!
      ..endTime = DateTime.now()
      ..endLat = gps.latitude
      ..endLng = gps.longitude
      ..status = "completed"
      ..synced = false;

    currentVisit!.save();

    customerProvider.markVisited(currentVisit!.customerId);

    currentVisit = null;
    notifyListeners();
  }

  // --- CANCEL VISIT ---
  void cancelVisit() {
    if (currentVisit == null) return;

    currentVisit!
      ..status = "canceled"
      ..synced = false;

    currentVisit!.save();
    currentVisit = null;
    notifyListeners();
  }

  // --- RESET VISITS (END OF DAY) ---
  Future<void> resetVisits() async {
    await _box.clear();
    currentVisit = null;
    notifyListeners();
  }

  // --- HELPERS ---
  void addDummyEPOD() {
    if (currentVisit == null) return;

    currentVisit!
      ..signaturePath = "dummy_signature.png"
      ..photoPath = "dummy_photo.png"
      ..deliveryLat = 33.50
      ..deliveryLng = 36.20
      ..notes = "Dummy ePOD notes"
      ..synced = false
      ..invoiceId = 12345;

    currentVisit!.save();
    notifyListeners();
  }

  bool isVisited(int customerId) {
    return allVisits.any(
      (v) => v.customerId == customerId && v.status == "completed",
    );
  }

  int _generateId() {
    return DateTime.now().millisecondsSinceEpoch + Random().nextInt(9999);
  }

  List<VisitHive> getVisitsForCustomer(int customerId) {
    return allVisits.where((v) => v.customerId == customerId).toList();
  }
}
