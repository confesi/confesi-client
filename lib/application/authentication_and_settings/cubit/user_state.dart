part of 'user_cubit.dart';

@immutable
abstract class UserState extends Equatable {
  @override
  List<Object?> get props => [];
}

class User extends UserState {
  final String refreshToken;
  final String userID;
  final AppearanceEnum appearanceEnum;
  final bool justRegistered;

  User({
    this.justRegistered = false,
    required this.refreshToken,
    required this.userID,
    required this.appearanceEnum,
  });

  User copyWith({
    String? refreshToken,
    String? userID,
    AppearanceEnum? appearanceEnum,
    bool? justRegistered,
  }) {
    return User(
        refreshToken: refreshToken ?? this.refreshToken,
        userID: userID ?? this.userID,
        appearanceEnum: appearanceEnum ?? this.appearanceEnum,
        justRegistered: justRegistered ?? this.justRegistered);
  }

  @override
  List<Object?> get props => [appearanceEnum]; //! Very intentionally not rebuilding based on preferences.
}

class NoUser extends UserState {}

class LocalDataError extends UserState {}
