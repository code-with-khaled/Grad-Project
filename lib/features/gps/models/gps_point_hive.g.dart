// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gps_point_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GpsPointHiveAdapter extends TypeAdapter<GpsPointHive> {
  @override
  final int typeId = 20;

  @override
  GpsPointHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GpsPointHive(
      lat: fields[0] as double,
      lng: fields[1] as double,
      timestamp: fields[2] as DateTime,
      synced: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, GpsPointHive obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.lat)
      ..writeByte(1)
      ..write(obj.lng)
      ..writeByte(2)
      ..write(obj.timestamp)
      ..writeByte(3)
      ..write(obj.synced);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GpsPointHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
