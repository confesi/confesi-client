import 'dart:convert';

class UsernameLogin {
  String username;
  String password;

  UsernameLogin({required this.username, required this.password});

  toJson() => jsonEncode(
        {
          "username": username,
          "password": password,
        },
      );
}
