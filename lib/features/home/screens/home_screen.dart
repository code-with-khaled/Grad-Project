// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:grad_project/features/customers/providers/customer_provider.dart';
import 'package:grad_project/features/gps/data/gps_background_service.dart';
import 'package:grad_project/features/gps/data/gps_repository.dart';
import 'package:grad_project/features/van_stock/providers/van_stock_provider.dart';
import 'package:grad_project/features/workday/providers/workday_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final customerProvider = context.read<CustomerProvider>();
    final vanStockProvider = context.read<VanStockProvider>();
    final workdayProvider = context.watch<WorkdayProvider>();

    return Scaffold(
      appBar: AppBar(title: Text("Home")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: workdayProvider.isWorkdayActive
                  ? null
                  : () {
                      workdayProvider.startWorkday();
                    },
              child: Text("Start Workday"),
            ),

            ElevatedButton(
              onPressed: () {
                final gpsService = context.read<GpsBackgroundService>();
                gpsService.startForegroundTest();
              },
              child: Text("Start Foreground GPS Test"),
            ),

            ElevatedButton(
              onPressed: () {
                final gpsService = context.read<GpsBackgroundService>();
                gpsService.stopForegroundTest();
              },
              child: Text("Stop Foreground GPS Test"),
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                customerProvider.loadCustomers();
                vanStockProvider.loadVanStock();
              },
              child: Text("Load Today's Plan"),
            ),

            ElevatedButton(
              onPressed: () {
                workdayProvider.endWorkday();
                customerProvider.resetCustomers();
                vanStockProvider.resetStock();
              },
              child: Text("End Day / Reset"),
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                final gpsRepo = context.read<GpsRepository>();
                final points = gpsRepo.getUnsyncedPoints();

                print("---- GPS POINTS IN HIVE ----");
                for (final p in points) {
                  print("${p.lat}, ${p.lng} at ${p.timestamp}");
                }
              },
              child: Text("Print GPS Points"),
            ),
          ],
        ),
      ),
    );
  }
}
