import 'package:confesi/core/services/hive/hive_client.dart';
import 'package:confesi/core/services/user_auth/user_auth_data.dart';

class UserAuthService {
  UserAuthState state = UserAuthLoading();

  final HiveService hive;
  UserAuthService(this.hive);

  Future<void> saveData(UserAuthData user, String uid) async {
    try {
      hive.openBoxByClass<UserAuthData>().then((box) async => await box.put(uid, user));
      state = user;
    } catch (_) {
      state = UserAuthError();
    }
  }

  Future<void> getData(String uid) async {
    try {
      final box = await hive.openBoxByClass<UserAuthData>(); // Use await here
      final user = box.get(uid);
      if (user == null) {
        // todo: defaults?
        print("case 1");
        state = UserAuthData();
      } else {
        print("case 2");
        state = user;
      }
    } catch (_) {
      state = UserAuthError();
    }
  }

  Future<void> clearData() async {
    try {
      hive.openBoxByClass<UserAuthData>().then((box) => box.clear());
      state = UserAuthNoData();
    } catch (_) {
      state = UserAuthError();
    }
  }
}

class UserAuthState {}

class UserAuthError extends UserAuthState {}

class UserAuthLoading extends UserAuthState {}

class UserAuthNoData extends UserAuthState {}
