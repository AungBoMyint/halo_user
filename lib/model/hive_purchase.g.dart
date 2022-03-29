// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_purchase.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HivePurchaseAdapter extends TypeAdapter<HivePurchase> {
  @override
  final int typeId = 3;

  @override
  HivePurchase read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HivePurchase(
      items: (fields[0] as List).cast<dynamic>(),
      totalPrice: fields[1] as int,
      deliveryTownshipInfo: (fields[2] as List).cast<dynamic>(),
      dateTime: fields[3] as DateTime,
      id: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HivePurchase obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.items)
      ..writeByte(1)
      ..write(obj.totalPrice)
      ..writeByte(2)
      ..write(obj.deliveryTownshipInfo)
      ..writeByte(3)
      ..write(obj.dateTime)
      ..writeByte(4)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HivePurchaseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
