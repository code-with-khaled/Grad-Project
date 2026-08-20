// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:grad_project/core/network/endpoints.dart';
import 'visit_dto.dart';
import 'epod_dto.dart';

class VisitApiService {
  final Dio _dio;

  VisitApiService(this._dio);

  Future<void> checkIn({
    required int routeId,
    required int customerId,
    required double lat,
    required double lng,
    required String time,
  }) async {
    final response = await _dio.post(
      Endpoints.checkIn,
      data: {
        "routeId": routeId,
        "customerId": customerId,
        "latitude": lat,
        "longitude": lng,
        "checkInTime": time,
      },
    );

    print(response.data);
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
