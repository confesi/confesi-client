part of 'auth_flow_cubit.dart';

abstract class AuthFlowState extends Equatable {
  const AuthFlowState();

  @override
  List<Object> get props => [];
}

class AuthFlowDefault extends AuthFlowState {}

class AuthFlowNotification extends AuthFlowState {
  final String message;
  final NotificationType type;

  const AuthFlowNotification(this.message, this.type);

  // ovverride equality so that all notifications are different
  @override
  bool operator ==(Object other) => false;

  @override
  List<Object> get props => [message, type];
}

class AuthFlowLoading extends AuthFlowState {}
