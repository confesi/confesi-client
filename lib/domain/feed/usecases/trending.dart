import 'package:dartz/dartz.dart';

import '../../../core/results/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../../data/feed/repositories/feed_repository_concrete.dart';
import '../entities/post.dart';

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
