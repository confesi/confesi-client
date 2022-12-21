import 'package:Confessi/constants/authentication_and_settings/enums.dart';

import '../../../constants/authentication_and_settings/objects.dart';
import '../../../constants/local_storage_keys.dart';
import '../../../core/utils/tokens/user_id_from_jwt.dart';
import '../../../domain/authentication_and_settings/entities/refresh_token.dart';
import '../../../domain/authentication_and_settings/entities/user.dart';
import '../../../domain/authentication_and_settings/usecases/silent_authentication.dart';
import '../../../presentation/shared/overlays/notification_chip.dart';
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

// TODO: Ensure logging out erases storage as well

class UserCubit extends Cubit<UserState> {
  final Logout logout;
  final SilentAuthentication silentAuthentication;
  final Appearance appearance;
  final LoadRefreshToken loadRefreshToken;

  UserCubit(
      {required this.logout,
      required this.silentAuthentication,
      required this.appearance,
      required this.loadRefreshToken})
      : super(UnknownUser());

  bool get localDataLoaded => state is User;

  User get stateAsUser => state as User;

  /// Logs out the user. Upon error, currently does nothing, as the user will still be logged in.
  void logoutUser() async {
    final failureOrSuccess = await logout.call(stateAsUser.userID);
    failureOrSuccess.fold(
      (failure) {
        print("failure to log out...");
      }, // Do nothing upon failure to logout, as the user would still be logged in (hopefully)? Instead, upon pressing logout, check if the state didn't change, then if not, show an error dialog.
      (success) {
        emit(NoUser());
      },
    );
  }

  /// Load the user object if possible, otherwise throw an error.
  Future<void> loadUser() async {
    (await loadRefreshToken.call(NoParams())).fold(
      (failure) {
        // Something went wrong getting the token.
        emit(UserError());
      },
      (refreshToken) async {
        // Token received.
        //
        // Where the user's preferences will be stored (if no token, then "guest" location, else, stored in their unique user ID location).
        String userStorageLocation = refreshToken is Token ? refreshToken.token() : guestDataStorageLocation;

        // Opening Hive preferences box (for local storage).
        await Hive.openBox(userStorageLocation);
        (await appearance.get(AppearanceEnum.values, AppearanceEnum, userStorageLocation)).fold(
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
            if (refreshToken is Token) {
              // If refreshToken is of type "hasRefreshToken", then its "token" field won't be null.
              userIdFromJwt(refreshToken.token()).fold(
                (failure) {
                  // Failure decrypting user Id from token. Emit UserError state and abort.
                  emit(UserError());
                },
                (userId) {
                  // On succesfully decrypting token, emit a user object of type RegisteredUser.
                  emit(User(appearanceEnum: appearanceEnum, userType: RegisteredUser(userId, refreshToken.token())));
                },
              );
            } else {
              // If user doesn't have refresh token, then they're a Guest.
              emit(User(appearanceEnum: appearanceEnum, userType: Guest()));
            }
          },
        );
      },
    );
  }

  Future<void> setAppearance(AppearanceEnum appearanceEnum, BuildContext context) async {
    if (state is! User) {
      showNotificationChip(context, "Error saving appearance.");
      return;
    }
    emit((state as User).copyWith(appearanceEnum: appearanceEnum));
    (await appearance.set(appearanceEnum, AppearanceEnum, stateAsUser.userType.userId())).fold(
      (failure) => null, // show error message... scaffold messenger?
      (success) => null, // do nothing
    );
  }
}
