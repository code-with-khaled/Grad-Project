class Visit {
  final String id;
  final int customerId;
  final DateTime startTime;
  final double startLat;
  final double startLng;

  DateTime? endTime;
  double? endLat;
  double? endLng;

  String status; // in_progress, completed, canceled

  Visit({
    required this.id,
    required this.customerId,
    required this.startTime,
    required this.startLat,
    required this.startLng,
    this.endTime,
    this.endLat,
    this.endLng,
    this.status = "in_progress",
  });
}
