import 'package:flutter/material.dart';
import 'package:grad_project/models/customer.dart';
import 'package:grad_project/providers/visit_provider.dart';
import 'package:grad_project/screens/main screens/visits/visit_summury_screen.dart';
import 'package:grad_project/screens/main%20screens/customers/customer_visits_screen.dart';
import 'package:provider/provider.dart';

class CustomerCard extends StatefulWidget {
  final Customer c;
  final int order;

  const CustomerCard({super.key, required this.c, required this.order});

  @override
  State<CustomerCard> createState() => _CustomerCardState();
}

class _CustomerCardState extends State<CustomerCard> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final c = widget.c;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Column(
        children: [
          ListTile(
            title: Text(c.name),
            subtitle: Text(c.address),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (c.visited) Icon(Icons.check_circle, color: Colors.green),
                IconButton(
                  icon: Icon(expanded ? Icons.expand_less : Icons.expand_more),
                  onPressed: () {
                    setState(() => expanded = !expanded);
                  },
                ),
              ],
            ),
          ),

          if (expanded) Divider(),

          if (expanded)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // FULL CUSTOMER INFO
                  Text("Phone: ${c.phone}"),
                  SizedBox(height: 6),
                  Text("Address: ${c.address}"),
                  SizedBox(height: 6),
                  Text("Last Visit: ${c.visited ? "Visited" : "No visits"}"),

                  SizedBox(height: 16),

                  // BUTTONS
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CustomerVisitsScreen(
                                  customerId: c.id,
                                  customerName: c.name,
                                ),
                              ),
                            );
                          },
                          child: Text("Visit History"),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            final visitProvider = context.read<VisitProvider>();

                            visitProvider.startVisitOffline(c);

                            if (c.visited) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "This customer has already been visited today.",
                                  ),
                                ),
                              );
                              return;
                            }

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => VisitSummaryScreen(
                                  customer: c,
                                  visit: visitProvider.currentVisit!,
                                  order: widget.order + 1,
                                ),
                              ),
                            );
                          },
                          child: Text("Start Visit"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
