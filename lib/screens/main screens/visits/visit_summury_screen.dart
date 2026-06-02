import 'dart:async';
import 'package:flutter/material.dart';
import 'package:grad_project/models/customer.dart';
import 'package:grad_project/models/visit_model.dart';
import 'package:grad_project/providers/customer_provider.dart';
import 'package:grad_project/providers/invoice_provider.dart';
import 'package:grad_project/providers/visit_provider.dart';
import 'package:grad_project/screens/main%20screens/invoices/invoice_create_screen.dart';
import 'package:grad_project/services/location_service.dart';
import 'package:provider/provider.dart';

class VisitSummaryScreen extends StatefulWidget {
  final Customer customer;
  final int order;
  final Visit visit;

  const VisitSummaryScreen({
    super.key,
    required this.customer,
    required this.order,
    required this.visit,
  });

  @override
  State<VisitSummaryScreen> createState() => _VisitSummaryScreenState();
}

class _VisitSummaryScreenState extends State<VisitSummaryScreen> {
  late Timer _timer;
  int _seconds = 0;

  @override
  void initState() {
    super.initState();

    // Start timer immediately
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() => _seconds++);
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // stop timer when leaving screen
    super.dispose();
  }

  void _cancelVisit() {
    context.read<VisitProvider>().cancelVisit();
    Navigator.pop(context); // go back to map
  }

  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Visit In Progress"),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: _cancelVisit, // cancel instead of back
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.customer.name,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6),
            Text("Visit Order: ${widget.order}"),

            SizedBox(height: 20),

            // Timer
            Row(
              children: [
                Icon(Icons.timer, size: 28),
                SizedBox(width: 8),
                Text(
                  _formatTime(_seconds),
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            SizedBox(height: 30),

            Text(
              "Notes (coming soon)",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),

            ElevatedButton(
              child: Text("Create Invoice"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => InvoiceCreateScreen(visit: widget.visit),
                  ),
                );
              },
            ),

            Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final visitProvider = context.read<VisitProvider>();
                  final customerProvider = context.read<CustomerProvider>();
                  final navigator = Navigator.of(context);

                  final gps = await LocationService.getCurrentLocation();

                  visitProvider.finishVisit(gps, customerProvider);

                  final data = visitProvider.visitData;

                  navigator.push(
                    MaterialPageRoute(
                      builder: (_) => VisitCompletedScreen(data: data),
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
