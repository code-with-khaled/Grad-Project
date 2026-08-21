class EPODArtifactDto {
  final String type; // SIGNATURE or DELIVERY_PHOTO
  final String fileToken;
  final String capturedAt;

  EPODArtifactDto({
    required this.type,
    required this.fileToken,
    required this.capturedAt,
  });

  Map<String, dynamic> toJson() => {
    "type": type,
    "fileToken": fileToken,
    "capturedAt": capturedAt,
  };
}
