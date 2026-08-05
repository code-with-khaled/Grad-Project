import 'package:hive/hive.dart';
import 'package:grad_project/features/gps/models/gps_point_hive.dart';

class GpsRepository {
  final Box<GpsPointHive> _box;

  GpsRepository(this._box);

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

  /// Clear all points at end of day
  Future<void> clearAll() async {
    await _box.clear();
  }
}
