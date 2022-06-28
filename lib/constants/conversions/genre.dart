String formatGenre(String genre) {
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
      return "Error";
  }
}
