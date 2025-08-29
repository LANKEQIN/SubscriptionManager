// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cached_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CachedDataAdapter extends TypeAdapter<CachedData> {
  @override
  final int typeId = 0;

  @override
  CachedData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CachedData(
      key: fields[0] as String,
      value: fields[1] as String,
      createdAt: fields[2] as DateTime,
      expiryDuration: fields[3] as Duration?,
    );
  }

  @override
  void write(BinaryWriter writer, CachedData obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.key)
      ..writeByte(1)
      ..write(obj.value)
      ..writeByte(2)
      ..write(obj.createdAt)
      ..writeByte(3)
      ..write(obj.expiryDuration);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CachedDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
