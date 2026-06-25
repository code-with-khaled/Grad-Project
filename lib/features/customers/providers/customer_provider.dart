import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../models/customer.dart';

class CustomerProvider extends ChangeNotifier {
  List<Customer> _customers = [];
  bool _isLoading = false;

  List<Customer> get customers => _customers;
  bool get isLoading => _isLoading;

  Future<void> loadCustomers() async {
    _isLoading = true;
    notifyListeners();

    // Mock data
    await Future.delayed(Duration(seconds: 2));
    _customers = [
      Customer(
        name: "Customer 1",
        id: "1",
        address: "Address 1",
        phone: "Phone 1",
        // lat: 33.522222,
        // lng: 36.255556,
        lat: 33.54588821856537,
        lng: 36.21311734279374,
      ),
      Customer(
        name: "Customer 2",
        id: "2",
        address: "Address 2",
        phone: "Phone 2",
        lat: 33.51508,
        lng: 36.27764,
      ),
      Customer(
        name: "Customer 3",
        id: "3",
        address: "Address 3",
        phone: "Phone 3",
        lat: 33.5200,
        lng: 36.2880,
      ),
    ];

    _isLoading = false;
    notifyListeners();
  }

  void markVisited(String customerId) {
    final index = _customers.indexWhere((c) => c.id == customerId);
    if (index != -1) {
      _customers[index].visited = true;
      notifyListeners();
    }
  }

  List<LatLng> getCustomerCoordinates() {
    return _customers.map((c) => LatLng(c.lat, c.lng)).toList();
  }
}
