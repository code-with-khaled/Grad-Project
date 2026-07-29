import 'package:hive/hive.dart';
import 'package:grad_project/features/van_stock/models/van_stock_hive.dart';
import 'van_stock_api_service.dart';

class VanStockRepository {
  final VanStockApiService _api;
  final Box<VanStockHive> _box;

  VanStockRepository(this._api, this._box);

  Future<void> syncVanStock(int repId) async {
    final remote = await _api.fetchVanStock(repId);

    for (final dto in remote) {
      _box.put(dto.itemId, dto.toHive());
    }
  }

  List<VanStockHive> getLocalStock() {
    return _box.values.toList();
  }

  VanStockHive? getItem(int itemId) {
    return _box.get(itemId);
  }

  Future<void> updateQuantity(int itemId, int newQty) async {
    final item = _box.get(itemId);
    if (item == null) return;

    item.quantity = newQty;
    item.synced = false;

    await item.save();
  }
}
