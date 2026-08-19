import 'package:flutter/material.dart';
import 'package:grad_project/features/van_stock/models/van_stock_hive.dart';

class VanItemCard extends StatelessWidget {
  final VanStockHive item;
  final VoidCallback onTap;

  const VanItemCard({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isOut = item.quantity <= 0;

    return Opacity(
      opacity: isOut ? 0.4 : 1.0,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: BoxBorder.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Row(
                  children: [
                    Text(
                      "SKU: ${item.sku}",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: SizedBox(height: 10, child: VerticalDivider()),
                    ),

                    Icon(
                      Icons.fiber_manual_record,
                      size: 8,
                      color: Colors.green,
                    ),
                    SizedBox(width: 4),

                    Text(
                      isOut ? "Out of stock" : "${item.quantity} in van",
                      style: TextStyle(
                        color: isOut ? Colors.red : Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Text(
              "\$${item.price}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap: onTap,
              child: Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.add_circle_outline,
                  color: Colors.deepPurple.shade400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
