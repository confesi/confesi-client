import 'package:confesi/core/services/hive/hive_client.dart';
import 'package:confesi/core/services/user_auth/user_auth_data.dart';

class UserAuthService {
  UserAuthState state = UserAuthLoading();

  final HiveService hive;
  UserAuthService(this.hive);

  Future<void> getData(String uid) async {
    state = UserAuthData();
    hive.openBoxByClass<UserAuthData>().then((box) {
      final user = box.get(uid);
      if (user == null) {
        state = UserAuthNoData();
      } else {
        state = UserAuthData();
      }
    });
  }

  Future<void> setNoData() async {
    state = UserAuthNoData();
  }
}

enum ThemePref { light, dark, system }

class UserAuthState {}

class UserAuthLoading extends UserAuthState {}

class UserAuthNoData extends UserAuthState {}
