import 'package:Confessi/core/usecases/no_params.dart';
import 'package:Confessi/domain/settings/usecases/appearance.dart';
import 'package:Confessi/domain/settings/usecases/first_time.dart';
import 'package:Confessi/domain/settings/usecases/load_refresh_token.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../constants/enums_that_are_local_keys.dart';

part 'prefs_state.dart';

//! Inside the main app, it's safe to assume the state is "PrefsLoaded", as you're only allowed in the app with that state.

class PrefsCubit extends Cubit<PrefsState> {
  final Appearance appearance;
  final LoadRefreshToken loadRefreshToken;
  final FirstTime firstTime;

  PrefsCubit({
    required this.loadRefreshToken,
    required this.firstTime,
    required this.appearance,
  }) : super(PrefsLoading());

  /// DANGEROUS. Calls state assuming it's [PrefsLoaded].
  ///
  /// Used for simplicity. Helps keep UI code small.
  PrefsLoaded get prefs => state as PrefsLoaded;

  /// Is the current state [PrefsLoaded]?
  bool get isLoaded => state is PrefsLoaded;

  /// Get all prefs and refresh token.
  Future<void> loadInitialPrefsAndTokens() async {
    await Future.delayed(const Duration(milliseconds: 1200));
    await (await loadRefreshToken.call(NoParams())).fold(
      (failure) {
        emit(PrefsError());
      },
      (refreshTokenEnum) async {
        (await appearance.get(AppearanceEnum.values, AppearanceEnum)).fold(
          (failure) {
            emit(PrefsError());
          },
          (appearanceEnum) async {
            (await firstTime.get(FirstTimeEnum.values, FirstTimeEnum)).fold(
              (failure) {
                emit(PrefsError());
              },
              (firstTimeEnum) async {
                // At the last step in the chain, emit the full state, using the variables from each step.
                emit(PrefsLoaded(
                    refreshTokenEnum: refreshTokenEnum, appearanceEnum: appearanceEnum, firstTimeEnum: firstTimeEnum));
              },
            );
          },
        );
      },
    );
  }

  /// Set appearance.
  Future<void> setAppearance(AppearanceEnum appearanceEnum) async {
    emit(prefs.copyWith(appearanceEnum: appearanceEnum));
    (await appearance.set(appearanceEnum, AppearanceEnum)).fold(
      (failure) => null, // show error message... scaffold messenger?
      (success) => null, // do nothing
    );
  }

  /// Set appearance.
  Future<void> setFirstTime(FirstTimeEnum firstTimeEnum) async {
    emit(prefs.copyWith(firstTimeEnum: firstTimeEnum));
    (await firstTime.set(firstTimeEnum, FirstTimeEnum)).fold(
      (failure) => null, // show error message... scaffold messenger?
      (success) => null, // do nothing
    );
  }
}
