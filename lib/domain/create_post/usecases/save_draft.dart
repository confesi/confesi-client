import 'package:Confessi/data/create_post/repositories/draft_repository_concrete.dart';
import 'package:Confessi/domain/create_post/entities/draft_post_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../core/results/failures.dart';
import '../../../core/results/successes.dart';
import '../../../core/usecases/single_usecase.dart';

class SaveDraftUsecase implements Usecase<Success, SaveDraftPostParams> {
  final DraftPostRepository repository;

  SaveDraftUsecase({required this.repository});

  @override
  Future<Either<Failure, Success>> call(SaveDraftPostParams saveDraftPostParams) async {
    final failureOrSuccess = await repository.saveDraftPost(saveDraftPostParams);
    return failureOrSuccess.fold(
      (failure) => Left(failure),
      (success) => Right(success),
    );
  }
}

class SaveDraftPostParams extends Equatable {
  final DraftPostEntity draftPostEntity;
  final String userId;

  const SaveDraftPostParams({required this.draftPostEntity, required this.userId});

  @override
  List<Object?> get props => [draftPostEntity, userId];
}
