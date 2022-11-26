import 'package:Confessi/domain/profile/entities/achievement_tile_entity.dart';
import 'package:Confessi/domain/profile/entities/stat_tile_entity.dart';

class ProfileEntity {
  final StatTileEntity statTileEntity;
  final List<AchievementTileEntity> achievementTileEntities;
  final String universityImgUrl;
  final String universityAbbreviation;
  final String universityFullName;
  final String username;

  const ProfileEntity({
    required this.username,
    required this.universityFullName,
    required this.universityAbbreviation,
    required this.statTileEntity,
    required this.achievementTileEntities,
    required this.universityImgUrl,
  });
}
