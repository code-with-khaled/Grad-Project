import 'package:hive/hive.dart';
import 'package:grad_project/features/customers/models/customer_hive.dart';
import 'customer_api_service.dart';

class CustomerRepository {
  final CustomerApiService _api;
  final Box<CustomerHive> _box;

  CustomerRepository(this._api, this._box);

  Future<void> syncCustomers() async {
    final remoteCustomers = await _api.fetchCustomers();

    for (final dto in remoteCustomers) {
      _box.put(dto.id, dto.toHive());
    }
  }

  List<CustomerHive> getAllLocal() {
    return _box.values.toList();
  }

  CustomerHive? getById(int id) {
    return _box.get(id);
  }

  Future<void> updateVisited(int id, bool visited) async {
    final customer = _box.get(id);
    if (customer == null) return;

    customer.visited = visited;
    customer.synced = false;

    await customer.save();
  }

  Future<void> clearAll() async {
    await _box.clear();
  }
}
