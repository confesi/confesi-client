import 'package:dartz/dartz.dart';

import '../../../../core/results/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/repositories/feed_repository_concrete.dart';
import '../entities/post.dart';

class Recents implements Usecase<List<Post>, String> {
  final FeedRepository repository;

  Recents({required this.repository});

  @override
  Future<Either<Failure, List<Post>>> call(String lastSeenPostId) async {
    final posts = await repository.fetchRecents(lastSeenPostId);
    return posts.fold(
      (failure) => Left(failure),
      (posts) => Right(posts),
    );
  }
}
