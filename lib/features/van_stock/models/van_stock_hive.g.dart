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
      productId: fields[1] as int,
      name: fields[2] as String,
      sku: fields[3] as String,
      barcode: fields[4] as String,
      price: fields[5] as double,
      unitOfMeasure: fields[6] as String,
      minStockLevel: fields[7] as int,
      quantity: fields[8] as int,
      synced: fields[9] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, VanStockHive obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.productId)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.sku)
      ..writeByte(4)
      ..write(obj.barcode)
      ..writeByte(5)
      ..write(obj.price)
      ..writeByte(6)
      ..write(obj.unitOfMeasure)
      ..writeByte(7)
      ..write(obj.minStockLevel)
      ..writeByte(8)
      ..write(obj.quantity)
      ..writeByte(9)
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
