import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:grad_project/features/customers/models/customer.dart';
import 'package:grad_project/features/customers/providers/customer_provider.dart';
import 'package:grad_project/features/route/providers/route_plan_provider.dart';
import 'package:grad_project/features/route/providers/user_location_provider.dart';
import 'package:grad_project/features/route/widgets/navigation_info_box.dart';
import 'package:grad_project/features/route/widgets/route_completed_banner.dart';
import 'package:grad_project/features/route/widgets/route_map.dart';
import 'package:grad_project/features/visits/providers/visit_provider.dart';
import 'package:grad_project/features/visits/screens/visit_summury_screen.dart';
import 'package:grad_project/core/services/location_service.dart';
import 'package:grad_project/features/route/widgets/next_customer_card.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class RoutePlanScreen extends StatefulWidget {
  const RoutePlanScreen({super.key});

  @override
  State<RoutePlanScreen> createState() => _RoutePlanScreenState();
}

class _RoutePlanScreenState extends State<RoutePlanScreen> {
  final MapController _mapController = MapController();

  Timer? _locationTimer;
  bool _initialized = false;
  CustomerProvider? _customerProvider;
  RoutePlanProvider? _routeProvider;
  UserLocationProvider? _userLocationProvider;
  bool _isNavigating = false;
  Customer? _selectedCustomer;
  Customer? _manualNextCustomer;
  bool _mapReady = false;
  bool _fitOnce = false;
  bool _isLoading = true;
  DateTime _lastRebuild = DateTime.now();

  // Getters to safely access providers
  CustomerProvider get customerProvider {
    return _customerProvider ??= context.read<CustomerProvider>();
  }

  RoutePlanProvider get routeProvider {
    return _routeProvider ??= context.read<RoutePlanProvider>();
  }

  UserLocationProvider get userLocationProvider {
    return _userLocationProvider ??= context.read<UserLocationProvider>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      // Initialize providers
      _customerProvider = context.read<CustomerProvider>();
      _routeProvider = context.read<RoutePlanProvider>();
      _userLocationProvider = context.read<UserLocationProvider>();

      // Add listener for user location updates
      _userLocationProvider!.addListener(_onUserLocationUpdated);

      // Add listener for customer updates
      _customerProvider!.addListener(_onCustomersUpdated);
    }

    if (_initialized) return;
    _initialized = true;

    // Initial data loading
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  void _loadInitialData() {
    if (!mounted) return;

    // Load customers if needed
    if (customerProvider.customers.isEmpty) {
      customerProvider.loadCustomers().then((_) {
        if (mounted) {
          setState(() {});
        }
      });
    }

    // Try to get user location
    userLocationProvider.update().then((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  void _onUserLocationUpdated() {
    _checkLoadingComplete();

    // Throttle rebuilds to prevent excessive updates
    if (DateTime.now().difference(_lastRebuild).inMilliseconds < 500) {
      return;
    }

    if (mounted) {
      // Schedule rebuild for next frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _lastRebuild = DateTime.now();
          });
        }
      });
    }

    if (_mapReady && !_fitOnce) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _tryFitMap();
      });
    }
  }

  void _onCustomersUpdated() {
    // Check if loading should be complete
    _checkLoadingComplete();

    if (mounted) {
      // Schedule rebuild for next frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {});
        }
      });
    }

    if (_mapReady && !_fitOnce) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _tryFitMap();
      });
    }
  }

  void _tryFitMap() {
    final userLoc = userLocationProvider.current;
    final customers = customerProvider.customers;

    if (userLoc == null || customers.isEmpty || !_mapReady || _fitOnce) {
      return;
    }

    try {
      _fitUserAndCustomers();
    } catch (e) {
      debugPrint('Map fit failed: $e');
    }
  }

  void _fitUserAndCustomers() {
    final userLoc = userLocationProvider.current;
    final customers = customerProvider.customers;

    if (userLoc == null || customers.isEmpty || !_mapReady) {
      return;
    }

    // Create a list of all points to fit
    final points = <LatLng>[userLoc];

    // Add all customer locations
    for (final customer in customers) {
      points.add(LatLng(customer.lat, customer.lng));
    }

    // Create bounds from all points
    final bounds = LatLngBounds.fromPoints(points);

    try {
      // Adjust padding based on whether NextCustomerCard is visible
      final hasNextCustomer = _nextCustomer != null && customers.isNotEmpty;
      final bottomPadding = hasNextCustomer ? 200.0 : 80.0;

      // Fit the camera to show all points with padding
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        _mapController.fitCamera(
          CameraFit.bounds(
            bounds: bounds,
            padding: EdgeInsets.fromLTRB(80, 80, 80, bottomPadding),
          ),
        );

        _fitOnce = true;
      });
    } catch (e) {
      // ignore: avoid_print
      print('Error fitting map: $e');
      // Fallback: just center on user location

      _mapController.move(userLoc, 13);
    }
  }

  void _checkLoadingComplete() {
    if (_isLoading &&
        customerProvider.customers.isNotEmpty &&
        userLocationProvider.current != null) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();

    // Start location update timer
    Future.microtask(() {
      if (!mounted) return;

      _locationTimer = Timer.periodic(const Duration(seconds: 3), (_) async {
        if (!mounted) return;

        try {
          await userLocationProvider.update();

          if (!_isNavigating || _selectedCustomer == null) return;

          final current = userLocationProvider.current;
          if (current == null) return;

          if (mounted) {
            await routeProvider.getNavigationRoute(
              current,
              LatLng(_selectedCustomer!.lat, _selectedCustomer!.lng),
            );
          }
        } catch (e) {
          // ignore: avoid_print
          print('Error in location timer: $e');
        }
      });
    });
  }

  @override
  void dispose() {
    _locationTimer?.cancel();

    // Remove listeners
    if (_userLocationProvider != null) {
      _userLocationProvider!.removeListener(_onUserLocationUpdated);
    }

    if (_customerProvider != null) {
      _customerProvider!.removeListener(_onCustomersUpdated);
    }

    super.dispose();
  }

  Customer? get _nextCustomer {
    if (_manualNextCustomer != null) return _manualNextCustomer;

    for (final c in customerProvider.customers) {
      if (!c.visited) return c;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final customers = customerProvider.customers;

    final visitedCount = customers.where((c) => c.visited).length;

    final totalCount = customers.length;

    final routeCompleted = totalCount > 0 && visitedCount == totalCount;

    // Show loading indicator while data is loading
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text("Today's Route")),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text('Loading route...', style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      );
    }

    final widget = Scaffold(
      appBar: AppBar(
        title: const Text("Today's Route"),
        actions: [
          if (totalCount > 0)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Text(
                  "$visitedCount/$totalCount",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Stack(
        children: [
          RouteMap(
            mapController: _mapController,
            customers: customers,
            userLocation: userLocationProvider.current,
            navigationRoute: routeProvider.navigationRoute,
            onMapReady: () {
              setState(() => _mapReady = true);

              WidgetsBinding.instance.addPostFrameCallback((_) {
                _tryFitMap();
              });
            },

            onCustomerSelected: (customer) {
              setState(() {
                _manualNextCustomer = customer;
              });
            },
          ),

          // Navigation info box
          if (routeProvider.navigationRoute.isNotEmpty)
            Positioned(
              top: 20,
              left: 20,
              right: 20,
              child: NavigationInfoBox(
                distance: routeProvider.navigationDistance,
                duration: routeProvider.navigationDuration,
                onCancel: () {
                  setState(() {
                    _isNavigating = false;
                    _selectedCustomer = null;
                  });

                  routeProvider.clearNavigation();
                },
              ),
            ),

          if (routeCompleted)
            const Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: RouteCompletedBanner(),
            ),

          // Next customer card
          if (_nextCustomer != null)
            NextCustomerCard(
              customer: _nextCustomer!,
              order: customerProvider.customers.indexOf(_nextCustomer!) + 1,
              onNavigate: () async {
                final currentUserLoc = userLocationProvider.current;
                final customer = _nextCustomer;

                if (currentUserLoc == null || customer == null) {
                  return;
                }

                setState(() {
                  _isNavigating = true;
                  _selectedCustomer = customer;
                });

                try {
                  await routeProvider.getNavigationRoute(
                    currentUserLoc,
                    LatLng(customer.lat, customer.lng),
                  );
                } catch (e) {
                  // ignore: avoid_print
                  print('Error getting navigation route: $e');
                }
              },
              onStartVisit: () async {
                final visitProvider = context.read<VisitProvider>();
                final navigator = Navigator.of(context);

                final customer = _nextCustomer!;
                final order = customerProvider.customers.indexOf(customer) + 1;

                try {
                  final gps = await LocationService.getCurrentLocation();
                  if (!mounted) return;

                  setState(() {
                    _manualNextCustomer = null;
                  });

                  visitProvider.startVisit(customer, gps);

                  navigator.push(
                    MaterialPageRoute(
                      builder: (_) => VisitSummaryScreen(
                        customer: customer,
                        order: order,
                        visit: visitProvider.currentVisit!,
                      ),
                    ),
                  );
                } catch (e) {
                  // ignore: avoid_print
                  print('Error starting visit: $e');
                }
              },
              onSelectNextCustomer: (Customer c) {
                setState(() {
                  _manualNextCustomer = c;
                });
              },
            ),

          Positioned(
            top: 16,
            right: 16,
            child: FloatingActionButton.small(
              heroTag: "recenter",
              onPressed: () {
                setState(() {
                  _fitOnce = false;
                });

                _tryFitMap();
              },
              child: const Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );

    return widget;
  }
}
