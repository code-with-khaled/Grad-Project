import 'package:flutter/material.dart';
import 'package:grad_project/features/customers/models/customer_hive.dart';
import 'package:grad_project/features/route/providers/route_provider.dart';
import 'package:provider/provider.dart';

class NextCustomerCard extends StatelessWidget {
  final CustomerHive customer;
  final int order;
  final VoidCallback onNavigate;
  final VoidCallback onStartVisit;
  final void Function(CustomerHive) onSelectNextCustomer;

  const NextCustomerCard({
    super.key,
    required this.customer,
    required this.order,
    required this.onNavigate,
    required this.onStartVisit,
    required this.onSelectNextCustomer,
  });

  @override
  Widget build(BuildContext context) {
    final customers = Provider.of<RouteProvider>(context).routeCustomers;

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.route_outlined,
                      color: Colors.deepPurple.shade400,
                      size: 18,
                    ),
                    SizedBox(width: 6),

                    Text(
                      "Next Customer",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.deepPurple.shade400,
                      ),
                    ),
                  ],
                ),

                PopupMenuButton<CustomerHive>(
                  icon: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.swap_horiz, color: Colors.grey.shade700),
                  ),
                  onSelected: (c) => onSelectNextCustomer(c),
                  itemBuilder: (context) {
                    return customers.map((c) {
                      return PopupMenuItem(value: c, child: Text(c.name));
                    }).toList();
                  },
                ),
              ],
            ),

            if (customer.visited)
              Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 18),
                  SizedBox(width: 6),
                  Text(
                    "Already visited",
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            SizedBox(height: 8),

            Text(
              "$order. ${customer.name}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),

            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 18,
                  color: Colors.grey.shade700,
                ),
                SizedBox(width: 6),

                Expanded(
                  child: Text(
                    customer.address,
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 55,
                      child: OutlinedButton.icon(
                        onPressed: onNavigate,
                        icon: Icon(
                          Icons.directions,
                          color: Colors.grey.shade700,
                          size: 22,
                        ),
                        label: Text(
                          "Navigate",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.grey.shade100,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (!customer.visited) ...[
                    SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 55,
                        child: ElevatedButton.icon(
                          onPressed: onStartVisit,
                          icon: Icon(
                            Icons.play_arrow_outlined,
                            color: Colors.white,
                            size: 22,
                          ),
                          label: Text(
                            "Start Visit",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple.shade400,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
