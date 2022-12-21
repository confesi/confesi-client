part of 'user_cubit.dart';

@immutable
abstract class UserState extends Equatable {
  @override
  List<Object?> get props => [];
}

class User extends UserState {
  final UserType userType;
  final AppearanceEnum appearanceEnum;

  User({
    required this.appearanceEnum,
    required this.userType,
  });

  User copyWith({
    AppearanceEnum? appearanceEnum,
    UserType? userType,
    bool? hasViewedPastOpenScreenAlready,
  }) {
    return User(
      appearanceEnum: appearanceEnum ?? this.appearanceEnum,
      userType: userType ?? this.userType,
    );
  }

  @override
  List<Object?> get props => []; //! Very intentionally not rebuilding based on preferences.
}

/// Error retrieving critical information to create a user.
///
/// This indicates an error page should be shown.
class UserError extends UserState {}

/// If the state of the user is currently unknown.
///
/// Provided as the initial state. Also the state if the user has not yet viewed past the open screen.
class UnknownUser extends UserState {}
