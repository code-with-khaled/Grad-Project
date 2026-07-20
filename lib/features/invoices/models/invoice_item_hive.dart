import 'package:hive/hive.dart';

part 'invoice_item_hive.g.dart';

@HiveType(typeId: 4)
class InvoiceItemHive extends HiveObject {
  @HiveField(0)
  int itemId;

  @HiveField(1)
  String name;

  @HiveField(2)
  double price;

  @HiveField(3)
  int quantity;

  InvoiceItemHive({
    required this.itemId,
    required this.name,
    required this.price,
    required this.quantity,
  });

  double get total => price * quantity;
}
