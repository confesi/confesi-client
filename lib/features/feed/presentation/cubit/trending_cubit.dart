import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/trending.dart';

part 'trending_state.dart';

class TrendingCubit extends Cubit<TrendingState> {
  final Trending trending;
  TrendingCubit({required this.trending}) : super(InitialState());

  Future<void> fetchPosts() async {
    final failureOrPosts = await trending(NoParams());
    failureOrPosts.fold(
      (failure) => print(failure),
      (posts) => print(posts),
    );
  }
}
