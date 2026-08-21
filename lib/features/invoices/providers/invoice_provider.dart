import 'package:flutter/material.dart';
import 'package:grad_project/features/invoices/data/invoice_repository.dart';
import 'package:hive/hive.dart';

import '../models/invoice_hive.dart';
import '../models/invoice_item_hive.dart';

class InvoiceProvider extends ChangeNotifier {
  final InvoiceRepository _repo;

  InvoiceProvider(this._repo);

  final Box<InvoiceHive> _box = Hive.box<InvoiceHive>('invoicesBox');

  List<InvoiceHive> get invoices => _box.values.toList();

  List<InvoiceHive> getInvoicesForVisit(int visitId) {
    return _box.values.where((i) => i.visitId == visitId).toList();
  }

  Future<InvoiceHive> createDraftInvoice({
    required int customerId,
    required int visitId,
    required List<InvoiceItemHive> items,
  }) async {
    // Convert Hive items → backend payload
    final lines = items.map((item) {
      return {
        "productId": item.itemId,
        "quantity": item.quantity,
        "discount": 0, //TODO: item.discount
      };
    }).toList();

    // Call repository
    final invoice = await _repo.createInvoice(
      customerId: customerId,
      visitId: visitId,
      items: lines,
    );

    notifyListeners();
    return invoice;
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
