List<String> linksFromText(String input) {
  List<String> links = [];
  RegExp exp = RegExp(
    r"(?:(?:https?|ftp):\/\/)?([\w/\-?=%.]+\.[\w/\-?=%.]+)",
    caseSensitive: false,
    multiLine: false,
  );
  Iterable<RegExpMatch> matches = exp.allMatches(input);
  for (RegExpMatch match in matches) {
    links.add(match.group(1)!); // Use group(1) to capture only the domain part
  }
  return links.toSet().toList();
}
