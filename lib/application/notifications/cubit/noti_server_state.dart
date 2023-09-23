part of 'noti_server_cubit.dart';

enum NotiServerFeedState { feedLoading, errorLoadingMore, noMore }

sealed class NotiServerState extends Equatable {
  const NotiServerState();

  @override
  List<Object> get props => [];
}

final class NotiServerLoading extends NotiServerState {}

final class NotiServerError extends NotiServerState {
  final String message;

  const NotiServerError({required this.message});
}

final class NotiServerData extends NotiServerState {
  final List<EncryptedId> notificationIds;
  final NotiServerFeedState feedState;
  final int? next;

  const NotiServerData(this.notificationIds, this.feedState, this.next);

  void setNext(int? next) => NotiServerData(notificationIds, feedState, next);

  // copyWith method
  NotiServerData copyWith({
    List<EncryptedId>? notificationIds,
    NotiServerFeedState? feedState,
    int? next,
  }) {
    return NotiServerData(
      notificationIds ?? this.notificationIds,
      feedState ?? this.feedState,
      next ?? this.next,
    );
  }
}
