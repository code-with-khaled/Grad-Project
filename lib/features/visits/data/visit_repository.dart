import 'package:hive/hive.dart';
import 'package:grad_project/features/visits/models/visit_hive.dart';
import 'visit_api_service.dart';
import 'epod_dto.dart';

class VisitRepository {
  final VisitApiService _api;
  final Box<VisitHive> _box;

  VisitRepository(this._api, this._box);

  Future<void> checkIn(
    int routeId,
    int customerId,
    double lat,
    double lng,
  ) async {
    final timestamp = formatTimestamp(DateTime.now());

    await _api.checkIn(
      routeId: routeId,
      customerId: customerId,
      lat: lat,
      lng: lng,
      time: timestamp,
    );
  }

  Future<VisitHive> checkOut(int visitId, double lat, double lng) async {
    final dto = await _api.checkOut(visitId: visitId, lat: lat, lng: lng);

    final hive = dto.toHive();
    _box.put(hive.id, hive);

    return hive;
  }

  Future<void> submitEPOD({
    required int visitId,
    required String? signaturePath,
    required String? photoPath,
    required double deliveryLat,
    required double deliveryLng,
    required String? notes,
  }) async {
    String? signatureToken;
    String? photoToken;

    if (signaturePath != null) {
      signatureToken = await _api.uploadFile(signaturePath);
    }

    if (photoPath != null) {
      photoToken = await _api.uploadFile(photoPath);
    }

    final dto = EPODPayloadDto(
      visitId: visitId,
      signatureToken: signatureToken,
      photoToken: photoToken,
      deliveryLat: deliveryLat,
      deliveryLng: deliveryLng,
      notes: notes,
    );

    await _api.submitEPOD(dto);

    final visit = _box.get(visitId);
    if (visit != null) {
      visit.synced = true;
      visit.signaturePath = signaturePath;
      visit.photoPath = photoPath;
      visit.deliveryLat = deliveryLat;
      visit.deliveryLng = deliveryLng;
      visit.notes = notes;
      await visit.save();
    }
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
