import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../../main.dart';
import '../cache/cache_helper.dart';
import '../constants/routes_app.dart';
import 'api.dart';

class ApiService {
  final Dio _dio;

  /// Prevents multiple simultaneous logout redirects.
  static bool _isLoggingOut = false;

  ApiService()
    : _dio = Dio(
        BaseOptions(
          baseUrl: Api.baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          headers: {'Content-Type': 'application/json'},
        ),
      ) {
    // Auth interceptor – handles 401 Token Expired
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException error, ErrorInterceptorHandler handler) async {
          if (error.response?.statusCode == 401 && !_isLoggingOut) {
            _isLoggingOut = true;
            debugPrint('⚠️ Token expired – logging out automatically.');
            await CacheHelper.removeData(key: 'token');

            final nav = navigatorKey.currentState;
            if (nav != null) {
              nav.pushNamedAndRemoveUntil(RoutesApp.login, (route) => false);
            }

            // Reset flag after a short delay so future requests are not blocked
            Future.delayed(const Duration(seconds: 2), () {
              _isLoggingOut = false;
            });
          }
          return handler.next(error);
        },
      ),
    );

    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    );
  }

  Future<Response> get({
    required String path,
    Map<String, dynamic>? queryParameters,
    String? token,
  }) async {
    return await _dio.get(
      path,
      queryParameters: queryParameters,
      options: Options(
        headers: token != null ? {'Authorization': 'Bearer $token'} : null,
      ),
    );
  }

  Future<Response> post({
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    String? token,
  }) async {
    return await _dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: Options(
        headers: token != null ? {'Authorization': 'Bearer $token'} : null,
      ),
    );
  }

  Future<Response> patch({
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    String? token,
  }) async {
    return await _dio.patch(
      path,
      data: data,
      queryParameters: queryParameters,
      options: Options(
        headers: token != null ? {'Authorization': 'Bearer $token'} : null,
      ),
    );
  }

  Future<Response> put({
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    String? token,
  }) async {
    return await _dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: Options(
        headers: token != null ? {'Authorization': 'Bearer $token'} : null,
      ),
    );
  }

  Future<Response> delete({
    required String path,
    Map<String, dynamic>? queryParameters,
    String? token,
  }) async {
    return await _dio.delete(
      path,
      queryParameters: queryParameters,
      options: Options(
        headers: token != null ? {'Authorization': 'Bearer $token'} : null,
      ),
    );
  }
}

final apiService = ApiService();
