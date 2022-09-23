import '../../../core/results/exceptions.dart';

String imagePathConverter(String university) {
  switch (university) {
    case "UVIC":
      return "assets/images/universities/uvic.jpeg";
    case "UBC":
      return "assets/images/universities/ubc.jpeg";
    case "SFU":
      return "assets/images/universities/sfu.jpeg";
    case "TWU":
      return "assets/images/universities/twu.jpeg";
    case "UFV":
      return "assets/images/universities/ufv.jpeg";
    default:
      throw ServerException();
  }
}
