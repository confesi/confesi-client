import '../../../core/results/exceptions.dart';

String universityNameConverter(String university) {
  switch (university) {
    case "UVIC":
      return "UVic";
    case "UBC":
      return "UBC";
    case "SFU":
      return "SFU";
    case "TWU":
      return "TWU";
    case "UFV":
      return "UFV";
    default:
      throw ServerException();
  }
}
