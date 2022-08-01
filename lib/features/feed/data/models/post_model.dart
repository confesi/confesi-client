import '../../../../core/results/exceptions.dart';
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

  static String facultyFormatter(String faculty) {
    switch (faculty) {
      case "LAW":
        return "Law";
      case "ENGINEERING":
        return "Engineering";
      case "FINE_ARTS":
        return "Fine arts";
      case "COMPUTER_SCIENCE":
        return "Computer science";
      case "BUSINESS":
        return "Business";
      case "EDUCATION":
        return "Education";
      case "MEDICAL":
        return "Medical";
      case "HUMAN_AND_SOCIAL_DEVELOPMENT":
        return "Human & Social Development";
      case "HUMANITIES":
        return "Humanities";
      case "SCIENCE":
        return "Science";
      case "SOCIAL_SCIENCES":
        return "Social sciences";
      default:
        throw ServerException();
    }
  }

  static String universityFormatter(String university) {
    switch (university) {
      case "UVIC":
        return "UVic";
      case "UBC":
        return "UBC";
      case "SFU":
        return "SFU";
      default:
        throw ServerException();
    }
  }

  static String genreFormatter(String genre) {
    switch (genre) {
      case "RELATIONSHIPS":
        return "Relationships";
      case "POLITICS":
        return "Politics";
      case "CLASSES":
        return "Classes";
      case "GENERAL":
        return "General";
      case "OPINIONS":
        return "Opinions";
      case "CONFESSIONS":
        return "Confessions";
      default:
        throw ServerException();
    }
  }

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      university: universityFormatter(json["university"]),
      genre: genreFormatter(json["genre"]),
      year: json["year"] as int,
      faculty: facultyFormatter(json["faculty"]),
      reports: json["reports"] as int,
      text: json["text"] as String,
      commentCount: json["comment_count"] as int,
      votes: json["votes"] as int,
      createdDate: DateTime.parse(json["created_date"]),
      child: PostChildDataModel.fromJson(json["child_data"]),
    );
  }
}
