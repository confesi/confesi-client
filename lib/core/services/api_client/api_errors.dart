import 'dart:convert';

import 'package:confesi/core/types/data.dart';
import 'package:dartz/dartz.dart';
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

  static Either<int, Empty> errCode(Response response) {
    try {
      final Either<int, Empty> val = Left(jsonDecode(response.body)['error_code'] as int);
      print(val);
      return val;
    } catch (_) {
      return Right(Empty());
    }
  }
}
