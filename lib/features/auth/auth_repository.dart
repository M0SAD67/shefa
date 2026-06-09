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
    required String username,
    required String address,
    required String phone,
    required int role,
  }) async {
    try {
      final response = await apiService.post(
        path: Api.signup,
        data: {
          'email': email,
          'password': password,
          'confirmPassword': confirmPassword,
          'username': username,
          'address': address,
          'phone': phone,
          'role': role,
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

  Future<Map<String, dynamic>> getUserProfile(String token) async {
    try {
      final response = await apiService.get(
        path: Api.userProfile,
        token: token,
      );
      return response.data;
    } on DioException catch (e) {
      throw AppHttpException.fromDio(e);
    }
  }

  Future<Map<String, dynamic>> updateProfile({
    required String token,
    required String firstName,
    required String lastName,
    required String phone,
  }) async {
    try {
      final response = await apiService.put(
        path: '/profile',
        token: token,
        data: {
          'firstName': firstName,
          'lastName': lastName,
          'phone': phone,
        },
      );
      return response.data;
    } on DioException catch (e) {
      throw AppHttpException.fromDio(e);
    }
  }

  Future<Map<String, dynamic>> updatePassword({
    required String token,
    required String password,
  }) async {
    try {
      final response = await apiService.put(
        path: '/profile/password',
        token: token,
        data: {
          'password': password,
        },
      );
      return response.data;
    } on DioException catch (e) {
      throw AppHttpException.fromDio(e);
    }
  }
}

final authRepository = AuthRepository();
