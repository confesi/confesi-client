part of 'notifications_cubit.dart';

abstract class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object> get props => [];
}

abstract class NotificationsPossibleErr {}

class NotificationsErr extends NotificationsPossibleErr {
  final String message;
  NotificationsErr(this.message);
}

class NotificationsNoErr extends NotificationsPossibleErr {}

class NotificationsBase extends NotificationsState {
  final NotificationsPossibleErr err;
  const NotificationsBase({required this.err});

  NotificationsBase copyWith({
    NotificationsPossibleErr? err,
  }) {
    return NotificationsBase(
      err: err ?? this.err,
    );
  }

  // override == to always be false
  @override
  bool operator ==(Object other) => false;

  @override
  List<Object> get props => [err];
}
