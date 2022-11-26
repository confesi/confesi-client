import 'package:Confessi/data/profile/models/achievement_tile_model.dart';
import 'package:Confessi/data/profile/models/stat_tile_model.dart';
import 'package:Confessi/domain/profile/entities/profile_entity.dart';

import '../../../core/converters/university_abbr_to_full_name.dart';

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required StatTileModel statTileModel,
    required List<AchievementTileModel> achievementTileModels,
    required String universityImgUrl,
    required String universityAbbreviation,
    required String universityFullName,
    required String username,
  }) : super(
          username: username,
          universityFullName: universityFullName,
          statTileEntity: statTileModel,
          universityAbbreviation: universityAbbreviation,
          achievementTileEntities: achievementTileModels,
          universityImgUrl: universityImgUrl,
        );

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    List<AchievementTileModel> results = []; // List of [AchivementTileModel]s.
    if (json['achievements'] != null) {
      for (var i in (json['achievements'] as List<dynamic>)) {
        results.add(AchievementTileModel.fromJson(i));
      } // Loop through achivements, and add to list.
    }
    return ProfileModel(
      username: json['username'],
      universityFullName: universityAbbrToFullName(json['university_abbr']),
      universityAbbreviation: json['university_abbr'],
      statTileModel: StatTileModel.fromJson(json),
      achievementTileModels: results, // Return list constructed from the iterating over json['achievements']
      universityImgUrl: json['university_img_url'],
    );
  }
}
