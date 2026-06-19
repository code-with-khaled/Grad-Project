import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:grad_project/features/customers/models/customer.dart';
import 'package:grad_project/features/route/widgets/numbered_marker.dart';
import 'package:latlong2/latlong.dart';

class RouteMap extends StatelessWidget {
  const RouteMap({
    super.key,
    required this.mapController,
    required this.customers,
    required this.userLocation,
    required this.navigationRoute,
    required this.onMapReady,
    required this.onCustomerSelected,
  });

  final MapController mapController;
  final List<Customer> customers;
  final LatLng? userLocation;
  final List<LatLng> navigationRoute;
  final VoidCallback onMapReady;
  final ValueChanged<Customer> onCustomerSelected;

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: const LatLng(33.5138, 36.2765),
        initialZoom: 13,
        onMapReady: onMapReady,
      ),
      children: [
        TileLayer(
          urlTemplate:
              "https://api.maptiler.com/maps/streets/{z}/{x}/{y}.png?key=2pmivbrl0Vvc2gCFhs8L",
          userAgentPackageName: 'com.example.app',
        ),

        if (userLocation != null)
          MarkerLayer(
            markers: [
              Marker(
                point: userLocation!,
                width: 30,
                height: 30,
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

        if (customers.isNotEmpty)
          MarkerLayer(
            markers: [
              for (int i = 0; i < customers.length; i++)
                Marker(
                  point: LatLng(customers[i].lat, customers[i].lng),
                  width: 40,
                  height: 40,
                  child: GestureDetector(
                    onTap: () => onCustomerSelected(customers[i]),
                    child: NumberedMarker(
                      number: i + 1,
                      visited: customers[i].visited,
                    ),
                  ),
                ),
            ],
          ),

        if (navigationRoute.isNotEmpty)
          PolylineLayer(
            polylines: [
              Polyline(
                points: navigationRoute,
                strokeWidth: 4,
                color: Colors.orange,
              ),
            ],
          ),
      ],
    );
  }
}
