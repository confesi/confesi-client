import 'package:Confessi/core/utils/tokens/user_id_from_jwt.dart';
import 'package:Confessi/domain/authenticatioin/entities/refresh_token.dart';
import 'package:Confessi/domain/authenticatioin/usecases/silent_authentication.dart';
import 'package:Confessi/presentation/shared/overlays/top_chip.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

import '../../../constants/enums_that_are_local_keys.dart';
import '../../../core/usecases/no_params.dart';
import '../../../domain/authenticatioin/usecases/logout.dart';
import '../../../domain/settings/usecases/appearance.dart';
import '../../../domain/settings/usecases/first_time.dart';
import '../../../domain/settings/usecases/load_refresh_token.dart';

part 'user_state.dart';

// TODO: Ensure logging out erases storage as well

class UserCubit extends Cubit<UserState> {
  final Logout logout;
  final SilentAuthentication silentAuthentication;
  final Appearance appearance;
  final LoadRefreshToken loadRefreshToken;
  final FirstTime firstTime;

  UserCubit(
      {required this.logout,
      required this.silentAuthentication,
      required this.appearance,
      required this.firstTime,
      required this.loadRefreshToken})
      : super(NoUser());

  bool get localDataLoaded => state is User;

  User get stateAsUser => state as User;

// TODO: Ensure that logging in / registering adds to prefs and doesn't just keep it empty?
// TODO: Maybe just call loadInitialPrefsAndTokens?
  /// Used to set the User if logging in, or registering.
  // void setUser() => emit(User());

  // void setNoUser() => emit(NoUser());

  // void setUnknownUser() => emit(UnknownUser());

  /// Logs out the user. Upon error, currently does nothing, as the user will still be logged in.
  void logoutUser() async {
    final failureOrSuccess = await logout.call((state as User).userID);
    failureOrSuccess.fold(
      (failure) {
        print("failure to log out...");
      }, // Do nothing upon failure to logout, as the user would still be logged in (hopefully)? Instead, upon pressing logout, check if the state didn't change, then if not, show an error dialog.
      (success) {
        emit(NoUser());
      },
    );
  }

  // TODO: Merge with loadInitialPrefsAndTokens
  Future<void> silentlyAuthenticateUser() async {
    await Future.delayed(const Duration(milliseconds: 1200));
    await (await loadRefreshToken.call(NoParams())).fold(
      (failure) {
        emit(LocalDataError());
      },
      (refreshToken) async {
        if (refreshToken.refreshTokenEnum == RefreshTokenEnum.noRefreshToken) {
          emit(NoUser());
          return;
        }
        // Decrypt JWT to get userID (mongo _id).
        userIDFromJWT(refreshToken.token).fold(
          (failure) => emit(LocalDataError()),
          (userID) async {
            // Opening Hive preferences box.
            await Hive.openBox(userID);
            (await appearance.get(AppearanceEnum.values, AppearanceEnum, userID)).fold(
              (failure) {
                emit(LocalDataError());
              },
              (appearanceEnum) async {
                (await firstTime.get(FirstTimeEnum.values, FirstTimeEnum, userID)).fold(
                  (failure) => emit(LocalDataError()),
                  (firstTimeEnum) async {
                    // At the last step in the chain, emit the full state, using the variables from each step.
                    emit(
                      User(
                          refreshToken: refreshToken.token, // Refresh token
                          userID: userID, // Unique user ID (used for storage box location with Hive)
                          firstTimeEnum: firstTimeEnum, // Preference
                          appearanceEnum: appearanceEnum), // Preference
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  Future<void> setAppearance(AppearanceEnum appearanceEnum, BuildContext context) async {
    if (state is! User) {
      showTopChip(context, "Error saving appearance.");
      return;
    }
    emit((state as User).copyWith(appearanceEnum: appearanceEnum));
    (await appearance.set(appearanceEnum, AppearanceEnum, (state as User).userID)).fold(
      (failure) => null, // show error message... scaffold messenger?
      (success) => null, // do nothing
    );
  }

  /// Set appearance.
  Future<void> setFirstTime(FirstTimeEnum firstTimeEnum, BuildContext context) async {
    if (state is! User) {
      showTopChip(context, "Error saving tutorial progress.");
      return;
    }
    emit((state as User).copyWith(firstTimeEnum: firstTimeEnum));
    (await firstTime.set(firstTimeEnum, FirstTimeEnum, (state as User).userID)).fold(
      (failure) => null, // show error message... scaffold messenger?
      (success) => null, // do nothing
    );
  }
}
