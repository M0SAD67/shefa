import 'package:dio/dio.dart';
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
      throw _handleError(e);
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
      throw _handleError(e);
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
      throw _handleError(e);
    }
  }

  String _handleError(DioException e) {
    if (e.response != null && e.response!.data != null) {
      if (e.response!.data is Map && e.response!.data['message'] != null) {
        return e.response!.data['message'];
      }
    }
    return "Something went wrong. Please try again.";
  }
}

final authRepository = AuthRepository();
