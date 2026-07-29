import 'package:grad_project/features/visits/models/visit_hive.dart';

class VisitDto {
  final int id;
  final int customerId;
  final DateTime startTime;
  final double startLat;
  final double startLng;
  final DateTime? endTime;
  final double? endLat;
  final double? endLng;
  final String status;
  final String? signatureUrl;
  final String? photoUrl;
  final double? deliveryLat;
  final double? deliveryLng;
  final String? notes;
  final int? invoiceId;

  VisitDto({
    required this.id,
    required this.customerId,
    required this.startTime,
    required this.startLat,
    required this.startLng,
    this.endTime,
    this.endLat,
    this.endLng,
    required this.status,
    this.signatureUrl,
    this.photoUrl,
    this.deliveryLat,
    this.deliveryLng,
    this.notes,
    this.invoiceId,
  });

  factory VisitDto.fromJson(Map<String, dynamic> json) {
    return VisitDto(
      id: json["id"],
      customerId: json["customerId"],
      startTime: DateTime.parse(json["startTime"]),
      startLat: (json["startLat"] as num).toDouble(),
      startLng: (json["startLng"] as num).toDouble(),
      endTime: json["endTime"] != null ? DateTime.parse(json["endTime"]) : null,
      endLat: json["endLat"] != null
          ? (json["endLat"] as num).toDouble()
          : null,
      endLng: json["endLng"] != null
          ? (json["endLng"] as num).toDouble()
          : null,
      status: json["status"],
      signatureUrl: json["signatureUrl"],
      photoUrl: json["photoUrl"],
      deliveryLat: json["deliveryLat"] != null
          ? (json["deliveryLat"] as num).toDouble()
          : null,
      deliveryLng: json["deliveryLng"] != null
          ? (json["deliveryLng"] as num).toDouble()
          : null,
      notes: json["notes"],
      invoiceId: json["invoiceId"],
    );
  }

  VisitHive toHive() {
    return VisitHive(
      id: id,
      customerId: customerId,
      startTime: startTime,
      startLat: startLat,
      startLng: startLng,
      endTime: endTime,
      endLat: endLat,
      endLng: endLng,
      status: status,
      signaturePath: signatureUrl,
      photoPath: photoUrl,
      deliveryLat: deliveryLat,
      deliveryLng: deliveryLng,
      notes: notes,
      synced: true,
      invoiceId: invoiceId,
    );
  }
}
