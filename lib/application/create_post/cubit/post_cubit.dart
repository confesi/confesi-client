import 'package:confesi/core/clients/api.dart';

import '../../../core/utils/validators/either_not_empty_validator.dart';
import '../../../domain/create_post/usecases/upload_post.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'post_state.dart';

class CreatePostCubit extends Cubit<CreatePostState> {
  final UploadPost uploadPost;

  CreatePostCubit({required this.uploadPost}) : super(EnteringData());

  Future<void> uploadUserPost(String title, String body, String category) async {
    emit(PostLoading());
    return eitherNotEmptyValidator(title, body).fold(
      (failure) => emit(PostError(message: "Can't submit empty post")),
      (_) async {
        (await Api().req(
          Method.post,
          true,
          "/api/v1/posts/create",
          {
            "title": title,
            "body": body,
            "category": category,
          },
        ))
            .fold(
          (failure) => emit(PostError(message: failure.message())),
          (response) {
            if (response.statusCode.toString()[0] == "2") {
              emit(PostSuccessfullySubmitted());
            } else {
              // todo: fill in the appropriate error message
              emit(PostError(message: response.body));
            }
          },
        );
      },
    );
  }
}
