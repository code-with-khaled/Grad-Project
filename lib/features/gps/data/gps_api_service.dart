// ignore_for_file: avoid_print

import 'package:dio/dio.dart';

class GpsApiService {
  final Dio _dio;

  GpsApiService(this._dio);

  Future<void> uploadPoints(List<Map<String, dynamic>> payload) async {
    final response = await _dio.post(
      "/tracking/gps",
      data: {"points": payload},
    );

    print(response.data);
  }
}
