import 'package:hive/hive.dart';

part 'route_stop_hive.g.dart';

@HiveType(typeId: 41)
class RouteStopHive {
  @HiveField(0)
  int assignmentId;

  @HiveField(1)
  int customerId;

  @HiveField(2)
  String customerName;

  @HiveField(3)
  String customerAddress;

  @HiveField(4)
  double latitude;

  @HiveField(5)
  double longitude;

  @HiveField(6)
  int sequenceNumber;

  RouteStopHive({
    required this.assignmentId,
    required this.customerId,
    required this.customerName,
    required this.customerAddress,
    required this.latitude,
    required this.longitude,
    required this.sequenceNumber,
  });
}
