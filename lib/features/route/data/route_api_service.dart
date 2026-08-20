import 'package:dio/dio.dart';
import 'package:grad_project/core/network/endpoints.dart';
import 'package:grad_project/features/route/models/route_dto.dart';

class RouteApiService {
  final Dio _dio;

  RouteApiService(this._dio);

  Future<RouteDto> getMyRoute() async {
    final response = await _dio.get(Endpoints.routeToday);

    // ignore: avoid_print
    print(response.data);

    return RouteDto.fromJson(response.data["data"]);
  }
}
