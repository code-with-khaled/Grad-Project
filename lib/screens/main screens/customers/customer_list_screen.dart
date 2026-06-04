import 'package:flutter/material.dart';
import 'package:grad_project/providers/customer_provider.dart';
import 'package:grad_project/providers/visit_provider.dart';
import 'package:grad_project/screens/main%20screens/visits/visit_summury_screen.dart';
import 'package:provider/provider.dart';

class CustomerListScreen extends StatelessWidget {
  const CustomerListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final customerProvider = context.watch<CustomerProvider>();
    final customers = customerProvider.customers;

    return Scaffold(
      appBar: AppBar(title: Text("Customers")),
      body: customerProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : customers.isEmpty
          ? Center(child: Text("No customers available"))
          : ListView.builder(
              itemCount: customers.length,
              itemBuilder: (_, i) {
                final c = customers[i];

                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(c.name),
                    subtitle: Text(c.address),
                    trailing: c.visited
                        ? Icon(Icons.check_circle, color: Colors.green)
                        : null,
                    onTap: () {
                      final visitProvider = context.read<VisitProvider>();
                      final visit = visitProvider.startVisitOffline(c);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => VisitSummaryScreen(
                            customer: c,
                            visit: visit,
                            order: i + 1,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
