import 'package:Confessi/core/usecases/no_params.dart';
import 'package:Confessi/domain/profile/entities/achievement_tile_entity.dart';
import 'package:Confessi/domain/profile/entities/stat_tile_entity.dart';
import 'package:Confessi/domain/profile/usecases/profile_data.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileDataUsecase profileData;

  ProfileCubit({required this.profileData}) : super(ProfileLoading());

  Future<void> loadProfile() async {
    emit(ProfileLoading());
    final failureOrData = await profileData.call(NoParams());
    failureOrData.fold(
      (failure) {
        emit(const ProfileError(message: "Generic error message for now...")); // TODO: have error mapping /utils
      },
      (data) {
        emit(
          ProfileData(
            achievementTileEntities: data.achievementTileEntities,
            statTileEntity: data.statTileEntity,
            universityImgUrl: data.universityImgUrl,
          ),
        );
      },
    );
  }

  Future<void> reloadProfile() async {
    final failureOrData = await profileData.call(NoParams());
    failureOrData.fold(
      (failure) {
        emit(const ProfileError(message: "Generic error message for now...")); // TODO: have error mapping /utils
      },
      (data) {
        emit(
          ProfileData(
            achievementTileEntities: data.achievementTileEntities,
            statTileEntity: data.statTileEntity,
            universityImgUrl: data.universityImgUrl,
          ),
        );
      },
    );
  }
}
