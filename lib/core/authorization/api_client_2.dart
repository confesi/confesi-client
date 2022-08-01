// import 'package:dio/dio.dart';

// class AuthInterceptor extends QueuedInterceptor {
//   AuthInterceptor({
//     required this.dio,
//     required this.authRepository,
//     this.retries = 3,
//   });

//   /// The original dio
//   final Dio dio;
//   final AuthRepository authRepository;

//   /// The number of retries in case of 401
//   final int retries;

//   @override
//   Future<void> onRequest(
//     final RequestOptions options,
//     final RequestInterceptorHandler handler,
//   ) async {
//     // Non-authenticated endpoint -> bypass this interceptor
//     if (options._requiresNoAuthentication()) {
//       options._removeAuthenticationHeader();
//       return handler.next(options);
//     }
//     // Get auth token
//     final authTokenRes = await authRepository.getAuthToken();
//     authTokenRes.fold(
//       success: (final authToken) {
//         // Add auth token in Authorization header
//         options._setAuthenticationHeader(authToken.token);
//         handler.next(options);
//       },
//       failure: (final e) async {
//         // Skip authentication header if it is optional and user is not authenticated
//         if (e is UserNoAuthenticatedException && options._hasOptionalAuthentication()) {
//           options._removeAuthenticationHeader();
//           return handler.next(options);
//         }
//         // Handle auth token errors
//         await _onErrorRefreshingToken();
//         final error = DioError(requestOptions: options, error: e);
//         handler.reject(error);
//       },
//     );
//   }

//   @override
//   Future<void> onError(final DioError err, final ErrorInterceptorHandler handler) async {
//     if (err.response?.statusCode != 401) {
//       return super.onError(err, handler);
//     }
//     // Check retry attempt
//     final attempt = err.requestOptions._retryAttempt + 1;
//     if (attempt > retries) {
//       return super.onError(err, handler);
//     }
//     err.requestOptions._retryAttempt = attempt;
//     await Future<void>.delayed(const Duration(seconds: 1));
//     // Force refresh auth token
//     final authTokenRes = await authRepository.getAuthToken(forceRefresh: true);
//     authTokenRes.fold(
//       success: (final authToken) async {
//         // Add new auth token in Authorization header and retry call
//         try {
//           final options = err.requestOptions.._setAuthenticationHeader(authToken.token);
//           final response = await dio.fetch<void>(options);
//           handler.resolve(response);
//         } on DioError catch (e) {
//           if (e.response?.statusCode == 401) {
//             await _onErrorRefreshingToken();
//           }
//           super.onError(e, handler);
//         }
//       },
//       failure: (final e) async {
//         // Handle auth token errors
//         await _onErrorRefreshingToken();
//         final error = DioError(requestOptions: err.requestOptions, error: authTokenRes.error);
//         return handler.next(error);
//       },
//     );
//   }

//   Future<void> _onErrorRefreshingToken() async {
//     await authRepository.signOut();
//   }
// }

// extension AuthRequestOptionsX on RequestOptions {
//   bool _requiresNoAuthentication() => headers['Authorization'] == 'None';

//   bool _hasOptionalAuthentication() => headers['Authorization'] == 'Optional';

//   void _setAuthenticationHeader(final String token) => headers['Authorization'] = 'Bearer $token';

//   void _removeAuthenticationHeader() => headers.remove('Authorization');

//   int get _retryAttempt => (extra['auth_retry_attempt'] as int?) ?? 0;

//   set _retryAttempt(final int attempt) => extra['auth_retry_attempt'] = attempt;
// }
