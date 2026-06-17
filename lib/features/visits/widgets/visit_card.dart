import 'package:flutter/material.dart';
import 'package:grad_project/features/visits/models/visit_model.dart';

class VisitCard extends StatelessWidget {
  final Visit visit;

  const VisitCard({super.key, required this.visit});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: ListTile(
        title: Text("Customer: ${visit.customerId}"),
        subtitle: Text(
          "Status: ${visit.status}\n"
          "Start: ${visit.startTime}",
        ),
        trailing: Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
