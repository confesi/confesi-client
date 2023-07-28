// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FcmTokenAdapter extends TypeAdapter<FcmToken> {
  @override
  final int typeId = 7;

  @override
  FcmToken read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FcmToken(
      fields[0] as bool,
      fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, FcmToken obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.withUid)
      ..writeByte(1)
      ..write(obj.token);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FcmTokenAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
