import 'package:hive/hive.dart';

import 'user_auth_service.dart';

part 'user_auth_data.g.dart';

//? Whenever changed, run `flutter packages pub run build_runner build` to rebuild the generated file.

enum ThemePref { light, dark, system }

@HiveType(typeId: 1)
class UserAuthData extends HiveObject with UserAuthState {
  @HiveField(0)
  final ThemePref themePref;

  UserAuthData({this.themePref = ThemePref.system});
}

// copyWith
extension UserAuthDataCopyWith on UserAuthData {
  UserAuthData copyWith({
    ThemePref? themePref,
  }) {
    return UserAuthData(
      themePref: themePref ?? this.themePref,
    );
  }
}