// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveItemAdapter extends TypeAdapter<HiveItem> {
  @override
  final int typeId = 1;

  @override
  HiveItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveItem(
      id: fields[0] as String,
      photo: fields[1] as String,
      photo2: fields[2] as String,
      photo3: fields[3] as String,
      name: fields[5] as String,
      brand: fields[6] as String,
      deliverytime: fields[7] as String,
      price: fields[8] as int,
      discountprice: fields[9] as int,
      desc: fields[4] as String,
      color: fields[10] as String,
      size: fields[11] as String,
      star: fields[12] as int,
      category: fields[13] as String,
      isOwnBrand: fields[14] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, HiveItem obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.photo)
      ..writeByte(2)
      ..write(obj.photo2)
      ..writeByte(3)
      ..write(obj.photo3)
      ..writeByte(4)
      ..write(obj.desc)
      ..writeByte(5)
      ..write(obj.name)
      ..writeByte(6)
      ..write(obj.brand)
      ..writeByte(7)
      ..write(obj.deliverytime)
      ..writeByte(8)
      ..write(obj.price)
      ..writeByte(9)
      ..write(obj.discountprice)
      ..writeByte(10)
      ..write(obj.color)
      ..writeByte(11)
      ..write(obj.size)
      ..writeByte(12)
      ..write(obj.star)
      ..writeByte(13)
      ..write(obj.category)
      ..writeByte(14)
      ..write(obj.isOwnBrand);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
