import 'package:hive/hive.dart';
import '../models/van_stock_hive.dart';

class VanStockLocalService {
  final Box<VanStockHive> box = Hive.box<VanStockHive>('vanStockBox');

  /// Get all van stock items
  List<VanStockHive> getAll() {
    return box.values.toList();
  }

  /// Replace all van stock items (used for morning fetch or mock data)
  Future<void> saveAll(List<VanStockHive> items) async {
    await box.clear();
    await box.addAll(items);
  }

  /// Update a single item (e.g., after invoice deduction)
  Future<void> updateItem(VanStockHive item) async {
    await item.save();
  }

  /// Deduct quantity after creating an invoice
  Future<void> deductQuantity(int itemId, int amount) async {
    final item = box.values.firstWhere((x) => x.id == itemId);

    item.quantity -= amount;
    item.synced = false; // mark for sync
    await item.save();
  }

  /// Reset synced flag after successful sync
  Future<void> markSynced(int itemId) async {
    final item = box.values.firstWhere((x) => x.id == itemId);
    item.synced = true;
    await item.save();
  }
}
