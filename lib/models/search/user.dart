class User {
  final String username;
  final String displayName;

  User(this.username, this.displayName);

  User.fromJson(Map<String, dynamic> json)
      : username = json["username"],
        displayName = json["display_name"];
}
