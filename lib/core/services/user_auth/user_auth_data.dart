import 'package:hive/hive.dart';

import 'user_auth_service.dart';

part 'user_auth_data.g.dart';

//? Whenever changed, run `flutter packages pub run build_runner build` to rebuild the generated file.

@HiveType(typeId: 1)
class UserAuthData extends HiveObject with UserAuthState {
  @HiveField(0)
  final ThemePref themePref;

  UserAuthData({this.themePref = ThemePref.system});
}
