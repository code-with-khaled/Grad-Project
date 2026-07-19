// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'van_stock_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VanStockHiveAdapter extends TypeAdapter<VanStockHive> {
  @override
  final int typeId = 2;

  @override
  VanStockHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VanStockHive(
      id: fields[0] as int,
      name: fields[1] as String,
      price: fields[2] as double,
      quantity: fields[3] as int,
      synced: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, VanStockHive obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.price)
      ..writeByte(3)
      ..write(obj.quantity)
      ..writeByte(4)
      ..write(obj.synced);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VanStockHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
