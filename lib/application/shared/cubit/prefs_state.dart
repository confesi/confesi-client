// part of 'prefs_cubit.dart';

// abstract class PrefsState extends Equatable {
//   @override
//   List<Object?> get props => [];
// }

// class PrefsLoading extends PrefsState {}

// class PrefsLoaded extends PrefsState {
//   final AppearanceEnum appearanceEnum;
//   final RefreshTokenEnum refreshTokenEnum;
//   final FirstTimeEnum firstTimeEnum;

//   PrefsLoaded({
//     required this.firstTimeEnum,
//     required this.refreshTokenEnum,
//     required this.appearanceEnum,
//   });

//   PrefsLoaded copyWith({
//     AppearanceEnum? appearanceEnum,
//     RefreshTokenEnum? refreshTokenEnum,
//     FirstTimeEnum? firstTimeEnum,
//   }) {
//     return PrefsLoaded(
//       refreshTokenEnum: refreshTokenEnum ?? this.refreshTokenEnum,
//       appearanceEnum: appearanceEnum ?? this.appearanceEnum,
//       firstTimeEnum: firstTimeEnum ?? this.firstTimeEnum,
//     );
//   }

//   @override
//   List<Object?> get props => [appearanceEnum, firstTimeEnum, appearanceEnum];
// }

// class PrefsError extends PrefsState {}
