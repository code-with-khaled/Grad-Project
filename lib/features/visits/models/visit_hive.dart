import 'package:hive/hive.dart';

part 'visit_hive.g.dart';

@HiveType(typeId: 6)
class VisitHive extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  int customerId;

  @HiveField(2)
  DateTime startTime;

  @HiveField(3)
  double startLat;

  @HiveField(4)
  double startLng;

  @HiveField(5)
  DateTime? endTime;

  @HiveField(6)
  double? endLat;

  @HiveField(7)
  double? endLng;

  @HiveField(8)
  String status; // in_progress, completed, canceled

  // ePOD fields
  @HiveField(9)
  String? signaturePath; // saved locally

  @HiveField(10)
  String? photoPath; // saved locally

  @HiveField(11)
  double? deliveryLat;

  @HiveField(12)
  double? deliveryLng;

  @HiveField(13)
  String? notes;

  // Sync
  @HiveField(14)
  bool synced;

  // Invoice linkage
  @HiveField(15)
  int? invoiceId;

  VisitHive({
    this.id,
    required this.customerId,
    required this.startTime,
    required this.startLat,
    required this.startLng,
    this.endTime,
    this.endLat,
    this.endLng,
    this.status = "in_progress",
    this.signaturePath,
    this.photoPath,
    this.deliveryLat,
    this.deliveryLng,
    this.notes,
    this.synced = true,
    this.invoiceId,
  });
}
