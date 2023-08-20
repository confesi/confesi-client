import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit() : super(NotificationsBase(msg: NotificationsNoMsg()));

  void clear() => emit(NotificationsBase(msg: NotificationsNoMsg()));
  void showErr(String message) => emit(NotificationsBase(msg: NotificationsErr(message)));
  void showSuccess(String message) => emit(NotificationsBase(msg: NotificationsSuccess(message)));
}
