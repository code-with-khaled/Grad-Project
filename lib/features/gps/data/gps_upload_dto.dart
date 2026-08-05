class GpsUploadDto {
  final List<GpsPointDto> points;

  GpsUploadDto({required this.points});

  Map<String, dynamic> toJson() => {
    "points": points.map((p) => p.toJson()).toList(),
  };
}

class GpsPointDto {
  final double latitude;
  final double longitude;
  final DateTime recordedAt;

  GpsPointDto({
    required this.latitude,
    required this.longitude,
    required this.recordedAt,
  });

  Map<String, dynamic> toJson() => {
    "latitude": latitude,
    "longitude": longitude,
    "recordedAt": recordedAt.toIso8601String(),
  };
}
