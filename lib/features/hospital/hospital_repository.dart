import 'package:dio/dio.dart';
import '../../core/utils/api_service.dart';
import '../../core/errors/app_http_exception.dart';

class HospitalRepository {
  // Fetch hospital dashboard (overview, bookings requests, capacities)
  Future<Map<String, dynamic>?> getHospitalHome(String token) async {
    try {
      final response = await apiService.get(
        path: '/hospital-account/home',
        token: token,
      );

      final data = response.data;
      if (data != null && data['data'] != null) {
        final Map<String, dynamic> dataObject =
            data['data'] as Map<String, dynamic>;

        if (dataObject.containsKey('home') &&
            dataObject['home'] is Map<String, dynamic>) {
          return dataObject['home'] as Map<String, dynamic>?;
        }

        return dataObject;
      }

      return null;
    } on DioException catch (e) {
      throw AppHttpException.fromDio(e);
    }
  } // Update single service capacity

  Future<Map<String, dynamic>> updateServiceCapacity({
    required String serviceId,
    required int capacity,
    required String token,
  }) async {
    try {
      final response = await apiService.patch(
        path: '/hospital-account/home/places/$serviceId',
        data: {'capacity': capacity},
        token: token,
      );
      return response.data;
    } on DioException catch (e) {
      throw AppHttpException.fromDio(e);
    }
  }

  // Accept/Refuse a booking request (childcare or healthcare)
  Future<Map<String, dynamic>> updateReservationStatus({
    required String reservationId,
    required bool isChildcare,
    required String action, // 'accept' or 'refuse'
    required String token,
  }) async {
    final String type = isChildcare ? 'childcare' : 'healthcare';
    try {
      final response = await apiService.patch(
        path: '/hospital-account/reservations/$type/$reservationId/status',
        data: {'action': action},
        token: token,
      );
      return response.data;
    } on DioException catch (e) {
      throw AppHttpException.fromDio(e);
    }
  }

  // Fetch childcare reservations for hospital
  Future<List<Map<String, dynamic>>> getChildcareReservations(
    String token,
  ) async {
    try {
      final response = await apiService.get(
        path: '/hospital-account/reservations/childcare',
        token: token,
      );
      final data = response.data;
      if (data != null && data['data'] != null) {
        final reservations = data['data']['reservations'];
        if (reservations != null && reservations['reservations'] != null) {
          return List<Map<String, dynamic>>.from(reservations['reservations']);
        }
      }
      return [];
    } on DioException catch (e) {
      throw AppHttpException.fromDio(e);
    }
  }

  // Fetch healthcare reservations for hospital
  Future<List<Map<String, dynamic>>> getHealthcareReservations(
    String token,
  ) async {
    try {
      final response = await apiService.get(
        path: '/hospital-account/reservations/healthcare',
        token: token,
      );
      final data = response.data;
      if (data != null && data['data'] != null) {
        final reservations = data['data']['reservations'];
        if (reservations != null && reservations['reservations'] != null) {
          return List<Map<String, dynamic>>.from(reservations['reservations']);
        }
      }
      return [];
    } on DioException catch (e) {
      throw AppHttpException.fromDio(e);
    }
  }

  // Fetch accepted bookings for hospital
  Future<List<Map<String, dynamic>>> getAcceptedBookings(String token) async {
    try {
      final response = await apiService.get(
        path: '/hospital-account/bookings/healthcare/accepted',
        token: token,
      );
      final data = response.data;
      if (data != null && data['data'] != null) {
        final bookings = data['data']['bookings'];
        if (bookings != null) {
          return List<Map<String, dynamic>>.from(bookings);
        }
      }
      return [];
    } on DioException catch (e) {
      throw AppHttpException.fromDio(e);
    }
  }

  // Delete a booking
  Future<void> deleteBooking({
    required String bookingId,
    required String token,
  }) async {
    try {
      await apiService.delete(
        path: '/hospital-account/bookings/healthcare/$bookingId',
        token: token,
      );
    } on DioException catch (e) {
      throw AppHttpException.fromDio(e);
    }
  }
}

final hospitalRepository = HospitalRepository();
