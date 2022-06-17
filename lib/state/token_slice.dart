import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_mobile_client/constants/general.dart';
import 'package:flutter_mobile_client/responses/register.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum ScreenState {
  home,
  open,
  load,
  connectionError,
  serverError,
}

enum LoginResponse {
  connectionError,
  serverError,
  detailsIncorrect,
  accountDoesNotExist,
  fieldsCannotBeBlank,
  passwordTooShort,
  usernameOrEmailTooShort,
  success,
}

@immutable
class TokenState {
  const TokenState(
      {this.accessToken = "",
      this.screen = ScreenState.load,
      this.connectionErrorFLAG = false,
      this.serverErrorFLAG = false});

  final String accessToken;
  final ScreenState screen;

  // Flags are toggled to indicate a change to the listeners in the UI to show a context message.
  // Their actual true/false value doesn't matter too much, just that they're toggled. Or, should I restrict it in the future?
  final bool serverErrorFLAG;
  final bool connectionErrorFLAG;

  TokenState copyWith(
      {String? newAccessToken,
      ScreenState? newScreen,
      bool? newConnectionErrorFLAG,
      bool? newServerErrorFLAG}) {
    return TokenState(
      accessToken: newAccessToken ?? accessToken,
      screen: newScreen ?? screen,
      connectionErrorFLAG: newConnectionErrorFLAG ?? connectionErrorFLAG,
      serverErrorFLAG: newServerErrorFLAG ?? serverErrorFLAG,
    );
  }
}

class TokenNotifier extends StateNotifier<TokenState> {
  TokenNotifier() : super(const TokenState());

  void startAutoRefreshingAccessTokens() {
    // Refreshes 500 milliseconds before the access token is set to expire
    Timer.periodic(const Duration(milliseconds: kAccessTokenLifetime - 500), (timer) {
      print("SCREEN STATE: ${state.screen.toString()}");
      // Basically checking if we're either logged in (home) or no internet or server error - in that case, keep checking.
      if (state.screen == ScreenState.home ||
          state.screen == ScreenState.connectionError ||
          state.screen == ScreenState.serverError) {
        getAndSetAccessToken();
      } else {
        // Otherwise, cancel refreshing our access token.
        timer.cancel();
      }
    });
  }

  dynamic getAndSetAccessToken() async {
    // If this is the first time opening the app (splash screen is being displayed), wait a bit before doing the API call to prevent
    // the splash screen from being loaded and really quickly being switched.
    if (state.screen == ScreenState.load) {
      await Future.delayed(const Duration(milliseconds: 400));
    }
    const storage = FlutterSecureStorage();
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
        // Checks if you're currently home (not logged out) or if you're loading (first opening app) before it sets new access token.
        // This should prevent clicking logout, being logged out, then having a refresh request finishing after you've logged out and setting your
        // accessToken in memory (after logging out, your ScreeState is set to OPEN)
        if (state.screen != ScreenState.open) {
          return state = state.copyWith(newAccessToken: accessToken, newScreen: ScreenState.home);
        }
      } else {
        // Access token not received successfully. Server responds with non-200 error code. Set screen state to OPEN.
        return state = state.copyWith(newScreen: ScreenState.open);
      }
    } on TimeoutException {
      // Request for access token from server failed (timeout error - probably connectivity). Set screen state to ERROR.
      return state = state.copyWith(newScreen: ScreenState.connectionError);
    } on SocketException {
      // Request for access token from server failed (internet connection error). Set screen state to ERROR.
      return state = state.copyWith(newScreen: ScreenState.connectionError);
    } catch (error) {
      // Request for access token from server failed (server error). Set screen state to ERROR.
      return state = state.copyWith(newScreen: ScreenState.serverError);
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
        // Succesfully logged out.
        state = state.copyWith(newAccessToken: "", newScreen: ScreenState.open);
        await storage.write(key: "refreshToken", value: null);
        return;
      } else {
        // Server didn't send us a 200 status code. Something went wrong.
        // Error occured signing out (server error). Set a flag.
        state = state.copyWith(newServerErrorFLAG: !state.serverErrorFLAG);
        return;
      }
    } on TimeoutException {
      // Error occured signing out (connection error). Set a flag.
      state = state.copyWith(newConnectionErrorFLAG: !state.connectionErrorFLAG);
      return;
    } on SocketException {
      // Request for access token from server failed (internet connection error). Set screen state to ERROR.
      state = state.copyWith(newConnectionErrorFLAG: !state.connectionErrorFLAG);
      return;
    } catch (error) {
      // Error occured signing out (server error). Set a flag.
      state = state.copyWith(newServerErrorFLAG: !state.serverErrorFLAG);
      return;
    }
  }

  Future<RegisterResponse> register(String email, String username, String password) async {
    await Future.delayed(const Duration(milliseconds: 400));
    try {
      final response = await http
          .post(
            Uri.parse('$kDomain/api/user/register'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
              "email": email,
              "username": username,
              "password": password,
            }),
          )
          .timeout(const Duration(seconds: 2));
      if (response.statusCode == 201) {
        print("Success!");
        final String accessToken = json.decode(response.body)["accessToken"];
        final String refreshToken = json.decode(response.body)["refreshToken"];
        const storage = FlutterSecureStorage();
        await storage.write(key: "refreshToken", value: refreshToken);
        state = state.copyWith(newScreen: ScreenState.home, newAccessToken: accessToken);
        return RegisterResponse.success;
      } else if (response.statusCode == 500) {
        return RegisterResponse.serverError;
      } else if (response.statusCode == 400) {
        return serverErrorConversion(json.decode(response.body));
      } else {
        print("here");
        return RegisterResponse.serverError;
      }
    } on TimeoutException {
      return RegisterResponse.connectionError;
    } on SocketException {
      return RegisterResponse.connectionError;
    } catch (error) {
      print("here2: $error");
      return RegisterResponse.serverError;
    }
  }

  Future<LoginResponse> login(String usernameOrEmail, String password) async {
    // Wait x time as not to create a jank
    await Future.delayed(const Duration(milliseconds: 400));
    try {
      final response = await http
          .post(
            Uri.parse('$kDomain/api/user/login'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
              "usernameOrEmail": usernameOrEmail,
              "password": password,
            }),
          )
          .timeout(const Duration(seconds: 2));
      if (response.statusCode == 200) {
        print("Success!");
        final String accessToken = json.decode(response.body)["accessToken"];
        final String refreshToken = json.decode(response.body)["refreshToken"];
        const storage = FlutterSecureStorage();
        await storage.write(key: "refreshToken", value: refreshToken);
        state = state.copyWith(newScreen: ScreenState.home, newAccessToken: accessToken);
        return LoginResponse.success;
      } else if (response.statusCode == 500) {
        print("Internal server error");
        return LoginResponse.serverError;
      } else if (response.statusCode == 400) {
        switch (json.decode(response.body)["error"]) {
          case "account doesn't exist":
            return LoginResponse.accountDoesNotExist;
          case "password incorrect":
            return LoginResponse.detailsIncorrect;
          case "fields cannot be blank":
            return LoginResponse.fieldsCannotBeBlank;
          default:
            return LoginResponse.serverError;
        }
      } else {
        print("Incorrect details (specify email/username or password is wrong)");
        return LoginResponse.detailsIncorrect;
      }
    } on TimeoutException {
      return LoginResponse.connectionError;
    } on SocketException {
      return LoginResponse.connectionError;
    } catch (error) {
      return LoginResponse.serverError;
    }
  }
}

final tokenProvider = StateNotifierProvider<TokenNotifier, TokenState>(
  (ref) => TokenNotifier(),
);
