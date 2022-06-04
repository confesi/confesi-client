import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_mobile_client/constants/general.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class Token {
  const Token({this.error = false, this.accessToken = "", this.loading = true});

  final bool error;
  final String accessToken;
  final bool loading;
}

@immutable
class UserState {
  const UserState({this.token = const Token(error: false, accessToken: "", loading: true)});

  final Token token;

  UserState copyWith({Token? newToken}) {
    return UserState(token: newToken ?? token);
  }
}

class UserNotifier extends StateNotifier<UserState> {
  UserNotifier() : super(const UserState());

  // looks in device storage, if refresh token exists, makes call and gets
  // a corresponding access token from server and sets it into state
  setAccessToken() async {
    // reset state (because user can click "try again" and retry the loading call)
    state = state.copyWith(newToken: const Token(error: false, accessToken: "", loading: true));
    // quick delay so there isn't any unnecessary "screen jank" from a fast transition
    await Future.delayed(const Duration(milliseconds: 400));
    try {
      const storage = FlutterSecureStorage();
      final refreshToken = await storage.read(key: "refreshToken");
      if (refreshToken == null) {
        return state =
            state.copyWith(newToken: const Token(error: true, accessToken: "", loading: false));
      }
      // req to get access token
      // if valid response, set that new access token into state
      final response = await http
          .post(
            Uri.parse('$kDomain/api/user/token'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
              "token": refreshToken,
            }),
          )
          .timeout(const Duration(seconds: 2));
      if (response.statusCode != 200) {
        return state =
            state.copyWith(newToken: const Token(error: true, accessToken: "", loading: false));
      } else {
        final String accessToken = json.decode(response.body)["accessToken"];
        state =
            state.copyWith(newToken: Token(error: false, accessToken: accessToken, loading: false));
      }
    } catch (e) {
      return state =
          state.copyWith(newToken: const Token(error: true, accessToken: "", loading: false));
    }
  }

  // remove access token from state, refresh token from storage, and refresh token from DB
  logout() {
    // TODO: add here
  }
}

final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  return UserNotifier();
});
