import 'package:flutter/material.dart';
import 'package:grad_project/screens/main%20screens/customers/customer_details_screen.dart';
import 'package:provider/provider.dart';
import '../../../providers/customer_provider.dart';

class CustomerListScreen extends StatefulWidget {
  const CustomerListScreen({super.key});

  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context.read<CustomerProvider>().loadCustomers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CustomerProvider>();

    return Scaffold(
      appBar: AppBar(title: Text('Customers')),
      body: provider.isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: provider.customers.length,
              itemBuilder: (context, index) {
                final customer = provider.customers[index];
                return ListTile(
                  onTap: () {
                    // Navigate to details screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CustomerDetailsScreen(customer: customer),
                      ),
                    );
                  },
                  title: Text(customer.name),
                  subtitle: Text(customer.address),
                  trailing: Text(customer.phone),
                );
              },
            ),
    );
  }
}
