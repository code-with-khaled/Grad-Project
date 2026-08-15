import 'package:hive/hive.dart';

part 'van_stock_hive.g.dart';

@HiveType(typeId: 2)
class VanStockHive extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  int productId;

  @HiveField(2)
  String name;

  @HiveField(3)
  String sku;

  @HiveField(4)
  String barcode;

  @HiveField(5)
  double price;

  @HiveField(6)
  String unitOfMeasure;

  @HiveField(7)
  int minStockLevel;

  @HiveField(8)
  int quantity;

  @HiveField(9)
  bool synced;

  VanStockHive({
    required this.id,
    required this.productId,
    required this.name,
    required this.sku,
    required this.barcode,
    required this.price,
    required this.unitOfMeasure,
    required this.minStockLevel,
    required this.quantity,
    this.synced = true,
  });
}
