import 'package:flutter/material.dart';
import 'package:grad_project/screens/main%20screens/customers/invoice_summary_screen.dart';
import '../../../models/customer.dart';

class VisitSummaryScreen extends StatefulWidget {
  final Customer customer;

  const VisitSummaryScreen({super.key, required this.customer});

  @override
  State<VisitSummaryScreen> createState() => _VisitSummaryScreenState();
}

class _VisitSummaryScreenState extends State<VisitSummaryScreen> {
  final TextEditingController notesController = TextEditingController();
  final List<String> mockOrderItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Visit Summary")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Customer info
            Text(
              widget.customer.name,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6),
            Text(widget.customer.address),
            SizedBox(height: 6),
            Text("Phone: ${widget.customer.phone}"),

            SizedBox(height: 20),
            Divider(),

            // Notes
            Text(
              "Visit Notes",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            TextField(
              controller: notesController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Write visit notes...",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 20),

            // Order items (mock)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Order Items (Mock)",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      mockOrderItems.add("Item ${mockOrderItems.length + 1}");
                    });
                  },
                  child: Text("Add Item"),
                ),
              ],
            ),

            Expanded(
              child: ListView.builder(
                itemCount: mockOrderItems.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(mockOrderItems[index]),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          mockOrderItems.removeAt(index);
                        });
                      },
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 10),

            // Finish button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          InvoiceSummaryScreen(customer: widget.customer),
                    ),
                  );
                },
                child: Text("Finish Visit"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
