import 'package:grad_project/features/van_stock/models/van_stock_hive.dart';

class VanStockDto {
  final int itemId;
  final String name;
  final int quantity;
  final double price;

  VanStockDto({
    required this.itemId,
    required this.name,
    required this.quantity,
    required this.price,
  });

  factory VanStockDto.fromJson(Map<String, dynamic> json) {
    return VanStockDto(
      itemId: json["itemId"],
      name: json["name"],
      quantity: json["quantity"],
      price: (json["price"] as num).toDouble(),
    );
  }

  VanStockHive toHive() {
    return VanStockHive(
      id: itemId,
      name: name,
      quantity: quantity,
      price: price,
      synced: true,
    );
  }
}
