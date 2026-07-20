// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InvoiceHiveAdapter extends TypeAdapter<InvoiceHive> {
  @override
  final int typeId = 3;

  @override
  InvoiceHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InvoiceHive(
      id: fields[0] as int,
      customerId: fields[1] as int,
      visitId: fields[2] as int,
      total: fields[3] as double,
      createdAt: fields[4] as DateTime,
      items: (fields[6] as List).cast<InvoiceItemHive>(),
      synced: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, InvoiceHive obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.customerId)
      ..writeByte(2)
      ..write(obj.visitId)
      ..writeByte(3)
      ..write(obj.total)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.synced)
      ..writeByte(6)
      ..write(obj.items);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InvoiceHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
