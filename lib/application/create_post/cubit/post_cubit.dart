import 'package:flutter/rendering.dart';

import '../../../core/utils/validators/either_not_empty_validator.dart';
import '../../../domain/create_post/usecases/upload_post.dart';
import '../../../presentation/create_post/utils/failure_to_message.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'post_state.dart';

class CreatePostCubit extends Cubit<CreatePostState> {
  final UploadPost uploadPost;

  CreatePostCubit({required this.uploadPost}) : super(EnteringData());

  Future<void> uploadUserPost(String title, String body, String? id) async {
    emit(Loading());
    return eitherNotEmptyValidator(title, body).fold(
      (failure) {
        emit(Error(message: failureToMessage(failure)));
      },
      (_) async {
        final failureOrSuccess = await uploadPost.call(UploadPostParams(title: title, body: body, id: id));
        failureOrSuccess.fold(
          (failure) {
            emit(Error(message: failureToMessage(failure)));
          },
          (success) {
            emit(SuccessfullySubmitted());
          },
        );
      },
    );
  }
}
