import 'package:flutter/material.dart';
import '../models/invoice.dart';

class InvoiceProvider extends ChangeNotifier {
  final List<Invoice> _invoices = [];

  List<Invoice> get invoices => _invoices;

  void addInvoice(Invoice invoice) {
    _invoices.add(invoice);
    notifyListeners();
  }

  List<Invoice> getInvoicesForVisit(String visitId) {
    return _invoices.where((i) => i.visitId == visitId).toList();
  }
}
