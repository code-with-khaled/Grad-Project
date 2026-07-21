import 'package:flutter/material.dart';
import 'package:grad_project/features/visits/models/visit_hive.dart';
import 'package:provider/provider.dart';

import 'package:grad_project/features/invoices/models/invoice_item_hive.dart';
import 'package:grad_project/features/invoices/providers/invoice_provider.dart';
import 'package:grad_project/features/van_stock/providers/van_stock_provider.dart';

class InvoiceCreateScreen extends StatefulWidget {
  final VisitHive visit;

  const InvoiceCreateScreen({super.key, required this.visit});

  @override
  State<InvoiceCreateScreen> createState() => _InvoiceCreateScreenState();
}

class _InvoiceCreateScreenState extends State<InvoiceCreateScreen> {
  final List<InvoiceItemHive> _items = [];

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

                // Ask for quantity
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

                Navigator.pop(context); // close bottom sheet
              },
            );
          }).toList(),
        );
      },
    );
  }

  void _saveInvoice() {
    context.read<InvoiceProvider>().addInvoice(
      customerId: widget.visit.customerId,
      visitId: widget.visit.id,
      items: _items,
    );

    Navigator.pop(context);
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
                  trailing: Text(
                    (item.price * item.quantity).toStringAsFixed(2),
                  ),
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
