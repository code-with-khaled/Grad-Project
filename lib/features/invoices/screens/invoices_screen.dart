import 'package:flutter/material.dart';
import 'package:grad_project/features/invoices/screens/invoice_details_screen.dart';
import 'package:provider/provider.dart';
import 'package:grad_project/features/invoices/providers/invoice_provider.dart';

class InvoicesScreen extends StatelessWidget {
  const InvoicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final invoices = context.watch<InvoiceProvider>().invoices;

    return Scaffold(
      appBar: AppBar(title: Text("Invoices")),
      body: invoices.isEmpty
          ? Center(
              child: Text("No invoices yet", style: TextStyle(fontSize: 16)),
            )
          : ListView.builder(
              itemCount: invoices.length,
              itemBuilder: (_, i) {
                final invoice = invoices[i];

                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: ListTile(
                    title: Text(
                      "Invoice #${invoice.id}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "Customer: ${invoice.customerId}\n"
                      "Date: ${invoice.date.toLocal()}",
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          invoice.total.toStringAsFixed(2),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        Text("${invoice.items.length} items"),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              InvoiceDetailsScreen(invoice: invoice),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
