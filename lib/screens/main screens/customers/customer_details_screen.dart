import 'package:flutter/material.dart';
import 'package:grad_project/screens/main%20screens/customers/visit_check_in_screen.dart';
import '../../../models/customer.dart';

class CustomerDetailsScreen extends StatelessWidget {
  final Customer customer;

  const CustomerDetailsScreen({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(customer.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              customer.name,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),

            Row(
              children: [
                Icon(Icons.location_on_outlined),
                SizedBox(width: 8),
                Expanded(child: Text(customer.address)),
              ],
            ),

            SizedBox(height: 12),

            Row(
              children: [
                Icon(Icons.phone),
                SizedBox(width: 8),
                Text(customer.phone),
              ],
            ),

            SizedBox(height: 20),

            Divider(),

            SizedBox(height: 20),

            Text(
              "Last Visit:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 6),
            Text("No visits yet (mock data)"),

            Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => VisitCheckInScreen(customer: customer),
                    ),
                  );
                },
                child: Text("Start Visit"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
