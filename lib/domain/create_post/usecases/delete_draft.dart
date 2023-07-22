import '../../../data/create_post/repositories/draft_repository_concrete.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../core/results/failures.dart';
import '../../../core/results/successes.dart';
import '../../../core/usecases/single_usecase.dart';

class DeleteDraftUsecase implements Usecase<Success, DeleteDraftParams> {
  final DraftPostRepository repository;

  DeleteDraftUsecase({required this.repository});

  @override
  Future<Either<Failure, Success>> call(DeleteDraftParams deleteDraftParams) async {
    final failureOrSuccess = await repository.deleteDraftPost(deleteDraftParams.userId, deleteDraftParams.index);
    return failureOrSuccess.fold(
      (failure) => Left(failure),
      (posts) => Right(posts),
    );
  }
}

class DeleteDraftParams extends Equatable {
  final String userId;
  final int index;

  const DeleteDraftParams({required this.index, required this.userId});

  @override
  List<Object?> get props => [userId, index];
}
