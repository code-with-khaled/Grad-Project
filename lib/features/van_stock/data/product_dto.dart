class ProductDto {
  final int id;
  final String name;
  final String sku;
  final String barcode;
  final double price;
  final String unitOfMeasure;
  final int minStockLevel;
  final String status;

  ProductDto({
    required this.id,
    required this.name,
    required this.sku,
    required this.barcode,
    required this.price,
    required this.unitOfMeasure,
    required this.minStockLevel,
    required this.status,
  });

  factory ProductDto.fromJson(Map<String, dynamic> json) {
    return ProductDto(
      id: json["id"],
      name: json["name"],
      sku: json["sku"],
      barcode: json["barcode"],
      price: (json["price"] as num).toDouble(),
      unitOfMeasure: json["unitOfMeasure"],
      minStockLevel: json["minStockLevel"],
      status: json["status"],
    );
  }
}
