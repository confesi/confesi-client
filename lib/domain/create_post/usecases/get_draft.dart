import 'package:Confessi/data/create_post/repositories/draft_repository_concrete.dart';
import 'package:Confessi/domain/create_post/entities/draft_post_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../core/results/failures.dart';
import '../../../core/usecases/single_usecase.dart';

class GetDraftUsecase implements Usecase<List<DraftPostEntity>, String> {
  final DraftPostRepository repository;

  GetDraftUsecase({required this.repository});

  @override
  Future<Either<Failure, List<DraftPostEntity>>> call(String userId) async {
    final failureOrSuccess = await repository.getDraftPosts(userId);
    return failureOrSuccess.fold(
      (failure) => Left(failure),
      (posts) => Right(posts),
    );
  }
}
