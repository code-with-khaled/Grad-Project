import 'package:flutter/material.dart';

class RouteCompletedBanner extends StatelessWidget {
  const RouteCompletedBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.green.shade300),
        ),
        child: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                "Route completed. All scheduled customers have been visited.\nTap any customer marker to navigate again.",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
