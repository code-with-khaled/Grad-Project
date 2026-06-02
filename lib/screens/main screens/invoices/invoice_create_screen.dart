import 'package:flutter/material.dart';
import 'package:grad_project/models/invoice.dart';
import 'package:grad_project/models/invoice_item.dart';
import 'package:grad_project/models/visit_model.dart';
import 'package:grad_project/providers/invoice_provider.dart';
import 'package:provider/provider.dart';

class InvoiceCreateScreen extends StatefulWidget {
  final Visit visit;

  const InvoiceCreateScreen({super.key, required this.visit});

  @override
  State<InvoiceCreateScreen> createState() => _InvoiceCreateScreenState();
}

class _InvoiceCreateScreenState extends State<InvoiceCreateScreen> {
  final List<InvoiceItem> _items = [];

  void _addItem() {
    showDialog(
      context: context,
      builder: (_) => _AddItemDialog(
        onAdd: (item) {
          setState(() => _items.add(item));
        },
      ),
    );
  }

  void _saveInvoice() {
    final invoice = Invoice(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      visitId: widget.visit.id,
      customerId: widget.visit.customerId.toString(),
      date: DateTime.now(),
      items: _items,
    );

    context.read<InvoiceProvider>().addInvoice(invoice);

    Navigator.pop(context); // close invoice screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Invoice")),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        child: Icon(Icons.add),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: _items.map((item) {
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text("${item.quantity} × ${item.price}"),
                  trailing: Text(item.total.toStringAsFixed(2)),
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: _items.isEmpty ? null : _saveInvoice,
              child: Text("Save Invoice"),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddItemDialog extends StatefulWidget {
  final Function(InvoiceItem) onAdd;

  const _AddItemDialog({required this.onAdd});

  @override
  State<_AddItemDialog> createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<_AddItemDialog> {
  final nameCtrl = TextEditingController();
  final qtyCtrl = TextEditingController();
  final priceCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Add Item"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameCtrl,
            decoration: InputDecoration(labelText: "Item name"),
          ),
          TextField(
            controller: qtyCtrl,
            decoration: InputDecoration(labelText: "Quantity"),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: priceCtrl,
            decoration: InputDecoration(labelText: "Unit price"),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            final item = InvoiceItem(
              name: nameCtrl.text,
              quantity: int.parse(qtyCtrl.text),
              price: double.parse(priceCtrl.text),
            );
            widget.onAdd(item);
            Navigator.pop(context);
          },
          child: Text("Add"),
        ),
      ],
    );
  }
}
