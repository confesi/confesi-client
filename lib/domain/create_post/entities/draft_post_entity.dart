import 'package:equatable/equatable.dart';

class DraftPostEntity extends Equatable {
  final String title;
  final String body;
  final String? repliedPostId;
  final String? repliedPostTitle;
  final String? repliedPostBody;

  const DraftPostEntity({
    required this.repliedPostBody,
    required this.repliedPostTitle,
    required this.body,
    required this.repliedPostId,
    required this.title,
  });

  @override
  List<Object?> get props => [body, title, repliedPostId];
}
