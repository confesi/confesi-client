import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'daily_hottest_state.dart';

class DailyHottestCubit extends Cubit<DailyHottestState> {
  DailyHottestCubit() : super(DailyHottestInitial());
}
