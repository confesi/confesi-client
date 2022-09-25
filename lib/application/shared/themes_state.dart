part of 'themes_cubit.dart';

@immutable
abstract class ThemesState {}

class ThemeDataLoading extends ThemesState {}

class Dark extends ThemesState {}

class Light extends ThemesState {}

class System extends ThemesState {}
