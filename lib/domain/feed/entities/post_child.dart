import 'package:Confessi/domain/shared/entities/post.dart';
import 'package:equatable/equatable.dart';

import '../../../core/constants/feed/constants.dart';

class PostChild extends Equatable {
  final ChildType childType;
  final String? childId;
  final Post? childPost;

  const PostChild({
    required this.childId,
    required this.childPost,
    required this.childType,
  });

  @override
  List<Object?> get props => [childType, childId, childPost];
}
