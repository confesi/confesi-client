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
    required String commentCount,
    required int votes,
    required String createdDate,
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

  static String _facultyFormatter(String faculty) {
    switch (faculty) {
      case "LAW":
        return "law";
      case "ENGINEERING":
        return "engineering";
      case "FINE_ARTS":
        return "fine arts";
      case "COMPUTER_SCIENCE":
        return "computer science";
      case "BUSINESS":
        return "business";
      case "EDUCATION":
        return "education";
      case "MEDICAL":
        return "medical";
      case "HUMAN_AND_SOCIAL_DEVELOPMENT":
        return "human & social development";
      case "HUMANITIES":
        return "humanities";
      case "SCIENCE":
        return "science";
      case "SOCIAL_SCIENCES":
        return "social sciences";
      default:
        throw ServerException();
    }
  }

  static String _universityFormatter(String university) {
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

  static String _genreFormatter(String genre) {
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

  static String _formatDate(String dateISO) {
    DateTime postedDate = DateTime.parse(dateISO).toUtc();
    DateTime currentDate = DateTime.now().toUtc();
    Duration timeBetween = currentDate.difference(postedDate);
    if (timeBetween.inMinutes < 0) {
      return "error";
    } else if (timeBetween.inDays >= 365) {
      return "${(timeBetween.inDays / 365).floor()}y";
    } else if (timeBetween.inHours >= 48) {
      return "${timeBetween.inDays}d";
    } else if (timeBetween.inMinutes >= 60) {
      return "${timeBetween.inHours}h";
    } else if (timeBetween.inMinutes <= 3) {
      return "now";
    } else {
      return "${timeBetween.inMinutes}min";
    }
  }

  static bool isPlural(int number) => number == 1 ? false : true;

  static String _formatCommentCount(int commentCount) => isPlural(commentCount)
      ? '$commentCount comments'
      : '$commentCount comment';

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      university: _universityFormatter(json["university"]),
      genre: _genreFormatter(json["genre"]),
      year: json["year"] as int,
      faculty: _facultyFormatter(json["faculty"]),
      reports: json["reports"] as int,
      text: json["text"] as String,
      commentCount: _formatCommentCount(json["comment_count"]),
      votes: json["votes"] as int,
      createdDate: _formatDate(json["created_date"]),
      child: PostChildDataModel.fromJson(json["child_data"]),
    );
  }
}
