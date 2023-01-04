import 'package:Confessi/domain/create_post/entities/draft_post_entity.dart';
import 'package:Confessi/domain/create_post/usecases/save_draft.dart';
import 'package:dartz/dartz.dart';

import '../../../core/results/failures.dart';
import '../../../core/results/successes.dart';

/// The interface for how the implementation of the draft repository should look.
abstract class IDraftPostRepository {
  Future<Either<Failure, Success>> saveDraftPost(SaveDraftPostParams saveDraftPostParams);
  Future<Either<Failure, List<DraftPostEntity>>> getDraftPosts(String userId);
  Future<Either<Failure, Success>> deleteDraftPost(String userId, int index);
}
