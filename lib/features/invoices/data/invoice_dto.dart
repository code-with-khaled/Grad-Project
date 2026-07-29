import 'package:grad_project/features/invoices/models/invoice_hive.dart';
import 'package:grad_project/features/invoices/models/invoice_item_hive.dart';

class InvoiceItemDto {
  final int itemId;
  final String name;
  final double price;
  final int quantity;

  InvoiceItemDto({
    required this.itemId,
    required this.name,
    required this.price,
    required this.quantity,
  });

  factory InvoiceItemDto.fromJson(Map<String, dynamic> json) {
    return InvoiceItemDto(
      itemId: json["itemId"],
      name: json["name"],
      price: (json["price"] as num).toDouble(),
      quantity: json["quantity"],
    );
  }

  InvoiceItemHive toHive() {
    return InvoiceItemHive(
      itemId: itemId,
      name: name,
      price: price,
      quantity: quantity,
    );
  }
}

class InvoiceDto {
  final int id;
  final int customerId;
  final int visitId;
  final double total;
  final DateTime createdAt;
  final List<InvoiceItemDto> items;

  InvoiceDto({
    required this.id,
    required this.customerId,
    required this.visitId,
    required this.total,
    required this.createdAt,
    required this.items,
  });

  factory InvoiceDto.fromJson(Map<String, dynamic> json) {
    final List itemsJson = json["items"] ?? [];

    return InvoiceDto(
      id: json["id"],
      customerId: json["customerId"],
      visitId: json["visitId"],
      total: (json["total"] as num).toDouble(),
      createdAt: DateTime.parse(json["createdAt"]),
      items: itemsJson.map((e) => InvoiceItemDto.fromJson(e)).toList(),
    );
  }

  InvoiceHive toHive() {
    return InvoiceHive(
      id: id,
      customerId: customerId,
      visitId: visitId,
      total: total,
      createdAt: createdAt,
      items: items.map((e) => e.toHive()).toList(),
      synced: true,
    );
  }
}
