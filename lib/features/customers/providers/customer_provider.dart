// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:grad_project/features/customers/data/customer_repository.dart';
// import 'package:hive/hive.dart';
import 'package:latlong2/latlong.dart';

import '../models/customer_hive.dart';

// class CustomerProvider extends ChangeNotifier {
//   final Box<CustomerHive> _box = Hive.box<CustomerHive>('customersBox');

//   bool _isLoading = false;
//   bool get isLoading => _isLoading;

//   List<CustomerHive> get customers => _box.values.toList();

//   /// MORNING: Load today's customers (reset)
//   Future<void> loadCustomers() async {
//     _isLoading = true;
//     notifyListeners();

//     await Future.delayed(Duration(milliseconds: 500));

//     final mock = [
//       CustomerHive(
//         id: 1,
//         name: "Customer 1",
//         address: "Address 1",
//         phone: "Phone 1",
//         lat: 33.54588821856537,
//         lng: 36.21311734279374,
//         visited: false,
//         synced: true,
//       ),
//       CustomerHive(
//         id: 2,
//         name: "Customer 2",
//         address: "Address 2",
//         phone: "Phone 2",
//         lat: 33.51508,
//         lng: 36.27764,
//         visited: false,
//         synced: true,
//       ),
//       CustomerHive(
//         id: 3,
//         name: "Customer 3",
//         address: "Address 3",
//         phone: "Phone 3",
//         lat: 33.5200,
//         lng: 36.2880,
//         visited: false,
//         synced: true,
//       ),
//     ];

//     await _box.clear();
//     await _box.addAll(mock);

//     _isLoading = false;
//     notifyListeners();
//   }

//   /// DURING THE DAY: Mark visited
//   Future<void> markVisited(int customerId) async {
//     final c = _box.values.firstWhere((x) => x.id == customerId);
//     c.visited = true;
//     c.synced = false;
//     await c.save();
//     notifyListeners();
//   }

//   /// END OF DAY: Reset visited flags
//   Future<void> resetCustomers() async {
//     for (final c in _box.values) {
//       c.visited = false;
//       c.synced = true;
//       await c.save();
//     }
//     notifyListeners();
//   }

//   List<LatLng> getCustomerCoordinates() {
//     return customers.map((c) => LatLng(c.lat, c.lng)).toList();
//   }
// }

class CustomerProvider extends ChangeNotifier {
  final CustomerRepository _repo;

  CustomerProvider(this._repo);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<CustomerHive> get customers => _repo.getAllLocal();

  /// MORNING: Load today's customers (reset)
  Future<void> loadCustomers() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repo.syncCustomers(); // REAL backend call
    } catch (e) {
      print("Failed to load customers: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  /// DURING THE DAY: Mark visited
  Future<void> markVisited(int customerId) async {
    final c = _repo.getById(customerId);
    c!.visited = true;
    c.synced = false;
    await _repo.updateVisited(c.id, c.visited);
    notifyListeners();
  }

  Future<void> clearAll() async {
    try {
      await _repo.clearAll();
      print(_repo.runtimeType);
      print(_repo);
    } catch (e) {
      print("ClearAll failed: $e");
    }
    notifyListeners();
  }

  /// END OF DAY: Reset visited flags
  Future<void> resetCustomers() async {
    final all = _repo.getAllLocal();
    for (final c in all) {
      c.visited = false;
      c.synced = true;
      await c.save();
    }
    notifyListeners();
  }

  List<LatLng> getCustomerCoordinates() {
    return customers.map((c) => LatLng(c.lat, c.lng)).toList();
  }
}
