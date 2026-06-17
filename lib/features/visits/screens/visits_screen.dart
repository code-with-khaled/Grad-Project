import 'package:flutter/material.dart';
import 'package:grad_project/features/visits/widgets/visit_card.dart';
import 'package:provider/provider.dart';
import 'package:grad_project/features/visits/providers/visit_provider.dart';

class VisitsScreen extends StatelessWidget {
  const VisitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final visitProvider = context.watch<VisitProvider>();
    final visits = visitProvider.allVisits;

    return Scaffold(
      appBar: AppBar(title: Text("Visits")),
      body: visits.isEmpty
          ? Center(child: Text("No visits yet"))
          : ListView.builder(
              itemCount: visits.length,
              itemBuilder: (context, index) {
                final v = visits[index];

                return VisitCard(visit: v);
              },
            ),
    );
  }
}
