import 'package:hive/hive.dart';

part 'van_stock_hive.g.dart';

@HiveType(typeId: 2)
class VanStockHive extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  double price;

  @HiveField(3)
  int quantity;

  @HiveField(4)
  bool synced;

  VanStockHive({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    this.synced = true,
  });
}
