// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_auth_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAuthDataAdapter extends TypeAdapter<UserAuthData> {
  @override
  final int typeId = 1;

  @override
  UserAuthData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserAuthData(
      themePref: fields[0] as ThemePref,
    );
  }

  @override
  void write(BinaryWriter writer, UserAuthData obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.themePref);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAuthDataAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}

class ThemePrefAdapter extends TypeAdapter<ThemePref> {
  @override
  final int typeId = 2; // Choose a unique typeId for the enum

  @override
  ThemePref read(BinaryReader reader) {
    return ThemePref.values[reader.readInt()];
  }

  @override
  void write(BinaryWriter writer, ThemePref obj) {
    writer.writeInt(obj.index);
  }
}