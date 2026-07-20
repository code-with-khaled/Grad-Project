import 'package:flutter/material.dart';
import 'package:grad_project/core/services/location_service.dart';
import 'package:grad_project/core/storage/hive_boxes.dart';
import 'package:grad_project/features/auth/services/auth_service.dart';
import 'package:grad_project/features/customers/models/customer_hive.dart';
import 'package:grad_project/features/customers/providers/customer_provider.dart';
import 'package:grad_project/features/invoices/models/invoice_hive.dart';
import 'package:grad_project/features/invoices/models/invoice_item_hive.dart';
import 'package:grad_project/features/invoices/providers/invoice_provider.dart';
import 'package:grad_project/features/auth/providers/auth_provider.dart';
import 'package:grad_project/features/route/providers/route_plan_provider.dart';
import 'package:grad_project/features/route/providers/user_location_provider.dart';
import 'package:grad_project/features/van_stock/models/van_stock_hive.dart';
import 'package:grad_project/features/van_stock/providers/van_stock_provider.dart';
import 'package:grad_project/features/visits/providers/visit_provider.dart';
import 'package:grad_project/features/auth/screens/login_screen.dart';
import 'package:grad_project/features/route/screens/rout_plan_screen.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(CustomerHiveAdapter());
  Hive.registerAdapter(VanStockHiveAdapter());
  Hive.registerAdapter(InvoiceHiveAdapter());
  Hive.registerAdapter(InvoiceItemHiveAdapter());

  await Hive.openBox(HiveBoxes.authBox);
  await Hive.openBox<CustomerHive>(HiveBoxes.customers);
  await Hive.openBox<VanStockHive>(HiveBoxes.vanStock);
  await Hive.openBox<InvoiceHive>(HiveBoxes.invoices);
  await Hive.openBox(HiveBoxes.visits);
  await Hive.openBox(HiveBoxes.epod);

  runApp(
    MultiProvider(
      providers: [
        // Add providers here, e.g.:
        ChangeNotifierProvider(
          create: (_) => AuthProvider(authService: AuthService()),
        ),
        ChangeNotifierProvider(create: (_) => VanStockProvider()),
        ChangeNotifierProvider(create: (_) => CustomerProvider()),
        ChangeNotifierProvider(create: (_) => InvoiceProvider()),
        ChangeNotifierProvider(create: (_) => RoutePlanProvider()),
        ChangeNotifierProvider(
          create: (_) => VisitProvider(locationService: LocationService()),
        ),
        ChangeNotifierProvider(create: (_) => UserLocationProvider()),
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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/map': (context) => const RoutePlanScreen(),
        // Define other routes here
      },
    );
  }
}
