import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeDataLoading());

  int getThemeNumericRepresentation() {
    switch (state.runtimeType) {
      case ClassicTheme:
        return 0;
      case ElegantTheme:
        return 1;
      case SalmonTheme:
        return 2;
      case SciFiTheme:
        return 3;
      default:
        return 0;
    }
  }

  void setThemeClassic() => emit(ClassicTheme());

  void setThemeElegant() => emit(ElegantTheme());

  void setThemeSalmon() => emit(SalmonTheme());

  void setThemeSciFi() => emit(SciFiTheme());
}
