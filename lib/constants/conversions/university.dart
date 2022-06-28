String formatUniversity(String university) {
  switch (university) {
    case "UVIC":
      return "UVic";
    case "UBC":
      return "UBC";
    case "SFU":
      return "SFU";
    default:
      return "error";
  }
}
