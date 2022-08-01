import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/results/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/repositories/feed_repository_concrete.dart';
import '../entities/post.dart';

class Trending implements Usecase<List<Post>, NoParams> {
  final FeedRepository repository;

  Trending({required this.repository});

  @override
  Future<Either<Failure, List<Post>>> call(NoParams noParams) async {
    final posts = await repository.fetchTrending();
    return posts.fold(
      (failure) {
        print("..Failure");
        return Left(failure);
      },
      (posts) {
        print("..Success");
        return Right(posts);
      },
    );
  }
}
