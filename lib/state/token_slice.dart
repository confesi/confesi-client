import 'dart:async';
import 'dart:convert';
import 'package:flutter_mobile_client/constants/general.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum ScreenState {
  home,
  open,
  error,
  load,
  connectionError,
  serverError,
}

@immutable
class TokenState {
  const TokenState({this.accessToken = "", this.screen = ScreenState.load});

  final String accessToken;
  final ScreenState screen;

  TokenState copyWith({String? newAccessToken, ScreenState? newScreen}) {
    return TokenState(
      accessToken: newAccessToken ?? accessToken,
      screen: newScreen ?? screen,
    );
  }
}

class TokenNotifier extends StateNotifier<TokenState> {
  TokenNotifier() : super(const TokenState());

  void startAutoRefreshingAccessTokens() {
    Timer.periodic(const Duration(seconds: 5), (timer) {
      // Basically checking if we're either logged in (home) or no internet - in that case, keep checking.
      if (state.screen == ScreenState.home || state.screen == ScreenState.error) {
        getAndSetAccessToken();
      } else {
        // Otherwise, cancel refreshing our access token.
        timer.cancel();
      }
    });
  }

  dynamic getAndSetAccessToken() async {
    const storage = FlutterSecureStorage();
    // NEXT LINE JUST FOR TESTING; REMOVE LATER
    await storage.write(
        key: "refreshToken",
        value:
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyTW9uZ29PYmplY3RJRCI6IjYyOTg2ZDBhYWQyZDI3MjI1ZjFhZGI2NSIsImlhdCI6MTY1NTE3ODI0MywiZXhwIjoxNjg2NzM1ODQzfQ.v6-k9oeAMTODpgrO_bkAa4LHY9MRw4Zm_-amvXg2QfI");
    final refreshToken = await storage.read(key: "refreshToken");
    if (refreshToken == null) {
      // Token doesn't exist. Set screen state to OPEN.
      return state = state.copyWith(newScreen: ScreenState.open);
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
        // Access token received succesfully. Set to memory, Set screen state to HOME (bottom_nav).
        final String accessToken = json.decode(response.body)["accessToken"];
        return state = state.copyWith(newAccessToken: accessToken, newScreen: ScreenState.home);
      } else {
        // Access token not received successfully. Server responds with non-200 error code. Set screen state to OPEN.
        return state = state.copyWith(newScreen: ScreenState.open);
      }
    } on TimeoutException {
      // Request for access token from server failed (timeout error - probably connectivity). Set screen state to ERROR.
      return state = state.copyWith(newScreen: ScreenState.error);
    } catch (error) {
      // Request for access token from server failed (server error). Set screen state to ERROR.
      return state = state.copyWith(newScreen: ScreenState.error);
    }
  }

  void logout() async {
    const storage = FlutterSecureStorage();
    final refreshToken = await storage.read(key: "refreshToken");
    // If user doesn't have an access token stored, there's nothing we can do but log them out pseudo succesfully. Redirect to OPEN screen.
    if (refreshToken == null) {
      state = state.copyWith(newAccessToken: "", newScreen: ScreenState.open);
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
        state = state.copyWith(newAccessToken: "", newScreen: ScreenState.open);
        return;
      } else {
        // Server didn't send us a 200 status code. Something went wrong. Don't explicitly do anything, except we're deliberately leaving
        // the "loggedIn" state bool false (we're not changing it). This allows us to check if we're logged in after our logout attempt,
        // then respond accordingly (show message: error occured, please you need connection to logout).
        // toggleLogoutFailure();
        return;
      }
    } on TimeoutException {
      // Error occured signing out (connection error). Set a flag.
      return;
    } catch (error) {
      // Error occured signing out (server error). Set a flag.
      return;
    }
  }
}

final tokenProvider = StateNotifierProvider<TokenNotifier, TokenState>(
  (ref) => TokenNotifier(),
);
