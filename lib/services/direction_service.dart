import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class DirectionsService {
  static const _apiKey =
      "eyJvcmciOiI1YjNjZTM1OTc4NTExMTAwMDFjZjYyNDgiLCJpZCI6IjliZjQ2YmM1ODQ5NjQ0MTNiZGU0ZWYyMzBiYWRlNDY1IiwiaCI6Im11cm11cjY0In0=";

  static Future<Map<String, dynamic>> getRoute(LatLng start, LatLng end) async {
    final url = Uri.parse(
      "https://api.openrouteservice.org/v2/directions/driving-car/geojson",
    );

    final body = {
      "coordinates": [
        [start.longitude, start.latitude],
        [end.longitude, end.latitude],
      ],
    };

    final response = await http.post(
      url,
      headers: {"Authorization": _apiKey, "Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    final data = jsonDecode(response.body);

    final feature = data["features"][0];
    final coords = feature["geometry"]["coordinates"];
    final summary = feature["properties"]["summary"];

    return {
      "polyline": coords
          .map<LatLng>((p) => LatLng(p[1].toDouble(), p[0].toDouble()))
          .toList(),
      "distance": summary["distance"],
      "duration": summary["duration"],
    };
  }
}
