part of 'auth_flow_cubit.dart';

abstract class EnteringMode extends Equatable {
  const EnteringMode();
}

class EnteringError extends EnteringMode {
  final String message;

  const EnteringError(this.message);

  @override
  List<Object?> get props => [message];
}

class EnteringRegular extends EnteringMode {
  const EnteringRegular();

  @override
  List<Object?> get props => [];
}

class EnteringLoading extends EnteringMode {
  const EnteringLoading();
  @override
  List<Object?> get props => [];
}

abstract class AuthFlowState extends Equatable {
  const AuthFlowState();

  @override
  List<Object> get props => [];
}

class AuthFlowEnteringData extends AuthFlowState {
  final String email;
  final String password;
  final EnteringMode mode;

  const AuthFlowEnteringData({
    this.email = "",
    this.password = "",
    this.mode = const EnteringRegular(),
  });

  // override object equality to always be false if and only if email and password aren't the same
  @override
  bool operator ==(Object other) => other is AuthFlowEnteringData && other.email == email && other.password == password;

  @override
  List<Object> get props => [email, password, mode];

  AuthFlowEnteringData copyWith({
    String? email,
    String? password,
    EnteringMode? mode,
  }) {
    return AuthFlowEnteringData(
      email: email ?? this.email,
      password: password ?? this.password,
      mode: mode ?? this.mode,
    );
  }
}
