// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visit_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VisitHiveAdapter extends TypeAdapter<VisitHive> {
  @override
  final int typeId = 6;

  @override
  VisitHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VisitHive(
      id: fields[0] as int,
      customerId: fields[1] as int,
      startTime: fields[2] as DateTime,
      startLat: fields[3] as double,
      startLng: fields[4] as double,
      endTime: fields[5] as DateTime?,
      endLat: fields[6] as double?,
      endLng: fields[7] as double?,
      status: fields[8] as String,
      signaturePath: fields[9] as String?,
      photoPath: fields[10] as String?,
      deliveryLat: fields[11] as double?,
      deliveryLng: fields[12] as double?,
      notes: fields[13] as String?,
      synced: fields[14] as bool,
      invoiceId: fields[15] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, VisitHive obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.customerId)
      ..writeByte(2)
      ..write(obj.startTime)
      ..writeByte(3)
      ..write(obj.startLat)
      ..writeByte(4)
      ..write(obj.startLng)
      ..writeByte(5)
      ..write(obj.endTime)
      ..writeByte(6)
      ..write(obj.endLat)
      ..writeByte(7)
      ..write(obj.endLng)
      ..writeByte(8)
      ..write(obj.status)
      ..writeByte(9)
      ..write(obj.signaturePath)
      ..writeByte(10)
      ..write(obj.photoPath)
      ..writeByte(11)
      ..write(obj.deliveryLat)
      ..writeByte(12)
      ..write(obj.deliveryLng)
      ..writeByte(13)
      ..write(obj.notes)
      ..writeByte(14)
      ..write(obj.synced)
      ..writeByte(15)
      ..write(obj.invoiceId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VisitHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
