// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:grad_project/core/network/endpoints.dart';

class VisitApiService {
  final Dio _dio;

  VisitApiService(this._dio);

  Future<int> checkIn({
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

    final visitId = response.data['data']['id'];

    return visitId;
  }

  Future<void> checkOut({
    required int routeId,
    required int customerId,
    required double lat,
    required double lng,
    required String time,
  }) async {
    final response = await _dio.post(
      Endpoints.checkOut,
      data: {
        "routeId": routeId,
        "customerId": customerId,
        "latitude": lat,
        "longitude": lng,
        "checkOutTime": time,
      },
    );

    print(response.data);
  }
}
