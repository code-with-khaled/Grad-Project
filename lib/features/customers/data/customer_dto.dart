import 'package:grad_project/features/customers/models/customer_hive.dart';

class CustomerDto {
  final int id;
  final String name;
  final String address;
  final double lat;
  final double lng;
  final String phone;

  CustomerDto({
    required this.id,
    required this.name,
    required this.address,
    required this.lat,
    required this.lng,
    required this.phone,
  });

  factory CustomerDto.fromJson(Map<String, dynamic> json) {
    return CustomerDto(
      id: json["id"],
      name: json["name"],
      address: json["address"],
      lat: (json["lat"] as num).toDouble(),
      lng: (json["lng"] as num).toDouble(),
      phone: json["phone"],
    );
  }

  CustomerHive toHive() {
    return CustomerHive(
      id: id,
      name: name,
      address: address,
      lat: lat,
      lng: lng,
      phone: phone,
      visited: false,
      synced: true,
    );
  }
}
