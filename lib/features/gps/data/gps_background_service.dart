// ignore_for_file: avoid_print

import 'dart:async';
import 'package:grad_project/core/services/location_service.dart';
import 'package:grad_project/features/gps/data/gps_repository.dart';

class GpsBackgroundService {
  final GpsRepository _repo;

  Timer? _timer;
  Timer? _foregroundTestTimer;

  GpsBackgroundService(this._repo);

  /// Start collecting GPS every minute
  Future<void> start() async {
    _timer = Timer.periodic(Duration(minutes: 1), (_) async {
      try {
        final pos = await LocationService.getCurrentLocation();

        await _repo.savePoint(pos.latitude, pos.longitude);
      } catch (e) {
        // Optional: log or ignore
      }
    });
  }

  /// Stop tracking
  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> syncGpsPoints() async {
    await _repo.uploadUnsynced();
  }

  Future<void> startForegroundTest() async {
    print("Starting FOREGROUND GPS TEST...");

    _foregroundTestTimer = Timer.periodic(Duration(seconds: 10), (_) async {
      try {
        final pos = await LocationService.getCurrentLocation();

        print("Sending test point: ${pos.latitude}, ${pos.longitude}");

        await _repo.uploadUnsyncedDirect(
          pos.latitude,
          pos.longitude,
          DateTime.now(),
        );
      } catch (e) {
        print("Foreground GPS test failed: $e");
      }
    });
  }

  void stopForegroundTest() {
    print("Stopping FOREGROUND GPS TEST...");
    _foregroundTestTimer?.cancel();
    _foregroundTestTimer = null;
  }
}
