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
  final FirstTimeEnum firstTimeEnum;

  User({
    required this.refreshToken,
    required this.userID,
    required this.firstTimeEnum,
    required this.appearanceEnum,
  });

  User copyWith({
    String? refreshToken,
    String? userID,
    AppearanceEnum? appearanceEnum,
    FirstTimeEnum? firstTimeEnum,
  }) {
    return User(
      refreshToken: refreshToken ?? this.refreshToken,
      userID: userID ?? this.userID,
      appearanceEnum: appearanceEnum ?? this.appearanceEnum,
      firstTimeEnum: firstTimeEnum ?? this.firstTimeEnum,
    );
  }

  @override
  List<Object?> get props => []; //! Very intentionally not rebuilding based on preferences.
}

class NoUser extends UserState {}

class LocalDataError extends UserState {}
