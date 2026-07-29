class EPODPayloadDto {
  final int visitId;
  final String? signatureToken;
  final String? photoToken;
  final double deliveryLat;
  final double deliveryLng;
  final String? notes;

  EPODPayloadDto({
    required this.visitId,
    this.signatureToken,
    this.photoToken,
    required this.deliveryLat,
    required this.deliveryLng,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
    "visitId": visitId,
    "signatureToken": signatureToken,
    "photoToken": photoToken,
    "deliveryLat": deliveryLat,
    "deliveryLng": deliveryLng,
    "notes": notes,
  };
}
