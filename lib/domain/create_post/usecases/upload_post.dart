import 'package:Confessi/core/results/failures.dart';
import 'package:Confessi/core/results/successes.dart';
import 'package:Confessi/core/usecases/single_usecase.dart';
import 'package:Confessi/data/create_post/repositories/create_post_repository_concrete.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../core/network/http_client.dart';

class UploadPost implements Usecase<Success, UploadPostParams> {
  final CreatePostRepository repository;
  final ApiClient api;

  UploadPost({required this.repository, required this.api});

  @override
  Future<Either<Failure, Success>> call(
      UploadPostParams uploadPostParams) async {
    final failureOrSuccess = await repository.uploadPost(
        uploadPostParams.title, uploadPostParams.body, uploadPostParams.id);
    return failureOrSuccess.fold(
      (failure) => Left(failure),
      (success) => Right(success),
    );
  }
}

class UploadPostParams extends Equatable {
  final String title;
  final String body;
  final String? id;

  const UploadPostParams(
      {required this.title, required this.body, required this.id});

  @override
  List<Object?> get props => [title, body, id];
}
