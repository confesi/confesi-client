import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
class UserState {
  const UserState({this.accessToken = ""});

  final String accessToken;

  UserState copyWith({String? token}) {
    return UserState(accessToken: token ?? accessToken);
  }
}

class UserNotifier extends StateNotifier<UserState> {
  UserNotifier() : super(const UserState());

  setToken(newValue) async {
    await Future.delayed(const Duration(seconds: 5));
    state = state.copyWith(token: newValue);
  }

  logout() {
    // also remove from DB
    state = state.copyWith(token: "");
  }
}

final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  return UserNotifier();
});
