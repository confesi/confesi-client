import '../../../core/results/exceptions.dart';

String universityFullNameConverter(String university) {
  switch (university) {
    case "UVIC":
      return "University of Victoria";
    case "UBC":
      return "University of British Columbia";
    case "SFU":
      return "Simon Fraser University";
    case "TWU":
      return "Trinity Western University";
    case "UFV":
      return "University of the Fraser Valley";
    default:
      throw ServerException();
  }
}
