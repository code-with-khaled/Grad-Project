// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_stop_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RouteStopHiveAdapter extends TypeAdapter<RouteStopHive> {
  @override
  final int typeId = 41;

  @override
  RouteStopHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RouteStopHive(
      assignmentId: fields[0] as int,
      customerId: fields[1] as int,
      customerName: fields[2] as String,
      customerAddress: fields[3] as String,
      latitude: fields[4] as double,
      longitude: fields[5] as double,
      sequenceNumber: fields[6] as int,
    );
  }

  @override
  void write(BinaryWriter writer, RouteStopHive obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.assignmentId)
      ..writeByte(1)
      ..write(obj.customerId)
      ..writeByte(2)
      ..write(obj.customerName)
      ..writeByte(3)
      ..write(obj.customerAddress)
      ..writeByte(4)
      ..write(obj.latitude)
      ..writeByte(5)
      ..write(obj.longitude)
      ..writeByte(6)
      ..write(obj.sequenceNumber);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RouteStopHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
