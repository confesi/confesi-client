part of 'quick_actions_cubit.dart';

abstract class QuickActionsState extends Equatable {
  const QuickActionsState();

  @override
  List<Object> get props => [];
}

abstract class QuickActionsPossibleErr {}

class QuickActionsErr extends QuickActionsPossibleErr {
  final String message;
  QuickActionsErr(this.message);
}

class QuickActionsNoErr extends QuickActionsPossibleErr {}

// cubit states

class QuickActionsDefault extends QuickActionsState {
  final QuickActionsPossibleErr possibleErr;
  const QuickActionsDefault(this.possibleErr);

  // get props implement
  @override
  List<Object> get props => [possibleErr];

  // copyWith method
  QuickActionsDefault copyWith({
    QuickActionsPossibleErr? possibleErr,
  }) {
    return QuickActionsDefault(
      possibleErr ?? this.possibleErr,
    );
  }
}
