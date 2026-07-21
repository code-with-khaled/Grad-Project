import 'package:flutter/material.dart';
import 'package:grad_project/features/customers/providers/customer_provider.dart';
import 'package:grad_project/features/van_stock/providers/van_stock_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final customerProvider = context.read<CustomerProvider>();
    final vanStockProvider = context.read<VanStockProvider>();

    return Scaffold(
      appBar: AppBar(title: Text("Home")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                customerProvider.loadCustomers();
                vanStockProvider.loadVanStock();
              },
              child: Text("Load Today's Plan"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                customerProvider.resetCustomers();
                vanStockProvider.resetStock();
              },
              child: Text("End Day / Reset"),
            ),
          ],
        ),
      ),
    );
  }
}
