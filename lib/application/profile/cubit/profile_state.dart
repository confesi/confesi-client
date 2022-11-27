part of 'profile_cubit.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

// Profile is loading
class ProfileLoading extends ProfileState {}

// Profile has data
class ProfileData extends ProfileState {
  final String universityImgUrl;
  final StatTileEntity statTileEntity;
  final List<AchievementTileEntity> achievementTileEntities;
  final String universityAbbr;
  final String universityFullName;
  final String username;

  const ProfileData({
    required this.achievementTileEntities,
    required this.statTileEntity,
    required this.universityImgUrl,
    required this.universityAbbr,
    required this.universityFullName,
    required this.username,
  });

  @override
  List<Object> get props => [
        universityImgUrl,
        statTileEntity,
        achievementTileEntities,
        universityAbbr,
        universityFullName,
        username,
      ];
}

// Profile has some sort of error
class ProfileError extends ProfileState {
  final String message;

  const ProfileError({required this.message});

  @override
  List<Object> get props => [];
}
