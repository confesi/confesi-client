import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'create_comment_state.dart';

class CreateCommentCubit extends Cubit<CreateCommentState> {
  CreateCommentCubit() : super(CreateCommentInitial());
}
