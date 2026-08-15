// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:grad_project/core/network/endpoints.dart';
import 'van_stock_dto.dart';

class VanStockApiService {
  final Dio _dio;

  VanStockApiService(this._dio);

  Future<List<VanStockDto>> fetchVanStock(int repId) async {
    final response = await _dio.get(Endpoints.vanStock(repId));

    print(response.data);

    final List data = response.data["data"];
    return data.map((e) => VanStockDto.fromJson(e)).toList();
  }
}
