import 'package:Confessi/core/results/failures.dart';
import 'package:Confessi/core/results/successes.dart';
import 'package:Confessi/domain/create_post/usecases/upload_post.dart';
import 'package:Confessi/presentation/create_post/utils/failure_to_message.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../shared/utils/empty_validator.dart';

part 'post_state.dart';

class CreatePostCubit extends Cubit<CreatePostState> {
  final UploadPost uploadPost;

  CreatePostCubit({required this.uploadPost}) : super(EnteringData());

  Future<void> uploadUserPost(String title, String body, String? id) async {
    return emptyValidator(body).fold(
      (failure) {
        emit(Error(message: failureToMessage(failure)));
      },
      (body) async {
        emit(Loading());
        final failureOrSuccess = await uploadPost
            .call(UploadPostParams(title: title, body: body, id: id));
        failureOrSuccess.fold(
          (failure) {
            emit(Error(message: failureToMessage(failure)));
          },
          (success) {
            emit(
                SuccessfullySubmitted()); // TODO: make some kind of "success" flag, or just return result from function and then operate on that? Or is that breaking SOC?
          },
        );
      },
    );
  }
}
