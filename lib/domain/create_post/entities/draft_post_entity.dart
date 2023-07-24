import 'package:equatable/equatable.dart';

class DraftPostEntity extends Equatable {
  final String title;
  final String body;

  const DraftPostEntity({
    required this.body,
    required this.title,
  });

  @override
  List<Object?> get props => [body, title];
}
