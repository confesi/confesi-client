import '../results/exceptions.dart';

String universityAbbrToFullName(String abbr) {
  String abbrLowercase = abbr.toLowerCase();
  switch (abbrLowercase) {
    case "uvic":
      return "University of Victoria";
    case "ubc":
      return "University of British Columbia";
    default:
      throw ConversionException();
  }
}
