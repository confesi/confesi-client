import 'package:Confessi/core/results/failures.dart';
import 'package:Confessi/core/results/successes.dart';
import 'package:Confessi/domain/create_post/usecases/upload_post.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'post_state.dart';

class CreatePostCubit extends Cubit<CreatePostState> {
  final UploadPost uploadPost;

  CreatePostCubit({required this.uploadPost}) : super(EnteringData());

  Future<Either<Failure, Success>> uploadUserPost(
      String title, String body, String? id) async {
    emit(Loading());
    final failureOrSuccess = await uploadPost
        .call(UploadPostParams(title: title, body: body, id: id));
    return failureOrSuccess.fold(
      (failure) {
        print('failure!!');
        emit(EnteringData()); // TODO; flag akin to success - but for failure
        return Left(failure);
      },
      (success) {
        print('success!!');
        emit(
            SuccessfullySubmitted()); // TODO: make some kind of "success" flag, or just return result from function and then operate on that? Or is that breaking SOC?
        return Right(success);
      },
    );
  }
}
