import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:grad_project/features/visits/models/visit_hive.dart';
import 'package:grad_project/features/invoices/models/invoice_item_hive.dart';
import 'package:grad_project/features/invoices/providers/invoice_provider.dart';
import 'package:grad_project/features/van_stock/providers/van_stock_provider.dart';
import 'package:grad_project/features/visits/providers/visit_provider.dart';

class InvoiceCreateScreen extends StatefulWidget {
  final VisitHive visit;

  const InvoiceCreateScreen({super.key, required this.visit});

  @override
  State<InvoiceCreateScreen> createState() => _InvoiceCreateScreenState();
}

class _InvoiceCreateScreenState extends State<InvoiceCreateScreen> {
  final List<InvoiceItemHive> _items = [];

  double get total =>
      _items.fold(0, (sum, item) => sum + (item.price * item.quantity));

  void _addItem() {
    final vanItems = context.read<VanStockProvider>().items;

    showModalBottomSheet(
      context: context,
      builder: (_) {
        return ListView(
          children: vanItems.map((stockItem) {
            return ListTile(
              title: Text(stockItem.name),
              subtitle: Text(
                "Price: ${stockItem.price} • Available: ${stockItem.quantity}",
              ),
              onTap: () async {
                final qtyController = TextEditingController();

                final qty = await showDialog<int>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text("Quantity for ${stockItem.name}"),
                    content: TextField(
                      controller: qtyController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(hintText: "Enter quantity"),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          final q = int.tryParse(qtyController.text);
                          Navigator.pop(context, q);
                        },
                        child: Text("Add"),
                      ),
                    ],
                  ),
                );

                if (qty != null && qty > 0 && qty <= stockItem.quantity) {
                  setState(() {
                    _items.add(
                      InvoiceItemHive(
                        itemId: stockItem.id,
                        name: stockItem.name,
                        price: stockItem.price,
                        quantity: qty,
                      ),
                    );
                  });
                }

                if (!mounted) return;
                Navigator.pop(context);
              },
            );
          }).toList(),
        );
      },
    );
  }

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
  }

  Future<void> _saveInvoice() async {
    final invoiceProvider = context.read<InvoiceProvider>();
    final visitProvider = context.read<VisitProvider>();
    final vanStockProvider = context.read<VanStockProvider>();

    // 1. Create invoice
    final invoiceId = await invoiceProvider.addInvoice(
      customerId: widget.visit.customerId,
      visitId: widget.visit.id,
      items: _items,
    );

    // 2. Deduct stock
    for (final item in _items) {
      await vanStockProvider.deduct(item.itemId, item.quantity);
    }

    // 3. Attach invoice to visit
    visitProvider.attachInvoice(invoiceId);

    // 4. Return invoiceId to VisitSummaryScreen
    if (!mounted) return;
    Navigator.pop(context, invoiceId);
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
            child: ListView.builder(
              itemCount: _items.length,
              itemBuilder: (_, index) {
                final item = _items[index];
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text("${item.quantity} × ${item.price}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text((item.price * item.quantity).toStringAsFixed(2)),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removeItem(index),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Total
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  "Total: ${total.toStringAsFixed(2)}",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                ElevatedButton(
                  onPressed: _items.isEmpty ? null : _saveInvoice,
                  child: Text("Save Invoice"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
