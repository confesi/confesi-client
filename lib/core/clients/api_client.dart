import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

/// The different RESTful API verbs.
enum Method {
  post,
  get,
  patch,
  put,
  delete,
}

class ApiClient {
  final FlutterSecureStorage secureStorage;
  final Map<String, String> _headers = <String, String>{};
  final Duration _timeout = const Duration(seconds: 3);

  ApiClient({required this.secureStorage});

  Future<Response> call(Method method, String url, dynamic body) async {
    late Response response;
    switch (method) {
      case Method.post:
        response = await http.post(Uri.parse(url), body: body, headers: _headers).timeout(_timeout);
        break;
      case Method.get:
        response = await http.get(Uri.parse(url), headers: _headers).timeout(_timeout);
        break;
      case Method.delete:
        response = await http.delete(Uri.parse(url), body: body, headers: _headers).timeout(_timeout);
        break;
      case Method.patch:
        response = await http.patch(Uri.parse(url), body: body, headers: _headers).timeout(_timeout);
        break;
      case Method.put:
        response = await http.put(Uri.parse(url), body: body, headers: _headers).timeout(_timeout);
        break;
      default:
        throw UnimplementedError("API verb doesn't exit");
    }
    return response;
  }
}
