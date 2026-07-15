import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:latlong2/latlong.dart';

import '../models/customer_hive.dart';

class CustomerProvider extends ChangeNotifier {
  final Box<CustomerHive> _box = Hive.box<CustomerHive>('customersBox');

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<CustomerHive> get customers => _box.values.toList();

  /// TEMPORARY: load mock customers, convert to Hive, store them
  Future<void> loadCustomers() async {
    _isLoading = true;
    notifyListeners();

    // 1. Mock data (your existing customers)
    await Future.delayed(Duration(seconds: 1));
    final mock = [
      CustomerHive(
        name: "Customer 1",
        id: 1,
        address: "Address 1",
        phone: "Phone 1",
        lat: 33.54588821856537,
        lng: 36.21311734279374,
      ),
      CustomerHive(
        name: "Customer 2",
        id: 2,
        address: "Address 2",
        phone: "Phone 2",
        lat: 33.51508,
        lng: 36.27764,
      ),
      CustomerHive(
        name: "Customer 3",
        id: 3,
        address: "Address 3",
        phone: "Phone 3",
        lat: 33.5200,
        lng: 36.2880,
      ),
    ];

    // 2. Convert mock → Hive model
    final hiveList = mock.map((c) {
      return CustomerHive(
        id: c.id,
        name: c.name,
        address: c.address,
        lat: c.lat,
        lng: c.lng,
        phone: c.phone,
        visited: false,
        synced: true,
      );
    }).toList();

    // 3. Save to Hive
    await _box.clear();
    await _box.addAll(hiveList);

    _isLoading = false;
    notifyListeners();
  }

  /// Mark visited (offline)
  Future<void> markVisited(int customerId) async {
    final c = _box.values.firstWhere((x) => x.id == customerId);
    c.visited = true;
    c.synced = false;
    await c.save();
    notifyListeners();
  }

  /// For route planning
  List<LatLng> getCustomerCoordinates() {
    return customers.map((c) => LatLng(c.lat, c.lng)).toList();
  }
}
