import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:grad_project/models/customer.dart';
import 'package:grad_project/providers/route_plan_provider.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class RoutePlanScreen extends StatefulWidget {
  const RoutePlanScreen({super.key});

  @override
  State<RoutePlanScreen> createState() => _RoutePlanScreenState();
}

class _RoutePlanScreenState extends State<RoutePlanScreen> {
  final List<Customer> customers = [
    Customer(
      name: "Customer 1",
      id: 1,
      address: "Address 1",
      phone: "Phone 1",
      lat: 33.5138,
      lng: 36.2765,
    ),
    Customer(
      name: "Customer 2",
      id: 2,
      address: "Address 2",
      phone: "Phone 2",
      lat: 33.5190,
      lng: 36.2800,
    ),
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context.read<RoutePlanProvider>().fetchRoute(customers);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RoutePlanProvider>();

    return Scaffold(
      appBar: AppBar(title: Text("Today's Route")),
      body: FlutterMap(
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
            markers: customers.map((c) {
              return Marker(
                point: LatLng(c.lat, c.lng),
                width: 40,
                height: 40,
                child: Icon(Icons.location_pin, size: 40, color: Colors.red),
              );
            }).toList(),
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
