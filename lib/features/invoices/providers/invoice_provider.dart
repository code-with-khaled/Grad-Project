import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../models/invoice_hive.dart';
import '../models/invoice_item_hive.dart';

class InvoiceProvider extends ChangeNotifier {
  final Box<InvoiceHive> _box = Hive.box<InvoiceHive>('invoicesBox');

  List<InvoiceHive> get invoices => _box.values.toList();

  List<InvoiceHive> getInvoicesForVisit(int visitId) {
    return _box.values.where((i) => i.visitId == visitId).toList();
  }

  Future<int> addInvoice({
    required int customerId,
    required int visitId,
    required List<InvoiceItemHive> items,
  }) async {
    final id = DateTime.now().millisecondsSinceEpoch;

    final total = items.fold(
      0.0,
      (sum, item) => sum + item.price * item.quantity,
    );

    final invoice = InvoiceHive(
      id: id,
      customerId: customerId,
      visitId: visitId,
      total: total,
      createdAt: DateTime.now(),
      items: items,
      synced: false,
    );

    await _box.add(invoice);
    notifyListeners();

    return id;
  }
}
