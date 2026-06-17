import 'package:flutter/material.dart';
import 'package:grad_project/features/invoices/providers/invoice_provider.dart';
import 'package:provider/provider.dart';

// Simple screen to show visit data after finishing (for demo purposes)
class VisitCompletedScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  const VisitCompletedScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final visitId = data["visitId"];
    final invoices = context.watch<InvoiceProvider>().getInvoicesForVisit(
      visitId,
    );

    return Scaffold(
      appBar: AppBar(title: Text("Visit Completed")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            ...data.entries.map((e) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Text("${e.key}: ${e.value}"),
              );
            }),

            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 10),

            Text(
              "Invoices",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            if (invoices.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text("No invoices created."),
              ),

            ...invoices.map((invoice) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Invoice ID: ${invoice.id}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),

                      Text("Date: ${invoice.date}"),

                      const SizedBox(height: 10),
                      Text(
                        "Items:",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),

                      ...invoice.items.map((item) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            "- ${item.name} | ${item.quantity} × ${item.price} = ${item.total.toStringAsFixed(2)}",
                          ),
                        );
                      }),

                      const SizedBox(height: 10),
                      Text(
                        "Total: ${invoice.total.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
