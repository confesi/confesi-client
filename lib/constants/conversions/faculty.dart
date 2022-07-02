String formatFaculty(String faculty) {
  switch (faculty) {
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
    case "LAW":
      return "law";
    case "OTHER":
      return "other";
    default:
      return "error";
  }
}
