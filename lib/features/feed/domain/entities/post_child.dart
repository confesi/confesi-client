import 'package:Confessi/features/feed/domain/entities/post.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/post_child_data.dart';

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
