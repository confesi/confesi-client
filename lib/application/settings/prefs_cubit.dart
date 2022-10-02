import 'package:Confessi/core/usecases/no_params.dart';
import 'package:Confessi/domain/settings/usecases/appearance.dart';
import 'package:Confessi/domain/settings/usecases/first_time.dart';
import 'package:Confessi/domain/settings/usecases/load_refresh_token.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../constants/enums_that_are_local_keys.dart';

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
    await Future.delayed(const Duration(milliseconds: 1000));
    await (await loadRefreshToken.call(NoParams())).fold(
      (failure) {
        emit(PrefsError());
      },
      (refreshTokenResults) async {
        (await appearance.get(AppearanceEnum.values, AppearanceEnum)).fold(
          (failure) {
            emit(PrefsError());
          },
          (appearanceEnum) {
            // At the last step in the chain, emit the full state, using the variables from each step.
            emit(PrefsLoaded(
                hasRefreshToken: refreshTokenResults == RefreshTokenEnum.doesntHaveOne ? false : true,
                appearanceEnum: appearanceEnum));
          },
        );
      },
    );
  }

  /// Set appearance.
  void setAppearance(AppearanceEnum appearanceEnum) async {
    emit(prefs.copyWith(appearanceEnum: appearanceEnum));
    (await appearance.set(appearanceEnum, AppearanceEnum)).fold(
      (failure) => null, // show error message... scaffold messenger?
      (success) => null, // do nothing
    );
  }
}
