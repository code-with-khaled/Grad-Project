import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../models/van_stock_hive.dart';
import '../services/van_stock_local_service.dart';

class VanStockProvider extends ChangeNotifier {
  final VanStockLocalService _local = VanStockLocalService();
  final Box<VanStockHive> _box = Hive.box<VanStockHive>('vanStockBox');

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<VanStockHive> get items => _box.values.toList();

  /// TEMPORARY: load mock van stock, convert to Hive, store it
  Future<void> loadVanStock() async {
    _isLoading = true;
    notifyListeners();

    // 1. Mock data (temporary until backend is ready)
    await Future.delayed(Duration(milliseconds: 500));

    final mock = [
      VanStockHive(id: 1, name: "Pepsi 330ml", price: 500.0, quantity: 24),
      VanStockHive(id: 2, name: "7Up 330ml", price: 500.0, quantity: 24),
      VanStockHive(
        id: 3,
        name: "Mirinda Orange 330ml",
        price: 500.0,
        quantity: 24,
      ),
      VanStockHive(id: 4, name: "Pepsi 1L", price: 1200.0, quantity: 12),
    ];

    // 2. Save mock data to Hive
    await _box.clear();
    await _local.saveAll(mock);

    _isLoading = false;
    notifyListeners();
  }

  /// Deduct quantity after invoice creation
  Future<void> deduct(int itemId, int amount) async {
    await _local.deductQuantity(itemId, amount);
    notifyListeners();
  }

  /// Refresh van stock from Hive
  Future<void> refresh() async {
    notifyListeners();
  }
}
