import 'package:Confessi/core/results/failures.dart';
import 'package:Confessi/core/usecases/usecase.dart';
import 'package:Confessi/features/feed/data/repositories/feed_repository_concrete.dart';
import 'package:Confessi/features/feed/domain/entities/post.dart';
import 'package:dartz/dartz.dart';

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
