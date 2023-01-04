part of 'user_cubit.dart';

@immutable
abstract class UserState extends Equatable {
  @override
  List<Object?> get props => [];
}

/// There is currently a user, whether that be a [Guest] or a [RegisteredUser].
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
  List<Object?> get props => [userType, appearanceEnum];
}

/// Error retrieving critical information to create a user.
///
/// This indicates an error page should be shown.
class UserError extends UserState {}

/// If the state of the user is currently a new user who has not yet seen the home screen.
/// Meaning, they should see the open screen by default.
class OpenUser extends UserState {}

/// Unknown user state. Currently loading. Provided as default.
class UserLoading extends UserState {}
