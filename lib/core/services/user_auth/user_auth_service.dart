import 'package:confesi/core/services/hive/hive_client.dart';

class UserAuthService {
  UserAuthState state = UserAuthLoading();

  final HiveService hive;
  UserAuthService(this.hive);

  Future<void> setData() async {
    state = UserAuthData();
    print("================================================> set data");
  }

  Future<void> setNoData() async {
    state = UserAuthNoData();
    print("================================================> set NO data");
  }
}

class UserAuthState {}

class UserAuthLoading extends UserAuthState {}

class UserAuthNoData extends UserAuthState {}

class UserAuthData extends UserAuthState {}
