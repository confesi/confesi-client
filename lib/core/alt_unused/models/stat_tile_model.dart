// import '../../../domain/profile/entities/stat_tile_entity.dart';

// class StatTileModel extends StatTileEntity {
//   const StatTileModel({
//     required double topDislikesPercentage,
//     required double topHottestsPercentage,
//     required double topLikesPercentage,
//     required int totalDislikes,
//     required int totalHottests,
//     required int totalLikes,
//   }) : super(
//           topDislikesPercentage: topDislikesPercentage,
//           topHottestsPercentage: topHottestsPercentage,
//           topLikesPercentage: topLikesPercentage,
//           totalDislikes: totalDislikes,
//           totalLikes: totalLikes,
//           totalHottests: totalHottests,
//         );

//   factory StatTileModel.fromJson(Map<String, dynamic> json) {
//     return StatTileModel(
//       topDislikesPercentage: json['dislikes']['top_percent'] as double,
//       topLikesPercentage: json['likes']['top_percent'] as double,
//       topHottestsPercentage: json['hottests']['top_percent'] as double,
//       totalDislikes: json['dislikes']['total'] as int,
//       totalLikes: json['likes']['total'] as int,
//       totalHottests: json['hottests']['total'] as int,
//     );
//   }
// }
