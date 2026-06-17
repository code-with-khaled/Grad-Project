import 'dart:async';
import 'package:flutter/material.dart';
import 'package:grad_project/features/customers/models/customer.dart';
import 'package:grad_project/features/visits/models/visit_model.dart';
import 'package:grad_project/features/customers/providers/customer_provider.dart';
import 'package:grad_project/features/visits/providers/visit_provider.dart';
import 'package:grad_project/features/invoices/screens/invoice_create_screen.dart';
import 'package:grad_project/features/visits/screens/visit_completed_screen.dart';
import 'package:grad_project/core/services/location_service.dart';
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

                  navigator.pushReplacement(
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
