import 'package:firebase_auth/firebase_auth.dart';

import '../hive/hive_client.dart';
import 'package:uuid/uuid.dart';

import 'user_auth_data.dart';
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
  String uid = "";
  String sessionKey = "";

  void setNewSessionKey() {
    // todo: remove
    print("SESSION KEY");
    sessionKey = sl.get<Uuid>().v4();
    print(sessionKey);
  }

  // default data
  UserAuthData get def => UserAuthData();

  UserAuthData data() {
    if (state is UserAuthData) return state as UserAuthData;
    return def;
  }

  final HiveService hive;
  UserAuthService(this.hive);

  void setNoDataState() {
    state = UserAuthNoData();
    notifyListeners();
  }

  Future<void> saveData(UserAuthData user) async {
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
    uid = "";
    sessionKey = "";
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
}

class UserAuthState {}

class UserAuthError extends UserAuthState {}

class UserAuthLoading extends UserAuthState {}

class UserAuthNoData extends UserAuthState {}
