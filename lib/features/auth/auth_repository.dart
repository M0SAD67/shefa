import 'package:dio/dio.dart';
import '../../core/errors/app_http_exception.dart';
import '../../core/utils/api.dart';
import '../../core/utils/api_service.dart';

class AuthRepository {
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await apiService.post(
        path: Api.login,
        data: {'email': email, 'password': password},
      );
      return response.data;
    } on DioException catch (e) {
      throw AppHttpException.fromDio(e);
    }
  }

  Future<Map<String, dynamic>> signup({
    required String email,
    required String password,
    required String confirmPassword,
    required String phone,
    required String username,
    required String address,
  }) async {
    try {
      final response = await apiService.post(
        path: Api.signup,
        data: {
          'email': email,
          'password': password,
          'confirmPassword': confirmPassword,
          'phone': phone,
          'username': username,
          'address': address,
        },
      );
      return response.data;
    } on DioException catch (e) {
      throw AppHttpException.fromDio(e);
    }
  }

  Future<Map<String, dynamic>> confirmEmail({
    required String email,
    required String otp,
  }) async {
    try {
      final response = await apiService.patch(
        path: Api.confirmEmail,
        data: {'email': email, 'otp': otp},
      );
      return response.data;
    } on DioException catch (e) {
      throw AppHttpException.fromDio(e);
    }
  }
}

final authRepository = AuthRepository();
