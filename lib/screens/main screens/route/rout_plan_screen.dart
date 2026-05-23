import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:grad_project/models/customer.dart';
import 'package:grad_project/providers/customer_provider.dart';
import 'package:grad_project/providers/route_plan_provider.dart';
import 'package:grad_project/providers/visit_provider.dart';
import 'package:grad_project/screens/main%20screens/visits/visit_summury_screen.dart';
import 'package:grad_project/services/location_service.dart';
import 'package:grad_project/widgets/numbered_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class RoutePlanScreen extends StatefulWidget {
  const RoutePlanScreen({super.key});

  @override
  State<RoutePlanScreen> createState() => _RoutePlanScreenState();
}

class _RoutePlanScreenState extends State<RoutePlanScreen> {
  final MapController _mapController = MapController();

  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_initialized) return;
    _initialized = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final customerProvider = context.read<CustomerProvider>();
      final routeProvider = context.read<RoutePlanProvider>();

      if (customerProvider.customers.isEmpty) {
        customerProvider.loadCustomers();
      }

      routeProvider.addListener(() {
        if (routeProvider.routePoints.isNotEmpty) {
          _fitToRoute(routeProvider.routePoints);
        }
      });

      customerProvider.addListener(() {
        if (customerProvider.customers.isNotEmpty) {
          routeProvider.fetchRoute(customerProvider.customers);
        }
      });
    });
  }

  void _fitToRoute(List<LatLng> points) {
    final bounds = LatLngBounds.fromPoints(points);

    _mapController.fitCamera(
      CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(50)),
    );
  }

  void _showCustomerSheet(Customer c, int order) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                c.name,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),

              Row(
                children: [
                  Icon(Icons.location_on_outlined),
                  SizedBox(width: 8),
                  Expanded(child: Text(c.address)),
                ],
              ),

              SizedBox(height: 12),

              Row(
                children: [
                  Icon(Icons.phone),
                  SizedBox(width: 8),
                  Text(c.phone),
                ],
              ),

              SizedBox(height: 20),

              Divider(),

              SizedBox(height: 20),

              Text(
                "Last Visit:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 6),
              Text("No visits yet (mock data)"),

              Spacer(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context); // close bottom sheet

                    final visitProvider = context.read<VisitProvider>();
                    final navigator = Navigator.of(context);

                    final gps = await LocationService.getCurrentLocation();

                    visitProvider.startVisit(c, gps);

                    navigator.push(
                      MaterialPageRoute(
                        builder: (_) =>
                            VisitSummaryScreen(customer: c, order: order),
                      ),
                    );
                  },
                  child: Text("Start Visit"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final customers = context.watch<CustomerProvider>().customers;
    final provider = context.watch<RoutePlanProvider>();

    return Scaffold(
      appBar: AppBar(title: Text("Today's Route")),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: LatLng(33.5138, 36.2765),
          initialZoom: 13,
        ),
        children: [
          TileLayer(
            urlTemplate:
                "https://api.maptiler.com/maps/streets/{z}/{x}/{y}.png?key=2pmivbrl0Vvc2gCFhs8L",
            userAgentPackageName: 'com.example.app',
          ),

          // Markers
          MarkerLayer(
            markers: [
              for (int i = 0; i < customers.length; i++)
                Marker(
                  point: LatLng(customers[i].lat, customers[i].lng),
                  width: 40,
                  height: 40,
                  child: GestureDetector(
                    onTap: () => _showCustomerSheet(customers[i], i + 1),
                    child: NumberedMarker(number: i + 1),
                  ),
                ),
            ],
          ),

          // Route polyline
          if (provider.isLoading)
            const Center(child: CircularProgressIndicator()),

          if (!provider.isLoading && provider.routePoints.isNotEmpty)
            PolylineLayer(
              polylines: [
                Polyline(
                  points: provider.routePoints,
                  strokeWidth: 4,
                  color: Colors.blue,
                ),
              ],
            ),
        ],
      ),
    );
  }
}
