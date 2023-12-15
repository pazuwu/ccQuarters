import 'dart:io';

import 'package:ccquarters/services/auth/service.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';

class AuthorizedDio extends DioForNative {
  final Dio _resendingDioInstance = Dio();
  final BaseAuthService _authService;
  String _token = '';

  AuthorizedDio(BaseAuthService authService) : _authService = authService {
    _addTokenRefreshInterceptor();
    _addCacheInterceptor();
  }

  void _addCacheInterceptor() {
    final options = CacheOptions(
      store: MemCacheStore(),
      policy: CachePolicy.request,
      hitCacheOnErrorExcept: [HttpStatus.unauthorized, HttpStatus.forbidden],
      maxStale: const Duration(days: 7),
      priority: CachePriority.normal,
      cipher: null,
      keyBuilder: CacheOptions.defaultCacheKeyBuilder,
      allowPostMethod: false,
    );

    interceptors.add(DioCacheInterceptor(options: options));
  }

  void _addTokenRefreshInterceptor() {
    interceptors.add(
      InterceptorsWrapper(
        onRequest: (request, handler) async {
          _setToken(request, handler);
        },
        onError: (e, handler) async {
          if (e.response?.statusCode == HttpStatus.unauthorized) {
            _refreshTokenAndResend(e, handler);
          }
        },
      ),
    );
  }

  Future _refreshTokenAndResend(
      DioException e, ErrorInterceptorHandler handler) async {
    await _authService.getToken().then(
      (value) async {
        if (value != null) {
          _token = value;
          e.requestOptions.headers[HttpHeaders.authorizationHeader] = _token;

          final options = Options(
              method: e.requestOptions.method,
              headers: e.requestOptions.headers);

          final resendRequest = await _resendingDioInstance.request(
              e.requestOptions.path,
              options: options,
              data: e.requestOptions.data,
              queryParameters: e.requestOptions.queryParameters);

          return handler.resolve(resendRequest);
        }
      },
    );
  }

  void _setToken(RequestOptions request, RequestInterceptorHandler handler) {
    if (_token.isNotEmpty) {
      request.headers[HttpHeaders.authorizationHeader] = _token;
    }
    return handler.next(request);
  }
}