import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../core/results/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../../data/feed/repositories/feed_repository_concrete.dart';
import '../../shared/entities/post.dart';

class Recents implements Usecase<List<Post>, RecentsParams> {
  final FeedRepository repository;

  Recents({required this.repository});

  @override
  Future<Either<Failure, List<Post>>> call(RecentsParams recentsParams) async {
    final posts = await repository.fetchRecents(recentsParams.lastSeenPostId, recentsParams.token);
    return posts.fold(
      (failure) => Left(failure),
      (posts) => Right(posts),
    );
  }
}

class RecentsParams extends Equatable {
  final String lastSeenPostId;
  final String token;

  const RecentsParams({required this.lastSeenPostId, required this.token});

  @override
  List<Object?> get props => [lastSeenPostId, token];
}
