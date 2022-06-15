enum LoginType { username, email }

LoginType usernameOrEmail(String text) {
  if (text.contains("@")) {
    return LoginType.email;
  } else {
    return LoginType.username;
  }
}
