import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:confesi/core/services/user_auth/user_auth_data.dart';
import 'package:path/path.dart';

import '../../../constants/shared/constants.dart';
import '../../results/failures.dart';
import '../user_auth/user_auth_service.dart';
import '../../utils/numbers/is_plural.dart';
import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';
import '../../../init.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import '../../utils/numbers/add_commas_to_number.dart';

/// The different RESTful API verbs.
enum Verb {
  post,
  get,
  patch,
  put,
  delete,
}

class ApiServerFailure extends FailureWithMsg {
  @override
  String msg() => "Server error";
}

class ApiConnectionFailure extends FailureWithMsg {
  @override
  String msg() => "Connection error";
}

class ApiTooManyGlobalRequests extends FailureWithMsg {
  final int resetInSeconds;

  ApiTooManyGlobalRequests(this.resetInSeconds);

  @override
  String msg() =>
      "Too many requests, wait ${addCommasToNumber(resetInSeconds)} ${isPlural(resetInSeconds) ? "seconds" : "second"}";
}

class ApiTooManyEmailRequests extends FailureWithMsg {
  final int resetInSeconds;

  ApiTooManyEmailRequests(this.resetInSeconds);

  @override
  String msg() =>
      "Too many email requests, wait ${addCommasToNumber(resetInSeconds)} ${isPlural(resetInSeconds) ? "seconds" : "second"}";
}

class ApiTimeoutFailure extends FailureWithMsg {
  @override
  String msg() => "Connection timeout";
}

String apiVerbToString(Verb method) {
  switch (method) {
    case Verb.post:
      return "POST";
    case Verb.get:
      return "GET";
    case Verb.patch:
      return "PATCH";
    case Verb.put:
      return "PUT";
    case Verb.delete:
      return "DELETE";
  }
}

class Api {
  final Map<String, String> _headers = <String, String>{};
  Duration _timeout = apiDefaultTimeout;
  http.Client? _client;

  Api() {
    _headers['Content-Type'] = 'application/json';
    _headers['Accept'] = 'application/json';
  }

  void cancelCurrReq() {
    _client?.close();
    _client = null;
  }

  void _setToken(String token) => _headers['Authorization'] = "Bearer $token";
  void setTimeout(Duration timeout) => _timeout = timeout;
  void addHeader(String key, String value) => _headers[key] = value;

  bool _isMultipart = false;
  void setMultipart(bool set) => _isMultipart = set;

  Future<bool> _getSetBearerToken() async {
    if (sl.get<FirebaseAuth>().currentUser != null) {
      try {
        IdTokenResult token = await sl.get<FirebaseAuth>().currentUser!.getIdTokenResult();
        if (token.token != null) {
          _setToken(token.token!);
          return true;
        } else {
          return false;
        }
      } catch (_) {
        return false;
      }
    }
    return false;
  }

  String _addQuestionOrAmper(String url) {
    if (url.contains("?")) {
      url += "&";
    } else {
      url += "?";
    }
    return url;
  }

  Future<Either<FailureWithMsg, http.Response>> req(
    Verb method,
    bool needsBearerToken,
    String endpoint,
    Map<String, dynamic> body, {
    Map<String, File>? files,
  }) async {
    try {
      String url = domain + endpoint;

      if (needsBearerToken) {
        if (!await _getSetBearerToken()) {
          return Left(ApiConnectionFailure());
        }
      }

      _client = http.Client(); // Create a new HTTP client for each request

      if (sl.get<UserAuthService>().data().profanityFilter == ProfanityFilter.on) {
        url = _addQuestionOrAmper(url);
        url += "profanity=false";
      }

      if (_isMultipart) {
        var request = http.MultipartRequest(apiVerbToString(method), Uri.parse(url));
        request.headers.addAll(_headers);

        // Add fields to the request
        body.forEach((key, value) {
          request.fields[key] = value.toString();
        });
        // If files are provided, attach them to the request
        if (files != null) {
          for (var file in files.values) {
            // Compress the file first
            File compressedFile = await _compressFile(file);

            // Add the compressed file to the multipart request
            request.files.add(
              await http.MultipartFile.fromPath(
                'files', // Use a constant field name for all files
                compressedFile.path,
                filename: basename(compressedFile.path),
              ),
            );
          }
        }

        http.StreamedResponse streamResponse = await request.send().timeout(_timeout);
        _timeout = apiDefaultTimeout; // Reset the timeout after the request
        if (_client != null) _client!.close();
        _client = null;

        http.Response response = await http.Response.fromStream(streamResponse);

        // Reset the _isMultipart flag after the request
        _isMultipart = false;

        // Handle any 5xx status codes
        if (streamResponse.statusCode.toString()[0] == "5") {
          return Left(ApiServerFailure());
        } else if (streamResponse.statusCode == 429) {
          try {
            if (response.body.contains("too many emails sent")) {
              return Left(ApiTooManyEmailRequests(int.parse(json.decode(response.body)["value"]["reset_in_seconds"])));
            } else {
              // From the X-Ratelimit-Reset header
              return Left(ApiTooManyGlobalRequests(int.parse(response.headers["x-ratelimit-reset"]!)));
            }
          } catch (e) {
            print(e);
            return Left(ApiServerFailure());
          }
        }
        // "success"
        return Right(response);
      } else {
        var request = http.Request(apiVerbToString(method), Uri.parse(url));
        request.body = jsonEncode(body);
        request.headers.addAll(_headers);
        http.StreamedResponse streamResponse = await request.send().timeout(_timeout);
        _timeout = apiDefaultTimeout; // Reset the timeout after the request

        if (_client != null) _client!.close();
        _client = null; // Reset the HTTP client instance after closing

        http.Response response = await http.Response.fromStream(streamResponse);

        if (debugMode) {
          print("================================ DEBUG API ================================");
          print("Req endpoint: $url, Method: ${apiVerbToString(method)}");
          print("${streamResponse.statusCode} ${streamResponse.reasonPhrase}");
          print("Req body: ${request.body}");
        }

        // Handle any 5xx status codes
        if (streamResponse.statusCode.toString()[0] == "5") {
          return Left(ApiServerFailure());
        } else if (streamResponse.statusCode == 429) {
          try {
            if (response.body.contains("too many emails sent")) {
              return Left(ApiTooManyEmailRequests(int.parse(json.decode(response.body)["value"]["reset_in_seconds"])));
            } else {
              // From the X-Ratelimit-Reset header
              return Left(ApiTooManyGlobalRequests(int.parse(response.headers["x-ratelimit-reset"]!)));
            }
          } catch (e) {
            print(e);
            return Left(ApiServerFailure());
          }
        }
        // "success"
        return Right(response);
      }
    } on SocketException catch (_) {
      // Close the client in case of an exception
      _client?.close();
      return Left(ApiConnectionFailure());
    } on TimeoutException catch (_) {
      // Close the client in case of a timeout
      _client?.close();
      return Left(ApiTimeoutFailure());
    } catch (e) {
      // Close the client in case of any other exception
      _client?.close();
      print(e);
      return Left(ApiServerFailure());
    }
  }
}

Future<File> _compressFile(File file) async {
  final originalBytes = await file.readAsBytes();

  // Compress the bytes
  final List<int>? compressedData = GZipEncoder().encode(originalBytes);
  if (compressedData == null) {
    throw Exception('Failed to compress the file.');
  }

  // Save the compressed bytes to a new file
  final compressedFile = File('${file.path}.gz');
  await compressedFile.writeAsBytes(compressedData, flush: true);

  return compressedFile;
}
