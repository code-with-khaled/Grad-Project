import 'visit_api_service.dart';

class VisitRepository {
  final VisitApiService _api;

  VisitRepository(this._api);

  Future<int> checkIn(
    int routeId,
    int customerId,
    double lat,
    double lng,
  ) async {
    final timestamp = formatTimestamp(DateTime.now());

    final visitId = await _api.checkIn(
      routeId: routeId,
      customerId: customerId,
      lat: lat,
      lng: lng,
      time: timestamp,
    );

    return visitId;
  }

  Future<void> checkOut(
    int routeId,
    int customerId,
    double lat,
    double lng,
  ) async {
    final timestamp = formatTimestamp(DateTime.now());

    await _api.checkOut(
      routeId: routeId,
      customerId: customerId,
      lat: lat,
      lng: lng,
      time: timestamp,
    );
  }

  String formatTimestamp(DateTime dt) {
    final withoutMicros = DateTime(
      dt.year,
      dt.month,
      dt.day,
      dt.hour,
      dt.minute,
      dt.second,
    );

    return "${withoutMicros.toIso8601String()}+03:00";
  }
}
