import 'package:flutter/material.dart';
import 'package:grad_project/models/customer.dart';
import 'package:grad_project/providers/visit_provider.dart';
import 'package:grad_project/screens/main%20screens/visits/visit_summury_screen.dart';
import 'package:provider/provider.dart';

class CutomerCard extends StatelessWidget {
  final Customer c;
  final int order;

  const CutomerCard({super.key, required this.c, required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        title: Text(c.name),
        subtitle: Text(c.address),
        trailing: c.visited
            ? Icon(Icons.check_circle, color: Colors.green)
            : null,
        onTap: () {
          if (c.visited) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("Customer already visited")));
            return;
          }

          final visitProvider = context.read<VisitProvider>();
          visitProvider.startVisitOffline(c);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => VisitSummaryScreen(
                customer: c,
                visit: visitProvider.currentVisit!,
                order: order + 1,
              ),
            ),
          );
        },
      ),
    );
  }
}
