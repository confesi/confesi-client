// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PrefsAdapter extends TypeAdapter<Prefs> {
  @override
  final int typeId = 4;

  @override
  Prefs read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Prefs(
      textScale: fields[0] as int,
      theme: fields[1] as AppTheme,
    );
  }

  @override
  void write(BinaryWriter writer, Prefs obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.textScale)
      ..writeByte(1)
      ..write(obj.theme);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrefsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 0;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      fields[0] as Prefs,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.prefs);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class GuestUserAdapter extends TypeAdapter<GuestUser> {
  @override
  final int typeId = 1;

  @override
  GuestUser read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GuestUser(
      fields[0] as Prefs,
    );
  }

  @override
  void write(BinaryWriter writer, GuestUser obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.prefs);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GuestUserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AccountUserAdapter extends TypeAdapter<AccountUser> {
  @override
  final int typeId = 3;

  @override
  AccountUser read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AccountUser(
      fields[1] as String,
      fields[0] as Prefs,
    );
  }

  @override
  void write(BinaryWriter writer, AccountUser obj) {
    writer
      ..writeByte(2)
      ..writeByte(1)
      ..write(obj.token)
      ..writeByte(0)
      ..write(obj.prefs);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccountUserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserTypeAdapter extends TypeAdapter<UserType> {
  @override
  final int typeId = 6;

  @override
  UserType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return UserType.guest;
      case 1:
        return UserType.account;
      default:
        return UserType.guest;
    }
  }

  @override
  void write(BinaryWriter writer, UserType obj) {
    switch (obj) {
      case UserType.guest:
        writer.writeByte(0);
        break;
      case UserType.account:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AppThemeAdapter extends TypeAdapter<AppTheme> {
  @override
  final int typeId = 5;

  @override
  AppTheme read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AppTheme.light;
      case 1:
        return AppTheme.dark;
      default:
        return AppTheme.light;
    }
  }

  @override
  void write(BinaryWriter writer, AppTheme obj) {
    switch (obj) {
      case AppTheme.light:
        writer.writeByte(0);
        break;
      case AppTheme.dark:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppThemeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
