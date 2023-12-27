import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:http_status_code/http_status_code.dart';

import 'package:ccquarters/services/auth/service.dart';

class AuthorizedDio {
  final Dio _resendingDioInstance = Dio();
  final Dio _dio = Dio();
  final Connectivity _connectivity = Connectivity();
  late final BaseAuthService _authService;
  String _token = '';

  AuthorizedDio(
    BaseAuthService authService,
  ) : _authService = authService {
    _initialize();
  }

  Dio create() {
    return _dio;
  }

  void _initialize() {
    _authService.authChanges.listen((u) => _token = "");

    _addTokenRefreshInterceptor();
    _addCacheInterceptor();
    _addConnectionInterceptor();
  }

  void _addConnectionInterceptor() {
    _dio.interceptors
        .add(InterceptorsWrapper(onRequest: (options, handler) async {
      var connectivityResult = await _connectivity.checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        handler.reject(
          DioException(
            requestOptions: options,
            response: Response(
              requestOptions: options,
              statusCode: StatusCode.GATEWAY_TIMEOUT,
              statusMessage: 'No internet connection',
            ),
          ),
        );

        return;
      }

      handler.next(options);
    }));
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

    _dio.interceptors.add(DioCacheInterceptor(options: options));
  }

  void _addTokenRefreshInterceptor() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (request, handler) async {
          _setToken(request, handler);
        },
        onError: (e, handler) async {
          if (e.response?.statusCode == HttpStatus.unauthorized) {
            _refreshTokenAndResend(e, handler);
            return;
          }

          handler.next(e);
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
