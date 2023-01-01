import 'package:dartz/dartz.dart';

import '../../../constants/authentication_and_settings/enums.dart';
import '../../../core/results/failures.dart';
import '../../../domain/authentication_and_settings/usecases/home_viewed.dart';

import '../../../constants/local_storage_keys.dart';
import '../../../core/utils/tokens/user_id_from_jwt.dart';
import '../../../domain/authentication_and_settings/entities/refresh_token.dart';
import '../../../domain/authentication_and_settings/entities/user.dart';
import '../../../core/alt_unused/silent_authentication.dart';
import '../../../core/alt_unused/notification_chip.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

import '../../../constants/enums_that_are_local_keys.dart';
import '../../../core/usecases/no_params.dart';
import '../../../domain/authentication_and_settings/usecases/logout.dart';
import '../../../domain/authentication_and_settings/usecases/appearance.dart';
import '../../../domain/authentication_and_settings/usecases/load_refresh_token.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final Logout logout;
  final Appearance appearance;
  final HomeViewed homeViewed;
  final LoadRefreshToken loadRefreshToken;

  UserCubit({
    required this.logout,
    required this.homeViewed,
    required this.appearance,
    required this.loadRefreshToken,
  }) : super(UserLoading());

  // // TODO: remove? needed?
  // bool get localDataLoaded => state is User;

  /// Get the state assuming its [User].
  User get stateAsUser => state as User;

  /// Returns userId assuming state is [User].
  String userId() => stateAsUser.userType.userId();

  /// Logs out the user.
  ///
  /// Shows message on error logging out.
  void logoutUser() async {
    if (state is User) {
      final failureOrSuccess = await logout.call(stateAsUser.userType.userId());
      failureOrSuccess.fold(
        (failure) {
          // TODO: Logout failure
        },
        (success) {
          // After succesfully logging out, now try reloading user data. This should
          // restart the user as a guest.
          loadUser(false);
        },
      );
    } else {
      print("error cant log out");
      // Can't log out. You're not a user.
      // TODO: Logout failure
    }
  }

  /// Load the user object if possible, otherwise emits an error state.
  ///
  /// [artificialDelay] delays execution for x time. Used for initial call as to not
  /// cause jank with the splash screen.
  ///
  /// Success: emits Guest or RegisteredUser.
  ///
  /// Error: emits UserError.
  Future<void> loadUser(bool artificialDelay) async {
    // If artificialDelay is true, then delay the execution marginally. Exists
    // so that the splash screen doesn't jank quickly on initial load.
    if (artificialDelay) await Future.delayed(const Duration(milliseconds: 750));
    (await loadRefreshToken.call(NoParams())).fold(
      (failure) {
        // Something went wrong getting the token.
        emit(UserError());
      },
      (token) async {
        // Token received.
        //
        // Where the user's preferences will be stored (if no token, then "guest" location, else, stored in their unique user ID location).
        String userStorageLocation = token is Token ? token.token() : guestDataStorageLocation;

        // Opening Hive preferences box (for local storage).
        await Hive.openBox(userStorageLocation + hiveUserPartition);
        (await appearance.get(AppearanceEnum.values, AppearanceEnum, userStorageLocation + hiveUserPartition)).fold(
          (failure) {
            // If there's a failure loading these prefs, abort with UserError state.

            emit(UserError());
          },
          (appearanceEnum) async {
            // Last bit of the loading preferences chain contains emits the actual full user object,
            // whether that be a Guest or a RegisteredUser.
            //
            // If user has a refresh token, then we must attempt to decrypt it, gaining
            // access to its inner userId
            if (token is Token) {
              print(token.token());
              // If refreshToken is of type "hasRefreshToken", then its "token" field won't be null.
              userIdFromJwt(token.token()).fold(
                (failure) {
                  // Failure decrypting user Id from token. Emit UserError state and abort.
                  print("JWT decrypting causing error");

                  emit(UserError());
                },
                (userId) {
                  // On succesfully decrypting token, emit a user object of type RegisteredUser.
                  emit(User(appearanceEnum: appearanceEnum, userType: RegisteredUser(userId, token.token())));
                },
              );
            } else {
              // Open the Hive box with this pref.
              await Hive.openBox(homeViewedScreenLocation);
              // Check the viewed viewedHomeScreen location to decide if routing -> home screen or -> open screen.
              (await homeViewed.get(HomeViewedEnum.values, HomeViewedEnum, homeViewedScreenLocation)).fold(
                (failure) {
                  // Failure checking if the user has already viewed the home screen. Emit UserError state and abort.
                  emit(UserError());
                },
                (homeViewedEnum) {
                  if (homeViewedEnum == HomeViewedEnum.yes) {
                    // The user has already viewed home, so we can assume they've gone through the
                    // open screen already. Hence, we can consider them a guest.
                    //
                    // If user doesn't have refresh token, then they're a Guest.
                    emit(User(appearanceEnum: appearanceEnum, userType: Guest()));
                  } else {
                    // The user has not yet seen the home screen. Thus, they must be new. So, we should
                    // show them the open screen.
                    emit(OpenUser());
                  }
                },
              );
            }
          },
        );
      },
    );
  }

  Future<void> setAppearance(AppearanceEnum appearanceEnum, BuildContext context) async {
    if (state is User) {
      emit((state as User).copyWith(appearanceEnum: appearanceEnum));
      (await appearance.set(appearanceEnum, AppearanceEnum, stateAsUser.userType.userId())).fold(
        (failure) {
          // TODO: Error setting appearance
        },
        (success) => null, // Do nothing, as setting updated succesfully.
      );
    } else {
      // TODO: Error setting appearance
    }
  }

  /// Sets the [HomeViewedEnum] to [HomeViewedEnum.yes] and then reloads the user.
  ///
  /// Should be called when you've progressed to the home screen (as guest or registered user).
  ///
  /// Prevents returning to the 'open' screen by default every time the app is opened.
  Future<void> setHomeViewedThenReloadUser(BuildContext context) async {
    await setHomeViewed(HomeViewedEnum.yes, context).then((value) => loadUser(false));
  }

  // Special case for setting a preference. Does not relate to user. Account agnostic as it records
  // if any account on the device has viewed the home screen.
  Future<void> setHomeViewed(HomeViewedEnum homeViewedEnum, BuildContext context) async {
    (await homeViewed.set(homeViewedEnum, HomeViewedEnum, homeViewedScreenLocation)).fold(
      (failure) {
        // TODO: Error setting home viewed
      },
      (success) => null, // Do nothing, as setting updated succesfully.
    );
  }
}
