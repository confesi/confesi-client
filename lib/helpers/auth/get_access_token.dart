import 'dart:convert';
import 'package:flutter_mobile_client/constants/general.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

Future<String> getAccessToken() async {
  try {
    // get token
    const storage = FlutterSecureStorage();
    // THIS LINE FOR TESTING - DELETE LATER
    await storage.write(
        key: "refreshToken",
        value:
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyTW9uZ29PYmplY3RJRCI6IjYyOTE5ZmIwYzg0YTFkNjc0ZGFjNzg4MyIsImlhdCI6MTY1Mzk4Mjk1OSwiZXhwIjoxNjg1NTQwNTU5fQ.ViRB_PQX_Jdp75rrJP2p1BNyBYHB8H8csnnD2PY4OZs");
    var refreshToken = await storage.read(key: "refreshToken");
    if (refreshToken == null) return "";
    final response = await http
        .post(
          Uri.parse('$kDomain/api/user/token'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            "token": refreshToken,
          }),
        )
        .timeout(const Duration(seconds: 10));
    if (response.statusCode != 200) {
      return "";
    } else {
      final accessToken = json.decode(response.body)["accessToken"];
      return accessToken;
    }
  } catch (error) {
    print("catch occured");
    return "";
  }
}
