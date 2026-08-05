import 'package:flutter/foundation.dart';
import 'package:grad_project/features/gps/data/gps_background_service.dart';

class WorkdayProvider extends ChangeNotifier {
  bool _isWorkdayActive = false;

  final GpsBackgroundService gpsService;

  WorkdayProvider(this.gpsService);

  bool get isWorkdayActive => _isWorkdayActive;

  void startWorkday() {
    _isWorkdayActive = true;
    gpsService.start();
    notifyListeners();
  }

  void endWorkday() {
    _isWorkdayActive = false;
    gpsService.stop();
    notifyListeners();
  }
}
