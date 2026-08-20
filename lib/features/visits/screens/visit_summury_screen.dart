import 'dart:async';
import 'package:flutter/material.dart';
import 'package:grad_project/core/services/location_service.dart';
import 'package:grad_project/features/customers/models/customer_hive.dart';
import 'package:grad_project/features/invoices/models/invoice_hive.dart';
import 'package:grad_project/features/invoices/models/invoice_item_hive.dart';
import 'package:grad_project/features/invoices/providers/invoice_provider.dart';
import 'package:grad_project/features/route/models/route_hive.dart';
import 'package:grad_project/features/visits/models/visit_hive.dart';
import 'package:grad_project/features/visits/providers/visit_provider.dart';
import 'package:grad_project/features/invoices/screens/invoice_create_screen.dart';
import 'package:grad_project/features/visits/screens/epod_screen.dart';
import 'package:provider/provider.dart';

class VisitSummaryScreen extends StatefulWidget {
  final CustomerHive customer;
  final int order;
  final VisitHive visit;
  final RouteHive route;

  const VisitSummaryScreen({
    super.key,
    required this.customer,
    required this.order,
    required this.visit,
    required this.route,
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

    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() => _seconds++);
    });

    // Perform check-in
    Future.microtask(() async {
      if (!mounted) return;

      final visitProvider = context.read<VisitProvider>();
      final gps = await LocationService.getCurrentLocation();

      if (!mounted) return;

      await visitProvider.checkIn(
        widget.route.id, // ⭐ routeId from RouteHive
        widget.customer, // ⭐ customer
        gps, // ⭐ current location
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _cancelVisit() {
    context.read<VisitProvider>().cancelVisit();
    Navigator.pop(context);
  }

  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  final dummyInvoices = [
    InvoiceHive(
      id: 1,
      customerId: 1,
      visitId: 1,
      total: 150.0,
      createdAt: DateTime.now(),
      items: [
        InvoiceItemHive(itemId: 1, name: "Item A", quantity: 2, price: 50.0),
        InvoiceItemHive(itemId: 2, name: "Item B", quantity: 1, price: 50.0),
      ],
      synced: false,
    ),
    InvoiceHive(
      id: 2,
      customerId: 1,
      visitId: 1,
      total: 200.0,
      createdAt: DateTime.now(),
      items: [
        InvoiceItemHive(itemId: 3, name: "Item C", quantity: 4, price: 50.0),
      ],
      synced: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerRight,
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade50,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              "Visit In Progress",
              style: TextStyle(
                fontSize: 14,
                color: Colors.deepPurple.shade400,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        leading: IconButton(icon: Icon(Icons.close), onPressed: _cancelVisit),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(18, 18, 18, 480),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.customer.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6),
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 18,
                  color: Colors.grey.shade700,
                ),
                SizedBox(width: 6),

                Expanded(
                  child: Text(
                    widget.customer.address,
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),

            Container(
              padding: EdgeInsets.symmetric(vertical: 16),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.fiber_manual_record,
                        size: 12,
                        color: Colors.red,
                      ),
                      SizedBox(width: 5),
                      Text(
                        "Live Visit Active",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.timer, size: 28),
                      SizedBox(width: 8),
                      Text(
                        _formatTime(_seconds),
                        style: TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),

                  Text(
                    "Started at ${widget.visit.startTime.toLocal().toString().substring(11, 19)}",
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),

            SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Invoices",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                    fontSize: 18,
                  ),
                ),

                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            InvoiceCreateScreen(visit: widget.visit),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.receipt_long_outlined,
                        color: Colors.deepPurple.shade400,
                        size: 22,
                      ),
                      SizedBox(width: 5),

                      Text(
                        "Add Invoice",
                        style: TextStyle(
                          color: Colors.deepPurple.shade400,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Consumer<InvoiceProvider>(
              builder: (context, provider, _) {
                final invoices = provider.getInvoicesForVisit(widget.visit.id);

                if (invoices.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: Center(
                      child: Text(
                        "No invoices created yet.",
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ),
                  );
                }

                return Column(
                  children: invoices.map((invoice) {
                    return Container(
                      margin: const EdgeInsets.only(top: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Invoice #${invoice.id}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: Colors.green.shade50,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Icon(
                                        Icons.edit,
                                        size: 16,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12),

                                  GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: Colors.red.shade50,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Icon(
                                        Icons.delete_forever_outlined,
                                        size: 16,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          SizedBox(height: 6),

                          Text(
                            "Total: ${invoice.total.toStringAsFixed(2)}",
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 15,
                            ),
                          ),

                          SizedBox(height: 6),

                          Text(
                            "Created: ${invoice.createdAt.toLocal().toString().substring(0, 16)}",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),

                          SizedBox(height: 12),

                          // Items preview
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: invoice.items.map((item) {
                              return Text(
                                "• ${item.name} — ${item.quantity} × ${item.price}",
                                style: TextStyle(fontSize: 14),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 24),
        child: SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EPODScreen(visit: widget.visit),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              "Finish Visit & Resume",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
