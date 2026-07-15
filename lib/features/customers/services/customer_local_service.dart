import 'package:hive/hive.dart';
import '../models/customer_hive.dart';

class CustomerLocalService {
  final Box<CustomerHive> box = Hive.box<CustomerHive>('customersBox');

  List<CustomerHive> getAll() => box.values.toList();

  Future<void> saveAll(List<CustomerHive> customers) async {
    await box.clear();
    await box.addAll(customers);
  }

  Future<void> updateCustomer(CustomerHive c) async {
    await c.save();
  }

  Future<void> markVisited(int id) async {
    final c = box.values.firstWhere((x) => x.id == id);
    c.visited = true;
    c.synced = false;
    await c.save();
  }
}
