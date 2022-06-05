import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_mobile_client/constants/general.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class Token {
  const Token(
      {this.error = false, this.accessToken = "", this.loading = true, this.newUser = false});

  final bool error;
  final String accessToken;
  final bool loading;
  final bool newUser;
}

@immutable
class UserState {
  const UserState(
      {this.token = const Token(error: false, accessToken: "", loading: true, newUser: false)});

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
    print("chek!!");
    // reset state (because user can click "try again" and retry the loading call)
    state = state.copyWith(
        newToken: const Token(error: false, accessToken: "", loading: true, newUser: false));
    // quick delay so there isn't any unnecessary "screen jank" from a fast transition
    await Future.delayed(const Duration(milliseconds: 400));
    try {
      const storage = FlutterSecureStorage();
      // UNCOMMENT LINE BELOW TO RE-ADD VALID REFRESH TOKEN TO DEVICE STORAGE
      await storage.write(
          key: "refreshToken",
          value:
              "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyTW9uZ29PYmplY3RJRCI6IjYyOTg2ZDBhYWQyZDI3MjI1ZjFhZGI2NSIsImlhdCI6MTY1NDQwMjUzNiwiZXhwIjoxNjg1OTYwMTM2fQ.-krqZhhaffuEo7D1a1cIBVKmb1Gw6-8QDXptj7sN0gI");

      final refreshToken = await storage.read(key: "refreshToken");
      if (refreshToken == null) {
        return state = state.copyWith(
            newToken: const Token(error: false, accessToken: "", loading: false, newUser: true));
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
        // in this case, redirect to OPEN (new user)
        return state = state.copyWith(
            newToken: const Token(error: false, accessToken: "", loading: false, newUser: true));
      } else {
        final String accessToken = json.decode(response.body)["accessToken"];
        state = state.copyWith(
            newToken:
                Token(error: false, accessToken: accessToken, loading: false, newUser: false));
      }
    } catch (e) {
      print("ERROR CAUGHT: $e");
      return state = state.copyWith(
          newToken: const Token(error: true, accessToken: "", loading: false, newUser: false));
    }
  }

  //TODO: remove access token from state, refresh token from storage, and refresh token from DB
  Future<String> logout() async {
    try {
      // DO I NEED THIS?
      // state = state.copyWith(
      //     newToken: const Token(error: false, accessToken: "", loading: true, newUser: false));
      // DO I NEED THIS?
      const storage = FlutterSecureStorage();
      final refreshToken = await storage.read(key: "refreshToken");
      // User must have somehow cleared the securestorage - nothing we can do to delete corresponding token in DB now, so we say "success"
      // and consider them a new user
      if (refreshToken == null) {
        state.copyWith(
            newToken: const Token(error: true, accessToken: "", loading: false, newUser: true));
        return "success";
      }
      final response = await http
          .delete(
            Uri.parse('$kDomain/api/user/logout'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
              "token": refreshToken.toString(),
            }),
          )
          .timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        state = state.copyWith(
            newToken: const Token(error: false, accessToken: "", loading: false, newUser: true));
        await storage.write(key: "refreshToken", value: null);
        print("succesfully logged out");
        return "success";
      } else {
        // ERROR LOGGING OUT
        state = state.copyWith(
            newToken: Token(
                error: false,
                accessToken: state.token.accessToken,
                loading: false,
                newUser: false));
        return "fail";
      }
    } catch (e) {
      // ERROR LOGGING OUT
      state = state.copyWith(
          newToken: Token(
              error: false, accessToken: state.token.accessToken, loading: false, newUser: false));
      return "fail";
      // direct to logout all route? suspicous activity? contact admin?
    }
  }
}

final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  return UserNotifier();
});
