import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'scaffold_shrinker_state.dart';

class ScaffoldShrinkerCubit extends Cubit<ScaffoldShrinkerState> {
  ScaffoldShrinkerCubit() : super(Enlarged());

  void setShrunk() => emit(Shrunk());

  void setExpanded() => emit(Enlarged());
}
