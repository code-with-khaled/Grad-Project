import 'package:grad_project/features/invoices/models/invoice_hive.dart';
import 'package:hive/hive.dart';

class InvoiceLocalService {
  final Box<InvoiceHive> box = Hive.box<InvoiceHive>('invoicesBox');

  List<InvoiceHive> getAll() => box.values.toList();

  Future<void> addInvoice(InvoiceHive invoice) async {
    await box.add(invoice);
  }

  Future<void> markSynced(InvoiceHive invoice) async {
    invoice.synced = true;
    await invoice.save();
  }
}
