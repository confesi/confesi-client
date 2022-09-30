import 'package:Confessi/domain/settings/usecases/appearance.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../constants/enums_that_are_local_keys.dart';

part 'prefs_state.dart';

//! Inside the main app, it's safe to assume the state is "PrefsLoaded", as you're only allowed in the app with that state.

class PrefsCubit extends Cubit<PrefsState> {
  final Appearance appearance;

  PrefsCubit({required this.appearance}) : super(PrefsLoading());

  /// DANGEROUS. Calls state assuming it's [PrefsLoaded].
  ///
  /// Used for simplicity. Helps keep UI code small.
  PrefsLoaded get prefs => state as PrefsLoaded;

  /// Is the current state [PrefsLoaded]?
  bool get isLoaded => state is PrefsLoaded;

  /// Get all prefs.
  Future<PrefsState> loadInitialPrefs() async {
    return (await appearance.get(AppearanceEnum.values, AppearanceEnum)).fold(
      (failure) {
        emit(PrefsError());
        return state;
      },
      (appearance) {
        emit(PrefsLoaded(appearanceEnum: appearance));
        return state;
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
    print('state: $state');
  }

  // TODO: Do I need to get it? Or just reference the state if it's PrefsLoaded?
  void loadAppearance() async {
    await appearance.get(AppearanceEnum.values, AppearanceEnum);
  }

  //! Reduced animation prefs.
  void setReducedAnimations() async {}

  void loadReducedAnimations() async {}
}
