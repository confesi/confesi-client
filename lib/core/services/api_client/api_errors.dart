import 'dart:convert';

import 'package:http/http.dart';

class ApiErrors {
  static String err(Response response) {
    try {
      final err = jsonDecode(response.body)['error'];
      if (err == null) return "Server error";
      return err;
    } catch (_) {
      return "Unknown client error";
    }
  }
}
