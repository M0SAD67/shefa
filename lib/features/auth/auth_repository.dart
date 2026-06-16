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
    required int gender, // 👈 تم إضافة الـ gender هنا كـ required parameter
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
          'gender':
              gender, // 👈 تم تمريره هنا جوه الـ request data ليحل المشكلة
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
      // If /user is not found or fails for patients, try /profile as fallback
      if (e.response?.statusCode == 404 ||
          e.message?.contains('routing') == true ||
          e.response?.data?.toString().contains('routing') == true) {
        try {
          final responseFallback = await apiService.get(
            path: '/profile',
            token: token,
          );
          return responseFallback.data;
        } catch (_) {
          // If fallback also fails, throw original exception
          throw AppHttpException.fromDio(e);
        }
      }
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
        data: {'firstName': firstName, 'lastName': lastName, 'phone': phone},
      );
      return response.data;
    } on DioException catch (e) {
      throw AppHttpException.fromDio(e);
    }
  }

  Future<Map<String, dynamic>> resendOtp({required String email}) async {
    try {
      // تأكد من مسار الـ API الصحيح لإعادة الإرسال من الـ Backend عندك (مثلاً /auth/resend-otp)
      final response = await apiService.post(
        path: '/auth/resend-otp',
        data: {'email': email},
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
        data: {'password': password},
      );
      return response.data;
    } on DioException catch (e) {
      throw AppHttpException.fromDio(e);
    }
  }
}

final authRepository = AuthRepository();
