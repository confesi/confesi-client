import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mobile_client/constants/general.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

enum AuthState {
  loggedIn,
  error,
}

@immutable
class UserState {
  const UserState({
    this.error = false,
    this.accessToken = "",
    this.loading = true,
    this.loggedIn = false,
    // toggle to show popup on screen of logout failure
    this.logoutFailureMessageToggle = false,
  });

  final bool error;
  final String accessToken;
  final bool loading;
  final bool loggedIn;
  // toggle to
  final bool logoutFailureMessageToggle;

  UserState copyWith(
      {String? newAccessToken,
      bool? newError,
      bool? newLoading,
      bool? newLoggedIn,
      bool? newLogoutFailureMessageToggle}) {
    return UserState(
      error: newError ?? error,
      accessToken: newAccessToken ?? accessToken,
      loading: newLoading ?? loading,
      loggedIn: newLoggedIn ?? loggedIn,
      logoutFailureMessageToggle: newLogoutFailureMessageToggle ?? logoutFailureMessageToggle,
    );
  }
}

class UserNotifier extends StateNotifier<UserState> {
  UserNotifier() : super(const UserState());

  // calling this toggles the logoutFailureMessageToggle variable which allows our listener to pickup a failed logout attempt was made
  void toggleLogoutFailure() =>
      state = state.copyWith(newLogoutFailureMessageToggle: !state.logoutFailureMessageToggle);

  void startAutoRefreshingAccessTokens() {
    Timer.periodic(const Duration(seconds: 2), (timer) {
      if (state.loggedIn) {
        print("REFRESHING TOKEN");
        getAndSetAccessToken();
      } else {
        timer.cancel();
      }
    });
  }

  // void refreshTokenCall() async {
  //   await Future.delayed(const Duration(seconds: 5));
  //   const storage = FlutterSecureStorage();
  //   final refreshToken = await storage.read(key: "refreshToken");
  // }

  void getAndSetAccessToken() async {
    // await Future.delayed(const Duration(seconds: 5));
    const storage = FlutterSecureStorage();
    // NEXT LINE JUST FOR TESTING; REMOVE LATER
    await storage.write(
        key: "refreshToken",
        value:
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyTW9uZ29PYmplY3RJRCI6IjYyOTg2ZDBhYWQyZDI3MjI1ZjFhZGI2NSIsImlhdCI6MTY1NTA3OTUxMiwiZXhwIjoxNjg2NjM3MTEyfQ.bwcLihOvU572fd3W_R00Z3il135PB8Mm3aCUzA58rMk");
    final refreshToken = await storage.read(key: "refreshToken");
    if (refreshToken == null) {
      // Token doesn't exist. Redirect to OPEN screen.
      state =
          state.copyWith(newAccessToken: "", newError: true, newLoading: false, newLoggedIn: false);
      return;
    }
    try {
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
      if (response.statusCode == 200) {
        // Access token received succesfully. Set to memory, then redirect to BOTTOM_NAV (home) screen.
        final String accessToken = json.decode(response.body)["accessToken"];
        state = state.copyWith(
            newAccessToken: accessToken, newError: false, newLoading: false, newLoggedIn: true);
        return;
      } else {
        // Access token not received successfully. Server responds with non-200 error code. Redirect to OPEN screen.
        state = state.copyWith(
            newAccessToken: "", newError: true, newLoading: false, newLoggedIn: false);
        return;
      }
    } catch (error) {
      // Request for access token from server failed or timed out. Redirect to ERROR screen.
      state =
          state.copyWith(newAccessToken: "", newError: true, newLoading: true, newLoggedIn: false);
      return;
    }
  }

  void logout() async {
    const storage = FlutterSecureStorage();
    final refreshToken = await storage.read(key: "refreshToken");
    // If user doesn't have an access token stored, there's nothing we can do but log them out pseudo succesfully. Redirect to OPEN screen.
    if (refreshToken == null) {
      state =
          state.copyWith(newError: true, newLoading: false, newAccessToken: "", newLoggedIn: false);
      return;
    }
    try {
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
          .timeout(const Duration(seconds: 2));
      if (response.statusCode == 200) {
        // Succesfully logged out. Now we clear refresh token from storage and set "loggedIn" (newLoggedIn) to false so we can see
        // if we're logged in or not (to tell if we should show error message).
        await storage.write(key: "refreshToken", value: null);
        print("SUCCESFULLY LOGGED OUT");
        state = state.copyWith(
            newError: true, newLoading: false, newAccessToken: "", newLoggedIn: false);
        return;
      } else {
        // Server didn't send us a 200 status code. Something went wrong. Don't explicitly do anything, except we're deliberately leaving
        // the "loggedIn" state bool false (we're not changing it). This allows us to check if we're logged in after our logout attempt,
        // then respond accordingly (show message: error occured, please you need connection to logout).
        toggleLogoutFailure();
        return;
      }
    } catch (error) {
      // Error occured signing out (usually connectivity). Don't explicitly do anything, except we're deliberately leaving
      // the "loggedIn" state bool false (we're not changing it). This allows us to check if we're logged in after our logout attempt,
      // then respond accordingly (show message: error occured, please you need connection to logout).
      toggleLogoutFailure();
      return;
    }
  }
}

final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  return UserNotifier();
});
