import 'dart:convert';

class Login {
  String username;
  String password;

  Login({required this.username, required this.password});

  toJson() => jsonEncode({
        "username": username,
        "password": password,
      });
}
