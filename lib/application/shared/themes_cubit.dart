import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'themes_state.dart';

// TODO: in the future, save these settings to the device and/or the user's account?
class ThemesCubit extends Cubit<ThemesState> {
  ThemesCubit() : super(ThemeDataLoading());

  void setThemeDark() => emit(Dark());

  void setThemeLight() => emit(Light());

  void setThemeSystem() => emit(System());
}
