import 'package:Confessi/domain/settings/usecases/appearance.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../constants/enums_that_are_local_keys.dart';

part 'prefs_state.dart';

class PrefsCubit extends Cubit<PrefsState> {
  final Appearance appearance;

  PrefsCubit({required this.appearance}) : super(PrefsLoading());

  //! All prefs.
  void loadAllPrefs() async {
    print(await appearance.set(AppearanceEnum.light));
    print(await appearance.get(AppearanceEnum.dark));
  }

  //! Appearance prefs.
  void setAppearance() async {}

  void loadAppearance() async {}

  //! Reduced animation prefs.
  void setReducedAnimations() async {}

  void loadReducedAnimations() async {}
}
