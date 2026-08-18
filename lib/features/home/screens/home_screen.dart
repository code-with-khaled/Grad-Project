// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grad_project/features/home/widgets/today_metric_card.dart';
import 'package:provider/provider.dart';
import 'package:grad_project/features/auth/providers/auth_provider.dart';
import 'package:grad_project/features/customers/providers/customer_provider.dart';
import 'package:grad_project/features/van_stock/providers/van_stock_provider.dart';
import 'package:grad_project/features/workday/providers/workday_provider.dart';
import 'package:grad_project/features/gps/data/gps_background_service.dart';
import 'package:grad_project/features/gps/data/gps_repository.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final workdayProvider = context.watch<WorkdayProvider>();
    final customerProvider = context.read<CustomerProvider>();
    final vanStockProvider = context.read<VanStockProvider>();
    final repId = auth.user?.id ?? 1;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          flexibleSpace: Container(
            padding: EdgeInsets.only(left: 24, right: 24, bottom: 10),
            alignment: Alignment.bottomLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Good morning, ${auth.user?.name ?? "Rep"}",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      "Thursday, Oct 12 • Central Route",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),

                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.notifications_active_outlined,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------------------------
            // TODAY’S METRICS SECTION
            // ---------------------------
            TodayMetricCard(),

            const SizedBox(height: 24),

            // Motivational message
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade50,
                borderRadius: BorderRadius.circular(6),
              ),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: 15, color: Colors.black),
                  children: [
                    TextSpan(text: "Keep going! Only "),
                    TextSpan(
                      text: "\$5,680",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text:
                          " left to hit your daily \$10K commission target 💪🏻",
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ---------------------------
            // ACTION BUTTONS
            // ---------------------------
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(
                  Icons.play_arrow_outlined,
                  color: Colors.white,
                  size: 22,
                ),
                label: Text(
                  "Start Today's Plan",
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple.shade400,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(
                  Icons.exit_to_app_outlined,
                  color: Colors.grey.shade700,
                  size: 22,
                ),
                label: Text(
                  "Finish Day & Clear Stock",
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            // _primaryButton(
            //   label: "Start Workday",
            //   icon: null,
            //   color: Colors.blue,
            //   onPressed: workdayProvider.isWorkdayActive
            //       ? null
            //       : () {
            //           workdayProvider.startWorkday();
            //         },
            // ),

            // const SizedBox(height: 12),

            // _primaryButton(
            //   label: "Start Foreground GPS Test",
            //   icon: Icons.play_arrow,
            //   color: Colors.deepPurple,
            //   onPressed: () {
            //     final gpsService = context.read<GpsBackgroundService>();
            //     gpsService.startForegroundTest();
            //   },
            // ),

            // const SizedBox(height: 12),

            // _primaryButton(
            //   label: "Stop Foreground GPS Test",
            //   icon: Icons.play_arrow,
            //   color: Colors.deepPurple,
            //   onPressed: () {
            //     final gpsService = context.read<GpsBackgroundService>();
            //     gpsService.stopForegroundTest();
            //   },
            // ),

            // const SizedBox(height: 12),

            // _primaryButton(
            //   label: "Load Today's Plan",
            //   icon: Icons.play_arrow,
            //   color: Colors.deepPurple,
            //   onPressed: () async {
            //     await customerProvider.loadCustomers();
            //     final success = await vanStockProvider.loadVanStock(repId);

            //     if (!context.mounted) return;

            //     final message = success
            //         ? "Van stock loaded successfully!"
            //         : "Failed to load van stock";

            //     final color = success ? Colors.green : Colors.red;

            //     ScaffoldMessenger.of(context).showSnackBar(
            //       SnackBar(content: Text(message), backgroundColor: color),
            //     );
            //   },
            // ),

            // const SizedBox(height: 12),

            // _primaryButton(
            //   label: "Load Today's Plan",
            //   icon: Icons.play_arrow,
            //   color: Colors.deepPurple,
            //   onPressed: () {
            //     final gpsRepo = context.read<GpsRepository>();
            //     final points = gpsRepo.getUnsyncedPoints();

            //     print("---- GPS POINTS IN HIVE ----");
            //     for (final p in points) {
            //       print("${p.lat}, ${p.lng} at ${p.timestamp}");
            //     }
            //   },
            // ),

            // const SizedBox(height: 12),

            // _primaryButton(
            //   label: "Finish Day & Clear Stock",
            //   icon: Icons.check_circle,
            //   color: Colors.redAccent,
            //   onPressed: () {
            //     workdayProvider.endWorkday();
            //     customerProvider.resetCustomers();
            //     vanStockProvider.resetStock();
            //   },
            // ),
            const SizedBox(height: 24),

            // ---------------------------
            // SUMMARY BOXES
            // ---------------------------
            Row(
              children: [
                Expanded(
                  child: _summaryBox(
                    title: "Route",
                    value: "66% Done",
                    icon: Icons.route,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _summaryBox(
                    title: "Avg Order",
                    value: "\$360.00",
                    icon: Icons.shopping_cart,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _summaryBox(
                    title: "Ranking",
                    value: "#3 of 12",
                    icon: Icons.leaderboard,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // ---------------------------
            // RECENT ACTIVITY
            // ---------------------------
            Text(
              "RECENT ACTIVITY",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 12),

            _activityItem(
              title: "Delivered to Al-Noor Market",
              subtitle: "\$340.00 · Cash Payment",
              time: "10 mins ago",
              icon: Icons.local_shipping,
            ),

            _activityItem(
              title: "Vanstock synced successfully",
              subtitle: "42 SKU items updated",
              time: "45 mins ago",
              icon: Icons.sync,
            ),

            _activityItem(
              title: "Visit skipped: Super Price Mart",
              subtitle: "Store closed temporarily",
              time: "2 hrs ago",
              icon: Icons.warning_amber,
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------
  // WIDGET HELPERS
  // ---------------------------

  Widget _primaryButton({
    required String label,
    required IconData? icon,
    required Color color,
    bool disabled = false,
    required VoidCallback? onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton.icon(
        onPressed: disabled ? null : onPressed,
        icon: Icon(icon),
        label: Text(label, style: const TextStyle(fontSize: 16)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          disabledBackgroundColor: Colors.grey.shade400,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _summaryBox({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.deepPurple),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _activityItem({
    required String title,
    required String subtitle,
    required String time,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.deepPurple, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: const TextStyle(fontSize: 12, color: Colors.black45),
          ),
        ],
      ),
    );
  }
}
