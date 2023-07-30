import 'package:hive/hive.dart';

import 'user_auth_service.dart';

part 'user_auth_data.g.dart';

//? Whenever changed, run `flutter packages pub run build_runner build` to rebuild the generated file.

enum ThemePref { light, dark, system }

enum ProfanityFilter { on, off }

@HiveType(typeId: 1)
class UserAuthData extends HiveObject with UserAuthState {
  @HiveField(0)
  final ThemePref themePref;

  @HiveField(6)
  final ProfanityFilter profanityFilter;

  final bool isShrunkView;

  // default
  UserAuthData(
      {this.themePref = ThemePref.system, this.profanityFilter = ProfanityFilter.off, this.isShrunkView = false});
}

// copyWith
extension UserAuthDataCopyWith on UserAuthData {
  UserAuthData copyWith({
    ThemePref? themePref,
    ProfanityFilter? profanityFilter,
    bool? isShrunkView,
  }) {
    return UserAuthData(
      themePref: themePref ?? this.themePref,
      profanityFilter: profanityFilter ?? this.profanityFilter,
      isShrunkView: isShrunkView ?? this.isShrunkView,
    );
  }
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

class ProfanityFilterAdapter extends TypeAdapter<ProfanityFilter> {
  @override
  final int typeId = 5; // Choose a unique typeId for the enum

  @override
  ProfanityFilter read(BinaryReader reader) {
    return ProfanityFilter.values[reader.readInt()];
  }

  @override
  void write(BinaryWriter writer, ProfanityFilter obj) {
    writer.writeInt(obj.index);
  }
}
