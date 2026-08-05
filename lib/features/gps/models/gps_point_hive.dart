import 'package:hive/hive.dart';

part 'gps_point_hive.g.dart';

@HiveType(typeId: 20)
class GpsPointHive extends HiveObject {
  @HiveField(0)
  double lat;

  @HiveField(1)
  double lng;

  @HiveField(2)
  DateTime timestamp;

  @HiveField(3)
  bool synced;

  GpsPointHive({
    required this.lat,
    required this.lng,
    required this.timestamp,
    this.synced = false,
  });
}
