import 'package:grad_project/features/route/models/route_hive.dart';
import 'package:grad_project/features/route/models/route_stop_hive.dart';

class RouteDto {
  final int id;
  final int representativeId;
  final String representativeName;
  final int territoryId;
  final String territoryName;
  final String name;
  final String routeDate;
  final String status;
  final bool isOptimized;
  final List<RouteStopDto> stops;

  RouteDto({
    required this.id,
    required this.representativeId,
    required this.representativeName,
    required this.territoryId,
    required this.territoryName,
    required this.name,
    required this.routeDate,
    required this.status,
    required this.isOptimized,
    required this.stops,
  });

  factory RouteDto.fromJson(Map<String, dynamic> json) {
    return RouteDto(
      id: json["id"],
      representativeId: json["representativeId"],
      representativeName: json["representativeName"],
      territoryId: json["territoryId"],
      territoryName: json["territoryName"],
      name: json["name"],
      routeDate: json["routeDate"],
      status: json["status"],
      isOptimized: json["isOptimized"],
      stops: (json["stops"] as List)
          .map((s) => RouteStopDto.fromJson(s))
          .toList(),
    );
  }

  RouteHive toHive() {
    return RouteHive(
      id: id,
      name: name,
      routeDate: routeDate,
      isOptimized: isOptimized,
      stops: stops.map((s) => s.toHive()).toList(),
    );
  }
}

class RouteStopDto {
  final int assignmentId;
  final int customerId;
  final String customerName;
  final String customerAddress;
  final double latitude;
  final double longitude;
  final int sequenceNumber;

  RouteStopDto({
    required this.assignmentId,
    required this.customerId,
    required this.customerName,
    required this.customerAddress,
    required this.latitude,
    required this.longitude,
    required this.sequenceNumber,
  });

  factory RouteStopDto.fromJson(Map<String, dynamic> json) {
    return RouteStopDto(
      assignmentId: json["assignmentId"],
      customerId: json["customerId"],
      customerName: json["customerName"],
      customerAddress: json["customerAddress"],
      latitude: json["latitude"],
      longitude: json["longitude"],
      sequenceNumber: json["sequenceNumber"],
    );
  }

  RouteStopHive toHive() {
    return RouteStopHive(
      assignmentId: assignmentId,
      customerId: customerId,
      customerName: customerName,
      customerAddress: customerAddress,
      latitude: latitude,
      longitude: longitude,
      sequenceNumber: sequenceNumber,
    );
  }
}
