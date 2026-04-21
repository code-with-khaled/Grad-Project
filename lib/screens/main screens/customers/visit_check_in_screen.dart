import 'package:flutter/material.dart';
import 'package:grad_project/screens/main%20screens/customers/visit_summary_screen.dart';
import '../../../models/customer.dart';

class VisitCheckInScreen extends StatelessWidget {
  final Customer customer;

  const VisitCheckInScreen({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Visit Check-In")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Customer info
            Text(
              customer.name,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6),
            Text(customer.address),
            SizedBox(height: 6),
            Text("Phone: ${customer.phone}"),

            SizedBox(height: 20),

            // Map placeholder
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  "Map Placeholder\n(GPS mock)",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ),
            ),

            SizedBox(height: 30),

            Text(
              "Current Location (Mock):",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 6),
            Text("Lat: 33.5138, Lng: 36.2765"),

            Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => VisitSummaryScreen(customer: customer),
                    ),
                  );
                },
                child: Text("Check In"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
