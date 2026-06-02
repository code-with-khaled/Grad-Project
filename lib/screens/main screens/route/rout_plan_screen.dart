import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:grad_project/models/customer.dart';
import 'package:grad_project/providers/customer_provider.dart';
import 'package:grad_project/providers/route_plan_provider.dart';
import 'package:grad_project/providers/user_location_provider.dart';
import 'package:grad_project/providers/visit_provider.dart';
import 'package:grad_project/screens/main%20screens/visits/visit_summury_screen.dart';
import 'package:grad_project/services/location_service.dart';
import 'package:grad_project/utils/map_launcher.dart';
import 'package:grad_project/widgets/next_customer_card.dart';
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

  bool _followUser = true;
  Timer? _locationTimer;
  bool _initialized = false;
  VoidCallback? _routeListener;
  VoidCallback? _customerListener;
  late CustomerProvider _customerProvider;
  late RoutePlanProvider _routeProvider;
  bool _mapReady = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      _customerProvider = context.read<CustomerProvider>();
      _routeProvider = context.read<RoutePlanProvider>();
    }

    if (_initialized) return;
    _initialized = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final customerProvider = _customerProvider;
      final routeProvider = _routeProvider;

      if (customerProvider.customers.isEmpty) {
        customerProvider.loadCustomers();
      }

      _routeListener = () {
        if (!mounted) return;
        if (routeProvider.routePoints.isNotEmpty) {
          setState(() => _followUser = false);

          if (_mapReady) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                _fitToRoute(routeProvider.routePoints);
              }
            });
          }
        }
      };
      routeProvider.addListener(_routeListener!);

      _customerListener = () {
        if (!mounted) return;
        if (customerProvider.customers.isNotEmpty) {
          routeProvider.fetchRoute(customerProvider.customers);
        }
      };
      customerProvider.addListener(_customerListener!);
    });
  }

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (!mounted) return;

      final userLoc = context.read<UserLocationProvider>();

      _locationTimer = Timer.periodic(const Duration(seconds: 3), (_) {
        if (mounted) {
          userLoc.update();
        }
      });
    });
  }

  @override
  void dispose() {
    _locationTimer?.cancel();

    final customerProvider = _customerProvider;
    final routeProvider = _routeProvider;

    if (_routeListener != null) {
      routeProvider.removeListener(_routeListener!);
    }

    if (_customerListener != null) {
      customerProvider.removeListener(_customerListener!);
    }

    super.dispose();
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
                child: OutlinedButton.icon(
                  icon: Icon(Icons.directions),
                  label: Text("Get Directions"),
                  onPressed: () {
                    Navigator.pop(context);
                    MapLauncher.openDirections(c.lat, c.lng);
                  },
                ),
              ),

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

  Customer? get _nextCustomer {
    if (_customerProvider.customers.isEmpty) return null;

    for (final c in _customerProvider.customers) {
      if (!c.visited) return c;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final customers = context.watch<CustomerProvider>().customers;
    final provider = context.watch<RoutePlanProvider>();
    final userLoc = context.watch<UserLocationProvider>().current;

    if (_mapReady && _followUser && userLoc != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _mapController.move(userLoc, _mapController.camera.zoom);
        }
      });
    }

    return Scaffold(
      appBar: AppBar(title: Text("Today's Route")),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: LatLng(33.5138, 36.2765),
              initialZoom: 13,
              onMapReady: () => setState(() => _mapReady = true),
              onPositionChanged: (position, hasGesture) {
                if (hasGesture && _followUser) {
                  setState(() => _followUser = false);
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate:
                    "https://api.maptiler.com/maps/streets/{z}/{x}/{y}.png?key=2pmivbrl0Vvc2gCFhs8L",
                userAgentPackageName: 'com.example.app',
              ),

              // User location marker
              if (userLoc != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: userLoc,
                      width: 20,
                      height: 20,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                      ),
                    ),
                  ],
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
                        child: NumberedMarker(
                          number: i + 1,
                          visited: customers[i].visited,
                        ),
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

          if (_nextCustomer != null)
            NextCustomerCard(
              customer: _nextCustomer!,
              order: _customerProvider.customers.indexOf(_nextCustomer!) + 1,
              onNavigate: () => MapLauncher.openDirections(
                _nextCustomer!.lat,
                _nextCustomer!.lng,
              ),
              onStartVisit: () async {
                final visitProvider = context.read<VisitProvider>();
                final navigator = Navigator.of(context);

                final customer = _nextCustomer!;
                final order = _customerProvider.customers.indexOf(customer) + 1;

                final gps = await LocationService.getCurrentLocation();
                if (!mounted) return;

                visitProvider.startVisit(customer, gps);

                navigator.push(
                  MaterialPageRoute(
                    builder: (_) =>
                        VisitSummaryScreen(customer: customer, order: order),
                  ),
                );
              },
            ),
        ],
      ),

      floatingActionButton: Padding(
        padding: _nextCustomer != null
            ? const EdgeInsets.only(bottom: 120)
            : EdgeInsets.zero,
        child: FloatingActionButton(
          child: Icon(Icons.my_location),
          onPressed: () {
            setState(() => _followUser = true);

            final userLoc = context.read<UserLocationProvider>().current;
            if (_mapReady && userLoc != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  _mapController.move(userLoc, _mapController.camera.zoom);
                }
              });
            }
          },
        ),
      ),
    );
  }
}
