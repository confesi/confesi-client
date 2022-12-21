/// The type that the user is when viewing the app.
///
/// Can be [guest] or [registeredUser].
///
/// [guest] has a null [userId], while [registeredUser] has a valid [userId].
enum UserType {
  guest(),
  registeredUser(userId: "123");

  const UserType({this.userId});

  final String? userId;
}
