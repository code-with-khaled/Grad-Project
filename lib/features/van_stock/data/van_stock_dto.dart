import 'package:grad_project/features/van_stock/data/product_dto.dart';
import 'package:grad_project/features/van_stock/models/van_stock_hive.dart';

class VanStockDto {
  final int id;
  final int representativeId;
  final String representativeName;
  final int quantity;
  final ProductDto product;

  VanStockDto({
    required this.id,
    required this.representativeId,
    required this.representativeName,
    required this.quantity,
    required this.product,
  });

  factory VanStockDto.fromJson(Map<String, dynamic> json) {
    return VanStockDto(
      id: json["id"],
      representativeId: json["representativeId"],
      representativeName: json["representativeName"],
      quantity: json["quantity"],
      product: ProductDto.fromJson(json["product"]),
    );
  }
}

extension VanStockMapper on VanStockDto {
  VanStockHive toHive() {
    return VanStockHive(
      id: id,
      productId: product.id,
      name: product.name,
      sku: product.sku,
      barcode: product.barcode,
      price: product.price,
      unitOfMeasure: product.unitOfMeasure,
      minStockLevel: product.minStockLevel,
      quantity: quantity,
      synced: true,
    );
  }
}
