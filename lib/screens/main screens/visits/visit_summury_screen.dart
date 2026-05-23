import 'dart:async';
import 'package:flutter/material.dart';
import 'package:grad_project/models/customer.dart';
import 'package:grad_project/providers/visit_provider.dart';
import 'package:grad_project/services/location_service.dart';
import 'package:provider/provider.dart';

class VisitSummaryScreen extends StatefulWidget {
  final Customer customer;
  final int order;

  const VisitSummaryScreen({
    super.key,
    required this.customer,
    required this.order,
  });

  @override
  State<VisitSummaryScreen> createState() => _VisitSummaryScreenState();
}

class _VisitSummaryScreenState extends State<VisitSummaryScreen> {
  late Timer _timer;
  int _seconds = 0;

  @override
  void initState() {
    super.initState();

    // Start timer immediately
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() => _seconds++);
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // stop timer when leaving screen
    super.dispose();
  }

  void _cancelVisit() {
    context.read<VisitProvider>().cancelVisit();
    Navigator.pop(context); // go back to map
  }

  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Visit In Progress"),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: _cancelVisit, // cancel instead of back
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.customer.name,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6),
            Text("Visit Order: ${widget.order}"),

            SizedBox(height: 20),

            // Timer
            Row(
              children: [
                Icon(Icons.timer, size: 28),
                SizedBox(width: 8),
                Text(
                  _formatTime(_seconds),
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            SizedBox(height: 30),

            Text(
              "Notes (coming soon)",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),

            Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final visitProvider = context.read<VisitProvider>();
                  final navigator = Navigator.of(context);

                  final gps = await LocationService.getCurrentLocation();

                  visitProvider.finishVisit(gps);
                  final data = visitProvider.visitData;

                  navigator.push(
                    MaterialPageRoute(
                      builder: (_) => VisitCompletedScreen(data: data),
                    ),
                  );
                },
                child: Text("Finish Visit"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Simple screen to show visit data after finishing (for demo purposes)
class VisitCompletedScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  const VisitCompletedScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Visit Completed")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: data.entries.map((e) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Text("${e.key}: ${e.value}"),
            );
          }).toList(),
        ),
      ),
    );
  }
}
