// class TokenInterceptor extends Interceptor {
//   final SecureStorage _secureStorage;
//
//   TokenInterceptor(this._secureStorage);
//
//   @override
//   void onRequest(
//       RequestOptions options, RequestInterceptorHandler handler) async {
//     final token = await _secureStorage.readToken('accessToken');
//     if (token != null) {
//       options.headers['Authorization'] = 'Bearer $token';
//     }
//     super.onRequest(options, handler);
//   }
// }
