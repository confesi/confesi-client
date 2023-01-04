class LeaderboardItem {
  final String universityName;
  final int placing;
  final int points;
  final String universityImagePath;
  final String universityFullName;

  const LeaderboardItem({
    required this.universityFullName,
    required this.universityImagePath,
    required this.placing,
    required this.points,
    required this.universityName,
  });
}
