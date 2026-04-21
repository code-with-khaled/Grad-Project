import 'package:flutter/material.dart';
import 'package:grad_project/providers/customer_provider.dart';
import 'package:grad_project/providers/invoice_provider.dart';
import 'package:grad_project/providers/login_provider.dart';
import 'package:grad_project/providers/route_plan_provider.dart';
import 'package:grad_project/screens/login/login_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        // Add providers here, e.g.:
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => CustomerProvider()),
        ChangeNotifierProvider(create: (_) => InvoiceProvider()),
        ChangeNotifierProvider(create: (_) => RoutePlanProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sales Rep App',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        // Define other routes here
      },
    );
  }
}
