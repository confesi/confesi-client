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

  const ProfileData(
      {required this.achievementTileEntities, required this.statTileEntity, required this.universityImgUrl});

  @override
  List<Object> get props => [universityImgUrl, statTileEntity, achievementTileEntities];
}

// Profile has some sort of error
class ProfileError extends ProfileState {
  final String message;

  const ProfileError({required this.message});

  @override
  List<Object> get props => [];
}
