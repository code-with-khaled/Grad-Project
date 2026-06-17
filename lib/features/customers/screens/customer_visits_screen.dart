import 'package:flutter/material.dart';
import 'package:grad_project/features/visits/widgets/visit_card.dart';
import 'package:provider/provider.dart';
import 'package:grad_project/features/visits/providers/visit_provider.dart';
import 'package:grad_project/features/visits/models/visit_model.dart';

class CustomerVisitsScreen extends StatelessWidget {
  final String customerId;
  final String customerName;

  const CustomerVisitsScreen({
    super.key,
    required this.customerId,
    required this.customerName,
  });

  @override
  Widget build(BuildContext context) {
    final visits = context.watch<VisitProvider>().getVisitsForCustomer(
      customerId,
    );

    return Scaffold(
      appBar: AppBar(title: Text("$customerName Visits")),
      body: visits.isEmpty
          ? Center(
              child: Text(
                "No visits for this customer",
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: visits.length,
              itemBuilder: (_, i) {
                final Visit v = visits[i];

                return VisitCard(visit: v);
              },
            ),
    );
  }
}
