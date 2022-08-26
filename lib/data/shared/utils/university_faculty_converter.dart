import '../../../core/results/exceptions.dart';

String facultyConverter(String faculty) {
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
      return "Human & social development";
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
