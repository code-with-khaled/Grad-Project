import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/customer.dart';
import '../../../providers/invoice_provider.dart';

class InvoiceSummaryScreen extends StatefulWidget {
  final Customer customer;

  const InvoiceSummaryScreen({super.key, required this.customer});

  @override
  State<InvoiceSummaryScreen> createState() => _InvoiceSummaryScreenState();
}

class _InvoiceSummaryScreenState extends State<InvoiceSummaryScreen> {
  @override
  Widget build(BuildContext context) {
    final invoiceProvider = context.watch<InvoiceProvider>();

    return Scaffold(
      appBar: AppBar(title: Text("Invoice Summary")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              widget.customer.name,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: invoiceProvider.items.length,
                itemBuilder: (context, index) {
                  final item = invoiceProvider.items[index];
                  return ListTile(
                    title: Text(item.productName),
                    subtitle: Text("Qty: ${item.quantity} × ${item.price}"),
                    trailing: Text(item.total.toStringAsFixed(2)),
                  );
                },
              ),
            ),

            Divider(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total:", style: TextStyle(fontSize: 18)),
                Text(
                  invoiceProvider.total.toStringAsFixed(2),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final invoice = invoiceProvider.generateInvoice(
                    widget.customer.id,
                  );

                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text("Invoice Created"),
                      content: Text("Invoice #${invoice.id} saved (mock)."),
                      actions: [
                        TextButton(
                          onPressed: () {
                            invoiceProvider.clear();
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: Text("OK"),
                        ),
                      ],
                    ),
                  );
                },
                child: Text("Confirm Invoice"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
