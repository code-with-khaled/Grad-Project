import 'package:grad_project/features/route/data/route_api_service.dart';
import 'package:grad_project/features/route/models/route_hive.dart';
import 'package:hive/hive.dart';

class RouteRepository {
  final RouteApiService _api;
  final Box<RouteHive> _box;

  RouteRepository(this._api, this._box);

  Future<RouteHive> syncTodayRoute() async {
    final dto = await _api.getMyRoute();
    final hive = dto.toHive();

    await _box.clear();
    await _box.put(hive.id, hive);

    return hive;
  }

  RouteHive? getTodayRoute() {
    return _box.values.isNotEmpty ? _box.values.first : null;
  }
}
