// import 'package:dio/dio.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// import '../constants/general.dart';
// import '../network/connection_info.dart';

// class ApiClient {
//   final String baseUrl;
//   final Dio dio;
//   final NetworkInfo networkInfo;
//   final FlutterSecureStorage secureStorage;

//   ApiClient(
//       {required this.baseUrl,
//       required this.dio,
//       required this.networkInfo,
//       required this.secureStorage}) {
//     dio.interceptors.add(RefreshInvalidTokenInterceptor(networkInfo, dio, secureStorage));
//   }
// }

// class RefreshInvalidTokenInterceptor extends QueuedInterceptor {
//   final NetworkInfo networkInfo;
//   final Dio dio;
//   final FlutterSecureStorage secureStorage;
//   String? accessToken;

//   RefreshInvalidTokenInterceptor(this.networkInfo, this.dio, this.secureStorage);

//   @override
//   Future onError(DioError err, ErrorInterceptorHandler handler) async {
//     if (_shouldRetry(err) && await networkInfo.isConnected) {
//       try {
//         // access token request (using refresh token from flutter_secure_storage)
//         final refreshToken = await secureStorage.read(key: "refreshToken");
//         final response = await dio.post(
//           "$kDomain/api/user/token",
//           queryParameters: {"token": refreshToken},
//         );
//         accessToken = response.data["accessToken"];
//         return err;
//       } on DioError catch (e) {
//         handler.next(e);
//       } catch (e) {
//         handler.next(err);
//       }
//     } else {
//       handler.next(err);
//     }
//   }

//   bool _shouldRetry(DioError err) =>
//       (err.response!.statusCode == 403 || err.response!.statusCode == 401);
// }
