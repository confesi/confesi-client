import '../../constants/conversions/genre.dart';
import '../../constants/conversions/university.dart';

class Highlight {
  final String university;
  final String genre;

  Highlight(this.genre, this.university);

  Highlight.fromJson(Map<String, dynamic> json)
      : university = formatUniversity(json["university"]),
        genre = formatGenre(json["genre"]);
}
