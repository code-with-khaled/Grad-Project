import 'package:grad_project/features/route/data/epod_artifact_dto.dart';

class EPODPayloadDto {
  final int visitId;
  final String? signatureToken;
  final String? photoToken;
  final String? notes;
  final List<EPODArtifactDto> artifacts;

  EPODPayloadDto({
    required this.visitId,
    this.signatureToken,
    this.photoToken,
    this.notes,
    required this.artifacts,
  });

  Map<String, dynamic> toJson() => {
    "artifacts": artifacts.map((a) => a.toJson()).toList(),
  };
}
