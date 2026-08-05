import 'package:grad_project/features/gps/data/gps_api_service.dart';
import 'package:hive/hive.dart';
import 'package:grad_project/features/gps/models/gps_point_hive.dart';

class GpsRepository {
  final Box<GpsPointHive> _box;
  final GpsApiService api;

  GpsRepository(this._box, this.api);

  /// Save a new GPS point (called every minute)
  Future<void> savePoint(double lat, double lng) async {
    final point = GpsPointHive(
      lat: lat,
      lng: lng,
      timestamp: DateTime.now(),
      synced: false,
    );

    await _box.add(point);

    // ignore: avoid_print
    print("GPS SAVED → $lat, $lng at ${point.timestamp}");
  }

  /// Get all unsynced points (for batch upload)
  List<GpsPointHive> getUnsyncedPoints() {
    return _box.values.where((p) => !p.synced).toList();
  }

  /// Mark points as synced after successful upload
  Future<void> markPointsSynced(List<GpsPointHive> points) async {
    for (final p in points) {
      p.synced = true;
      await p.save();
    }
  }

  Future<void> uploadUnsynced() async {
    final unsynced = getUnsyncedPoints();
    if (unsynced.isEmpty) return;

    final payload = unsynced
        .map(
          (p) => {
            "latitude": p.lat,
            "longitude": p.lng,
            "recordedAt": p.timestamp.toIso8601String(),
          },
        )
        .toList();

    await api.uploadPoints(payload);
    await markPointsSynced(unsynced);
  }

  Future<void> uploadUnsyncedDirect(
    double lat,
    double lng,
    DateTime timestamp,
  ) async {
    final timestamp = formatTimestamp(DateTime.now());

    final payload = {
      "points": [
        {"latitude": lat, "longitude": lng, "recordedAt": timestamp},
      ],
    };

    await api.uploadPoints(payload["points"]!);
  }

  /// Clear all points at end of day
  Future<void> clearAll() async {
    await _box.clear();
  }

  String formatTimestamp(DateTime dt) {
    final withoutMicros = DateTime(
      dt.year,
      dt.month,
      dt.day,
      dt.hour,
      dt.minute,
      dt.second,
    );

    return "${withoutMicros.toIso8601String()}+03:00";
  }
}
