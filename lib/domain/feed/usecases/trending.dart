import 'package:dartz/dartz.dart';

import '../../../core/results/failures.dart';
import '../../../core/usecases/no_params.dart';
import '../../../core/usecases/single_usecase.dart';
import '../../../data/feed/repositories/feed_repository_concrete.dart';
import '../../shared/entities/post.dart';

class Trending implements Usecase<List<Post>, NoParams> {
  final FeedRepository repository;

  Trending({required this.repository});

  @override
  Future<Either<Failure, List<Post>>> call(NoParams noParams) async {
    final posts = await repository.fetchTrending('TEMP', 'TEMP');
    return posts.fold(
      (failure) {
        return Left(failure);
      },
      (posts) => Right(posts),
    );
  }
}
