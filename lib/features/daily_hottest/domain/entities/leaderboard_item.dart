import 'package:equatable/equatable.dart';

class LeaderboardItem extends Equatable {
  @override
  List<Object?> get props => [];

  final String universityName;
  final int placing;
  final int points;

  const LeaderboardItem({
    required this.placing,
    required this.points,
    required this.universityName,
  });
}
