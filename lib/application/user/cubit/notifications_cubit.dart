import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit() : super(NotificationsBase(err: NotificationsNoErr()));

  void show(String message) => emit(NotificationsBase(err: NotificationsErr(message)));
}
