import 'dart:async';
import 'package:grad_project/core/services/location_service.dart';
import 'package:grad_project/features/gps/data/gps_repository.dart';

class GpsBackgroundService {
  final GpsRepository _repo;

  Timer? _timer;

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
}
