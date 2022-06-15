import 'dart:convert';

class EmailLogin {
  String email;
  String password;

  EmailLogin({required this.email, required this.password});

  toJson() => jsonEncode(
        {
          "email": email,
          "password": password,
        },
      );
}
