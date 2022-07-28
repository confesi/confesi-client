import '../../domain/entities/post.dart';
import 'post_child_data.dart';

class PostModel extends Post {
  const PostModel({
    required String university,
    required String genre,
    required int year,
    required String faculty,
    required int reports,
    required String text,
    required int commentCount,
    required int votes,
    required DateTime createdDate,
    required PostChildDataModel child,
  }) : super(
          university: university,
          genre: genre,
          year: year,
          faculty: faculty,
          reports: reports,
          text: text,
          commentCount: commentCount,
          votes: votes,
          createdDate: createdDate,
          child: child,
        );

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      university: json["university"] as String,
      genre: json["genre"] as String,
      year: json["year"] as int,
      faculty: json["faculty"] as String,
      reports: json["reports"] as int,
      text: json["text"] as String,
      commentCount: json["comment_count"] as int,
      votes: json["votes"] as int,
      createdDate: DateTime.parse(json["created_date"]),
      child: PostChildDataModel.fromJson(json["child_data"]),
    );
  }
}
