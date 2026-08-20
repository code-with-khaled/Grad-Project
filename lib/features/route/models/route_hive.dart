import 'package:grad_project/features/route/models/route_stop_hive.dart';
import 'package:hive/hive.dart';

part 'route_hive.g.dart';

@HiveType(typeId: 40)
class RouteHive extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String routeDate;

  @HiveField(3)
  bool isOptimized;

  @HiveField(4)
  List<RouteStopHive> stops;

  RouteHive({
    required this.id,
    required this.name,
    required this.routeDate,
    required this.isOptimized,
    required this.stops,
  });
}
