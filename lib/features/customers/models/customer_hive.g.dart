// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CustomerHiveAdapter extends TypeAdapter<CustomerHive> {
  @override
  final int typeId = 1;

  @override
  CustomerHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CustomerHive(
      id: fields[0] as int,
      name: fields[1] as String,
      address: fields[2] as String,
      lat: fields[3] as double,
      lng: fields[4] as double,
      phone: fields[5] as String,
      visited: fields[6] as bool,
      synced: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, CustomerHive obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.address)
      ..writeByte(3)
      ..write(obj.lat)
      ..writeByte(4)
      ..write(obj.lng)
      ..writeByte(5)
      ..write(obj.phone)
      ..writeByte(6)
      ..write(obj.visited)
      ..writeByte(7)
      ..write(obj.synced);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomerHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
