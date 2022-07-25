import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'recents_state.dart';

class RecentsCubit extends Cubit<RecentsState> {
  RecentsCubit() : super(RecentsInitial());
}
