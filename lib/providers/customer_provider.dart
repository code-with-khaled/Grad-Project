import 'package:flutter/material.dart';
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
        id: 1,
        name: 'John Doe',
        address: '123 Main St',
        phone: '123-456-7890',
        lat: 33.5138,
        lng: 36.2765,
      ),
      Customer(
        id: 2,
        name: 'Jane Smith',
        address: '456 Elm St',
        phone: '987-654-3210',
        lat: 33.5190,
        lng: 36.2800,
      ),
    ];

    _isLoading = false;
    notifyListeners();
  }
}
