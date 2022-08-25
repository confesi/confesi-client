import 'package:Confessi/domain/feed/entities/post.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'hottest_state.dart';

class HottestCubit extends Cubit<HottestState> {
  HottestCubit() : super(Loading());
}
