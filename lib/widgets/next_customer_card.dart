import 'package:flutter/material.dart';
import 'package:grad_project/models/customer.dart';

class NextCustomerCard extends StatelessWidget {
  final Customer customer;
  final int order;
  final VoidCallback onNavigate;
  final VoidCallback onStartVisit;

  const NextCustomerCard({
    super.key,
    required this.customer,
    required this.order,
    required this.onNavigate,
    required this.onStartVisit,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Next Customer",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Text(
              "$order. ${customer.name}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.location_on_outlined, size: 18),
                SizedBox(width: 6),
                Expanded(child: Text(customer.address)),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: Icon(Icons.directions),
                    label: Text("Navigate"),
                    onPressed: onNavigate,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onStartVisit,
                    child: Text("Start Visit"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
