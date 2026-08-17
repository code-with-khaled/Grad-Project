import 'package:flutter/material.dart';

class TodayMetricCard extends StatelessWidget {
  const TodayMetricCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "TODAY'S METRICS",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),

              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.circle,
                      color: Colors.deepPurple.shade300,
                      size: 10,
                    ),
                    SizedBox(width: 5),
                    Text(
                      "Live Sync",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.deepPurple.shade300,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Visits Done",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black38,
                    ),
                  ),
                  SizedBox(height: 3),

                  Text(
                    "12 / 17",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 3),

                  Text(
                    "70% complete",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 120,
                child: VerticalDivider(color: Colors.black12, thickness: 1),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Total Sales",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black38,
                    ),
                  ),
                  SizedBox(height: 3),

                  Text(
                    "\$4,320",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 3),

                  Text(
                    "Target: \$5,000",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16),

          Divider(color: Colors.black12, thickness: 1),
          SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Commission: \$86.40",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                "\$113.60 to Tier 2",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black38,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),

          LinearProgressIndicator(
            value: 0.43,
            color: Colors.deepPurple.shade300,
            minHeight: 8,
            borderRadius: BorderRadius.circular(8),
          ),
        ],
      ),
    );
  }
}
