import 'package:grad_project/features/invoices/models/invoice_item_hive.dart';
import 'package:hive/hive.dart';

part 'invoice_hive.g.dart';

@HiveType(typeId: 3)
class InvoiceHive extends HiveObject {
  @HiveField(0)
  int id; // local invoice id

  @HiveField(1)
  int customerId;

  @HiveField(2)
  int visitId;

  @HiveField(3)
  double total;

  @HiveField(4)
  DateTime createdAt;

  @HiveField(5)
  bool synced;

  @HiveField(6)
  List<InvoiceItemHive> items;

  InvoiceHive({
    required this.id,
    required this.customerId,
    required this.visitId,
    required this.total,
    required this.createdAt,
    required this.items,
    this.synced = false,
  });
}
