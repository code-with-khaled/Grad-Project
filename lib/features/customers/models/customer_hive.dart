import 'package:hive/hive.dart';

part 'customer_hive.g.dart';

@HiveType(typeId: 1)
class CustomerHive extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String address;

  @HiveField(3)
  double lat;

  @HiveField(4)
  double lng;

  @HiveField(5)
  String phone;

  @HiveField(6)
  bool visited;

  @HiveField(7)
  bool synced;

  CustomerHive({
    required this.id,
    required this.name,
    required this.address,
    required this.lat,
    required this.lng,
    required this.phone,
    this.visited = false,
    this.synced = true,
  });
}
