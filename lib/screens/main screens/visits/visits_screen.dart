import 'package:flutter/material.dart';

class VisitsScreen extends StatelessWidget {
  const VisitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Visits")),
      body: Center(child: Text("Visit history will appear here")),
    );
  }
}
