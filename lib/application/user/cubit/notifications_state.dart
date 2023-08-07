part of 'notifications_cubit.dart';

abstract class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object> get props => [];
}

abstract class NotificationsPossibleMsg {}

class NotificationsErr extends NotificationsPossibleMsg {
  final String message;
  NotificationsErr(this.message);
}

class NotificationsSuccess extends NotificationsPossibleMsg {
  final String message;
  NotificationsSuccess(this.message);
}

class NotificationsNoMsg extends NotificationsPossibleMsg {}

class NotificationsBase extends NotificationsState {
  final NotificationsPossibleMsg msg;
  const NotificationsBase({required this.msg});

  NotificationsBase copyWith({
    NotificationsPossibleMsg? msg,
  }) {
    return NotificationsBase(
      msg: msg ?? this.msg,
    );
  }

  // override == to always be false
  @override
  bool operator ==(Object other) => false;

  @override
  List<Object> get props => [msg];
}
