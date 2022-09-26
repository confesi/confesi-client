import 'package:Confessi/core/usecases/usecase.dart';
import 'package:Confessi/domain/settings/usecases/load_pref.dart';
import 'package:Confessi/domain/settings/usecases/set_pref.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../constants/settings/enums.dart';

part 'prefs_state.dart';

class PrefsCubit extends Cubit<PrefsState> {
  final LoadPrefs loadPrefs;
  final SetPref setPref;

  PrefsCubit({required this.loadPrefs, required this.setPref})
      : super(PrefsLoading());

  void loadUserPrefs() async {
    final failureOrPrefs = await loadPrefs.call(NoParams());
  }
}
