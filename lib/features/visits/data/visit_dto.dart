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
    final strLoc = json["checkInLocation"]?.split(",");
    final srtLat = strLoc != null ? double.parse(strLoc[0]) : 0.0;
    final strLng = strLoc != null ? double.parse(strLoc[1]) : 0.0;

    final endLoc = json["checkOutLocation"]?.split(",");
    final endLat = endLoc != null ? double.parse(strLoc[0]) : 0.0;
    final endLng = endLoc != null ? double.parse(strLoc[1]) : 0.0;

    return VisitDto(
      id: json["id"],
      customerId: json["customerId"],
      startTime: DateTime.parse(json["startTime"]),
      startLat: srtLat,
      startLng: strLng,
      endTime: json["endTime"] != null ? DateTime.parse(json["endTime"]) : null,
      endLat: endLat,
      endLng: endLng,
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
