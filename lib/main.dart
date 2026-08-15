import 'package:flutter/material.dart';
import 'package:grad_project/core/network/api_client.dart';
import 'package:grad_project/core/services/location_service.dart';
import 'package:grad_project/core/storage/hive_boxes.dart';
import 'package:grad_project/core/storage/token_storage.dart';
import 'package:grad_project/features/auth/data/auth_api_service.dart';
import 'package:grad_project/features/auth/data/auth_repository.dart';
import 'package:grad_project/features/customers/data/customer_api_service.dart';
import 'package:grad_project/features/customers/data/customer_repository.dart';
// import 'package:grad_project/features/auth/services/auth_service.dart';
import 'package:grad_project/features/customers/models/customer_hive.dart';
import 'package:grad_project/features/customers/providers/customer_provider.dart';
import 'package:grad_project/features/gps/data/gps_api_service.dart';
import 'package:grad_project/features/gps/data/gps_background_service.dart';
import 'package:grad_project/features/gps/data/gps_repository.dart';
import 'package:grad_project/features/gps/models/gps_point_hive.dart';
import 'package:grad_project/features/invoices/models/invoice_hive.dart';
import 'package:grad_project/features/invoices/models/invoice_item_hive.dart';
import 'package:grad_project/features/invoices/providers/invoice_provider.dart';
import 'package:grad_project/features/auth/providers/auth_provider.dart';
import 'package:grad_project/features/route/providers/route_plan_provider.dart';
import 'package:grad_project/features/route/providers/user_location_provider.dart';
import 'package:grad_project/features/van_stock/data/van_stock_api_service.dart';
import 'package:grad_project/features/van_stock/data/van_stock_repository.dart';
import 'package:grad_project/features/van_stock/models/van_stock_hive.dart';
import 'package:grad_project/features/van_stock/providers/van_stock_provider.dart';
import 'package:grad_project/features/visits/models/visit_hive.dart';
import 'package:grad_project/features/visits/providers/visit_provider.dart';
import 'package:grad_project/features/auth/screens/login_screen.dart';
import 'package:grad_project/features/route/screens/rout_plan_screen.dart';
import 'package:grad_project/features/workday/providers/workday_provider.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  // Register Hive adapters
  Hive.registerAdapter(CustomerHiveAdapter());
  Hive.registerAdapter(VanStockHiveAdapter());
  Hive.registerAdapter(InvoiceHiveAdapter());
  Hive.registerAdapter(InvoiceItemHiveAdapter());
  Hive.registerAdapter(VisitHiveAdapter());
  Hive.registerAdapter(GpsPointHiveAdapter());

  // Open Hive boxes
  final authBox = await Hive.openBox(HiveBoxes.authBox);
  final customerBox = await Hive.openBox<CustomerHive>(HiveBoxes.customers);
  final vanstockBox = await Hive.openBox<VanStockHive>(HiveBoxes.vanStock);
  await Hive.openBox<InvoiceHive>(HiveBoxes.invoices);
  await Hive.openBox<VisitHive>(HiveBoxes.visits);
  final gpsBox = await Hive.openBox<GpsPointHive>(HiveBoxes.gpsPoints);

  // Network layer
  final tokenStorage = TokenStorage(authBox);

  // ⭐ Initialize Dio + add interceptor BEFORE creating AuthApiService
  ApiClient.init(tokenStorage);

  final dio = ApiClient.instance; // includes interceptors

  // Auth
  final authApi = AuthApiService(dio);
  final authRepo = AuthRepository(authApi, tokenStorage);

  // GPS
  final gpsApi = GpsApiService(dio);
  final gpsRepo = GpsRepository(gpsBox, gpsApi);
  final gpsService = GpsBackgroundService(gpsRepo);

  // Customers
  final customerApi = CustomerApiService(dio);
  final customerRepo = CustomerRepository(customerApi, customerBox);

  // Van Stock
  final vanstockApi = VanStockApiService(dio);
  final vanstockRepo = VanStockRepository(vanstockApi, vanstockBox);

  runApp(
    MultiProvider(
      providers: [
        // AUTH
        ChangeNotifierProvider(create: (_) => AuthProvider(repo: authRepo)),

        // WORKDAY + GPS
        Provider(create: (_) => gpsRepo),
        Provider(create: (_) => gpsService),
        ChangeNotifierProvider(create: (_) => WorkdayProvider(gpsService)),

        // CORE FEATURES
        ChangeNotifierProvider(create: (_) => CustomerProvider(customerRepo)),
        ChangeNotifierProvider(create: (_) => VanStockProvider(vanstockRepo)),
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
