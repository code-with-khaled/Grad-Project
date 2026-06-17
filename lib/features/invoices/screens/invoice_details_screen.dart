import 'package:flutter/material.dart';
import 'package:grad_project/features/invoices/models/invoice.dart';

class InvoiceDetailsScreen extends StatelessWidget {
  final Invoice invoice;

  const InvoiceDetailsScreen({super.key, required this.invoice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Invoice Details")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(
              "Invoice ID: ${invoice.id}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6),
            Text("Customer: ${invoice.customerId}"),
            Text("Date: ${invoice.date.toLocal()}"),

            SizedBox(height: 20),
            Divider(),
            SizedBox(height: 10),

            Text(
              "Items",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            ...invoice.items.map((item) {
              return ListTile(
                title: Text(item.name),
                subtitle: Text("${item.quantity} × ${item.price}"),
                trailing: Text(
                  item.total.toStringAsFixed(2),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              );
            }),

            Divider(),
            SizedBox(height: 10),

            Text(
              "Total: ${invoice.total.toStringAsFixed(2)}",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
