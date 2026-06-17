import 'package:flutter/foundation.dart';
import 'package:grad_project/core/services/direction_service.dart';
import 'package:latlong2/latlong.dart';

class RoutePlanProvider extends ChangeNotifier {
  List<LatLng> routePoints = [];
  bool isLoading = false;
  String? errorMessage;

  List<LatLng> navigationRoute = [];
  double? navigationDistance;
  double? navigationDuration;

  Future<void> getNavigationRoute(LatLng start, LatLng end) async {
    final result = await DirectionsService.getRoute(start, end);

    navigationRoute = result["polyline"];
    navigationDistance = result["distance"];
    navigationDuration = result["duration"];

    notifyListeners();
  }

  void clearNavigation() {
    navigationRoute = [];
    navigationDistance = null;
    navigationDuration = null;
    notifyListeners();
  }

  // Future<void> fetchRoute(List<Customer> customers) async {
  //   try {
  //     isLoading = true;
  //     errorMessage = null;
  //     notifyListeners();

  //     final coords = customers.map((c) => [c.lng, c.lat]).toList();

  //     final url = Uri.parse(
  //       "https://api.openrouteservice.org/v2/directions/driving-car/geojson",
  //     );

  //     final response = await http.post(
  //       url,
  //       headers: {
  //         "Authorization":
  //             "eyJvcmciOiI1YjNjZTM1OTc4NTExMTAwMDFjZjYyNDgiLCJpZCI6IjliZjQ2YmM1ODQ5NjQ0MTNiZGU0ZWYyMzBiYWRlNDY1IiwiaCI6Im11cm11cjY0In0=",
  //         "Content-Type": "application/json",
  //       },
  //       body: jsonEncode({"coordinates": coords}),
  //     );

  //     final data = jsonDecode(response.body);

  //     final List<dynamic> points =
  //         data["features"][0]["geometry"]["coordinates"];

  //     routePoints = points.map((p) => LatLng(p[1], p[0])).toList();
  //   } catch (e) {
  //     errorMessage = "Failed to load route";
  //   } finally {
  //     isLoading = false;
  //     notifyListeners();
  //   }
  // }
}
