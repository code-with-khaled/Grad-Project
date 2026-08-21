import 'package:hive/hive.dart';
import 'package:grad_project/features/invoices/models/invoice_hive.dart';
import 'invoice_api_service.dart';

class InvoiceRepository {
  final InvoiceApiService _api;
  final Box<InvoiceHive> _box;

  InvoiceRepository(this._api, this._box);

  Future<InvoiceHive> createInvoice({
    required int customerId,
    required int visitId,
    required List<Map<String, dynamic>> items,
  }) async {
    final payload = {
      "customerId": customerId,
      "visitId": visitId,
      "clientUuid": null,
      "lines": items,
    };

    final dto = await _api.createInvoice(payload);

    final hive = dto.toHive();
    _box.put(hive.id, hive);

    return hive;
  }

  Future<InvoiceHive> updateInvoice({
    required int invoiceId,
    required List<Map<String, dynamic>> items,
  }) async {
    final payload = {"items": items};

    final dto = await _api.updateInvoice(invoiceId, payload);

    final hive = dto.toHive();
    _box.put(hive.id, hive);

    return hive;
  }

  Future<void> submitInvoice(int invoiceId) async {
    await _api.submitInvoice(invoiceId);

    final invoice = _box.get(invoiceId);
    if (invoice != null) {
      invoice.synced = true;
      await invoice.save();
    }
  }

  List<InvoiceHive> getLocalInvoices() {
    return _box.values.toList();
  }

  Future<void> syncRemoteInvoices(int repId) async {
    final remote = await _api.fetchInvoices(repId);

    for (final dto in remote) {
      _box.put(dto.id, dto.toHive());
    }
  }
}
