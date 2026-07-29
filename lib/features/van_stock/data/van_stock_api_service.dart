import 'package:dio/dio.dart';
import 'package:grad_project/core/network/api_client.dart';
import 'package:grad_project/core/network/endpoints.dart';
import 'van_stock_dto.dart';

class VanStockApiService {
  final Dio _dio = ApiClient.instance;

  Future<List<VanStockDto>> fetchVanStock(int repId) async {
    final response = await _dio.get(Endpoints.vanStock(repId));

    final List data = response.data["items"];
    return data.map((e) => VanStockDto.fromJson(e)).toList();
  }
}
