import 'package:dio/dio.dart';
import 'package:grad_project/core/network/api_client.dart';
import 'package:grad_project/core/network/endpoints.dart';
import 'visit_dto.dart';
import 'epod_dto.dart';

class VisitApiService {
  final Dio _dio = ApiClient.instance;

  Future<VisitDto> checkIn({
    required int customerId,
    required double lat,
    required double lng,
  }) async {
    final response = await _dio.post(
      Endpoints.checkIn,
      data: {"customerId": customerId, "lat": lat, "lng": lng},
    );

    return VisitDto.fromJson(response.data);
  }

  Future<VisitDto> checkOut({
    required int visitId,
    required double lat,
    required double lng,
  }) async {
    final response = await _dio.post(
      Endpoints.checkOut,
      data: {"visitId": visitId, "lat": lat, "lng": lng},
    );

    return VisitDto.fromJson(response.data);
  }

  Future<String> uploadFile(String filePath) async {
    final formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(filePath),
    });

    final response = await _dio.post(Endpoints.uploadFile, data: formData);

    return response.data["fileToken"];
  }

  Future<void> submitEPOD(EPODPayloadDto dto) async {
    await _dio.post("/epod/submit", data: dto.toJson());
  }
}
