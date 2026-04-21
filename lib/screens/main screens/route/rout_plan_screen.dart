import 'package:flutter/material.dart';

class RoutePlanScreen extends StatelessWidget {
  const RoutePlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Today's Route")),
      body: Center(child: Text("Route plan will appear here")),
    );
  }
}
