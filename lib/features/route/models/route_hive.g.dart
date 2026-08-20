// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RouteHiveAdapter extends TypeAdapter<RouteHive> {
  @override
  final int typeId = 40;

  @override
  RouteHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RouteHive(
      id: fields[0] as int,
      name: fields[1] as String,
      routeDate: fields[2] as String,
      isOptimized: fields[3] as bool,
      stops: (fields[4] as List).cast<RouteStopHive>(),
    );
  }

  @override
  void write(BinaryWriter writer, RouteHive obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.routeDate)
      ..writeByte(3)
      ..write(obj.isOptimized)
      ..writeByte(4)
      ..write(obj.stops);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RouteHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
