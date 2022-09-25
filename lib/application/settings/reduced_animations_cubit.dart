import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'reduced_animations_state.dart';

class ReducedAnimationsCubit extends Cubit<ReducedAnimationsState> {
  ReducedAnimationsCubit() : super(ReducedAnimationsInitial());
}
