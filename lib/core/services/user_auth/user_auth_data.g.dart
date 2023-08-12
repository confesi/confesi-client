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
      profanityFilter: fields[6] as ProfanityFilter,
      isShrunkView: fields[7] as bool,
      shakeToGiveFeedback: fields[8] as bool,
      unitSystem: fields[11] as UnitSystem,
      defaultCommentSort: fields[14] as DefaultCommentSort,
      defaultPostFeed: fields[15] as DefaultPostFeed,
      textSize: fields[16] as TextSize,
      componentCurviness: fields[18] as ComponentCurviness,
    );
  }

  @override
  void write(BinaryWriter writer, UserAuthData obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.themePref)
      ..writeByte(6)
      ..write(obj.profanityFilter)
      ..writeByte(7)
      ..write(obj.isShrunkView)
      ..writeByte(8)
      ..write(obj.shakeToGiveFeedback)
      ..writeByte(11)
      ..write(obj.unitSystem)
      ..writeByte(14)
      ..write(obj.defaultCommentSort)
      ..writeByte(15)
      ..write(obj.defaultPostFeed)
      ..writeByte(16)
      ..write(obj.textSize)
      ..writeByte(18)
      ..write(obj.componentCurviness);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAuthDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
