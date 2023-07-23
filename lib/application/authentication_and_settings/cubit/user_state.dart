part of 'user_cubit.dart';

@immutable
abstract class UserState extends Equatable {
  @override
  List<Object?> get props => [];
}

/// There is currently a user, whether that be a [Guest] or a [RegisteredUser].
class SomeUser extends UserState {
  final UserType userType;
  final AppearanceEnum appearanceEnum;
  final TextSizeEnum textSizeEnum;
  final ShakeForFeedbackEnum shakeForFeedbackEnum;
  final HomeViewedEnum homeViewedEnum;
  final CurvyEnum curvyEnum;

  SomeUser({
    required this.curvyEnum,
    required this.textSizeEnum,
    required this.appearanceEnum,
    required this.shakeForFeedbackEnum,
    required this.homeViewedEnum,
    required this.userType,
  });

  SomeUser copyWith({
    CurvyEnum? curvyEnum,
    HomeViewedEnum? homeViewedEnum,
    AppearanceEnum? appearanceEnum,
    TextSizeEnum? textSizeEnum,
    ShakeForFeedbackEnum? shakeForFeedbackEnum,
    UserType? userType,
    bool? hasViewedPastOpenScreenAlready,
  }) {
    return SomeUser(
      curvyEnum: curvyEnum ?? this.curvyEnum,
      homeViewedEnum: homeViewedEnum ?? this.homeViewedEnum,
      shakeForFeedbackEnum: shakeForFeedbackEnum ?? this.shakeForFeedbackEnum,
      textSizeEnum: textSizeEnum ?? this.textSizeEnum,
      appearanceEnum: appearanceEnum ?? this.appearanceEnum,
      userType: userType ?? this.userType,
    );
  }

  @override
  List<Object?> get props => [userType, appearanceEnum, textSizeEnum, shakeForFeedbackEnum, homeViewedEnum, curvyEnum];
}

/// Error retrieving critical information to create a user.
///
/// This indicates an error page should be shown.
class UserError extends UserState {}

/// Unknown user state. Currently loading. Provided as default.
class UserLoading extends UserState {}
