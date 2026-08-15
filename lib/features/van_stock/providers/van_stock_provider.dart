// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:grad_project/features/van_stock/data/van_stock_repository.dart';
// import 'package:hive/hive.dart';

import '../models/van_stock_hive.dart';
// import '../services/van_stock_local_service.dart';

// class VanStockProvider extends ChangeNotifier {
//   final VanStockLocalService _local = VanStockLocalService();
//   final Box<VanStockHive> _box = Hive.box<VanStockHive>('vanStockBox');

//   bool _isLoading = false;
//   bool get isLoading => _isLoading;

//   List<VanStockHive> get items => _box.values.toList();

//   /// MORNING: Load today's van stock (reset)
//   Future<void> loadVanStock() async {
//     _isLoading = true;
//     notifyListeners();

//     await Future.delayed(Duration(milliseconds: 500));

//     final mock = [
//       VanStockHive(id: 1, name: "Pepsi 330ml", price: 500.0, quantity: 24),
//       VanStockHive(id: 2, name: "7Up 330ml", price: 500.0, quantity: 24),
//       VanStockHive(
//         id: 3,
//         name: "Mirinda Orange 330ml",
//         price: 500.0,
//         quantity: 24,
//       ),
//       VanStockHive(id: 4, name: "Pepsi 1L", price: 1200.0, quantity: 12),
//     ];

//     await _box.clear();
//     await _local.saveAll(mock);

//     _isLoading = false;
//     notifyListeners();
//   }

//   /// DURING THE DAY: Deduct stock after invoice
//   Future<void> deduct(int itemId, int amount) async {
//     await _local.deductQuantity(itemId, amount);
//     notifyListeners();
//   }

//   /// END OF DAY: Reset stock
//   Future<void> resetStock() async {
//     await _box.clear();
//     notifyListeners();
//   }
// }

class VanStockProvider extends ChangeNotifier {
  final VanStockRepository _repo;

  VanStockProvider(this._repo);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<VanStockHive> get items => _repo.getLocalStock();

  /// MORNING: Load today's van stock from backend
  Future<bool> loadVanStock(int repId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repo.syncVanStock(repId);

      return true;
    } catch (e) {
      print("Failed to load van stock: $e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// DURING THE DAY: Deduct stock after invoice
  Future<void> deduct(int itemId, int amount) async {
    final item = _repo.getItem(itemId);
    if (item == null) return;

    final newQty = item.quantity - amount;
    await _repo.updateQuantity(itemId, newQty);

    notifyListeners();
  }

  /// END OF DAY: Reset stock
  Future<void> resetStock() async {
    await _repo.resetStock();
    notifyListeners();
  }
}
