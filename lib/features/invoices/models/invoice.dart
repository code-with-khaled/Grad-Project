import 'invoice_item.dart';

class Invoice {
  final String id;
  final String visitId;
  final String customerId;
  final DateTime date;
  final List<InvoiceItem> items;

  Invoice({
    required this.id,
    required this.visitId,
    required this.customerId,
    required this.date,
    required this.items,
  });

  double get total => items.fold(0, (sum, item) => sum + item.total);
}
