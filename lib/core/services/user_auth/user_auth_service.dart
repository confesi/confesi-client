import 'package:confesi/core/services/hive/hive_client.dart';
import 'package:confesi/core/services/user_auth/user_auth_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:riverpod/riverpod.dart';

import '../../../init.dart';

// access the authService
final authService = StateProvider((ref) {
  final userAuthService = sl.get<UserAuthService>();
  return userAuthService.data();
});

class UserAuthService extends ChangeNotifier {
  UserAuthState state = UserAuthLoading();
  bool isAnon = true;
  String email = "";

  UserAuthData get def => UserAuthData(
        themePref: ThemePref.system,
      );

  UserAuthData data() {
    if (state is UserAuthData) return state as UserAuthData;
    return def;
  }

  final HiveService hive;
  UserAuthService(this.hive);

  Future<void> saveData(UserAuthData user, String uid) async {
    try {
      hive.openBoxByClass<UserAuthData>().then((box) async => await box.put(uid, user));
      state = user;
    } catch (_) {
      state = UserAuthError();
    }
    notifyListeners();
  }

  Future<void> clearCurrentExtraData() async {
    isAnon = true;
    email = "";
    notifyListeners();
  }

  Future<void> getData(String uid) async {
    try {
      final box = await hive.openBoxByClass<UserAuthData>(); // Use await here
      final user = box.get(uid);
      if (user == null) {
        // default
        state = def;
      } else {
        // return the user
        state = user;
      }
    } catch (_) {
      state = UserAuthError();
    }
    notifyListeners();
  }

  Future<void> clearData() async {
    try {
      hive.openBoxByClass<UserAuthData>().then((box) => box.clear());
      state = UserAuthNoData();
    } catch (_) {
      state = UserAuthError();
    }
    notifyListeners();
  }
}

class UserAuthState {}

class UserAuthError extends UserAuthState {}

class UserAuthLoading extends UserAuthState {}

class UserAuthNoData extends UserAuthState {}
