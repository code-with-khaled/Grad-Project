import 'package:flutter/material.dart';
import 'package:grad_project/providers/customer_provider.dart';
import 'package:grad_project/widgets/customer_card.dart';
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

                return CutomerCard(c: c, order: i);
              },
            ),
    );
  }
}
