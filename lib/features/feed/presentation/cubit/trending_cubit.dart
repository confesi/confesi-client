import 'package:Confessi/core/usecases/usecase.dart';
import 'package:Confessi/features/feed/domain/usecases/trending.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

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
