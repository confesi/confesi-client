part of 'room_requests_cubit.dart';

sealed class RoomRequestsState extends Equatable {
  const RoomRequestsState();

  @override
  List<Object> get props => [];
}

final class RoomRequestsLoading extends RoomRequestsState {}

final class RoomRequestsError extends RoomRequestsState {
  final String error;

  const RoomRequestsError(this.error);
}

final class RoomRequestsData extends RoomRequestsState {
  final bool allowsRequests;

  const RoomRequestsData(this.allowsRequests);

  // equatable
  @override
  List<Object> get props => [allowsRequests];
}
