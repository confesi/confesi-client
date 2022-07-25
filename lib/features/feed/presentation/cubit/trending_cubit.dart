import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'trending_state.dart';

class TrendingCubit extends Cubit<TrendingState> {
  TrendingCubit() : super(TrendingInitial());
}
