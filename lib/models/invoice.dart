import 'invoice_item.dart';

class Invoice {
  final int id;
  final int customerId;
  final DateTime date;
  final List<InvoiceItem> items;

  Invoice({
    required this.id,
    required this.customerId,
    required this.date,
    required this.items,
  });

  double get total => items.fold(0, (sum, item) => sum + item.total);
}
