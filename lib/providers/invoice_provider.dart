import 'package:flutter/material.dart';
import '../models/invoice.dart';
import '../models/invoice_item.dart';

class InvoiceProvider extends ChangeNotifier {
  final List<InvoiceItem> _items = [
    InvoiceItem(
      productId: 101,
      productName: "Bottled Water 1.5L",
      quantity: 3,
      price: 0.80,
    ),
    InvoiceItem(
      productId: 102,
      productName: "Orange Juice 1L",
      quantity: 2,
      price: 1.50,
    ),
    InvoiceItem(
      productId: 103,
      productName: "Chocolate Bar",
      quantity: 5,
      price: 0.60,
    ),
    InvoiceItem(
      productId: 104,
      productName: "Chips Family Pack",
      quantity: 1,
      price: 2.20,
    ),
    InvoiceItem(
      productId: 105,
      productName: "Instant Coffee 200g",
      quantity: 1,
      price: 4.75,
    ),
  ];

  List<InvoiceItem> get items => _items;

  void addItem(InvoiceItem item) {
    _items.add(item);
    notifyListeners();
  }

  void removeItem(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  double get total => _items.fold(0, (sum, item) => sum + item.total);

  Invoice generateInvoice(int customerId) {
    return Invoice(
      id: DateTime.now().millisecondsSinceEpoch,
      customerId: customerId,
      date: DateTime.now(),
      items: List.from(_items),
    );
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
