import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
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
      debugPrint('=== CHILDCARE RAW RESPONSE: $data');

      if (data == null) return [];

      // Try multiple parsing paths
      final dataObj = data['data'];
      if (dataObj == null) return [];

      // Path 1: data.data.reservations.reservations (double nested)
      final reservations = dataObj['reservations'];
      if (reservations is Map && reservations['reservations'] is List) {
        debugPrint('=== CHILDCARE: Found reservations.reservations path');
        return List<Map<String, dynamic>>.from(reservations['reservations']);
      }

      // Path 2: data.data.reservations is directly a List
      if (reservations is List) {
        debugPrint('=== CHILDCARE: Found reservations as List directly');
        return List<Map<String, dynamic>>.from(reservations);
      }

      // Path 3: data.data is directly a List
      if (dataObj is List) {
        debugPrint('=== CHILDCARE: Found data as List directly');
        return List<Map<String, dynamic>>.from(dataObj);
      }

      debugPrint('=== CHILDCARE: No matching structure found');
      return [];
    } on DioException catch (e) {
      debugPrint('=== CHILDCARE DioException: ${e.response?.data}');
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
      debugPrint('=== HEALTHCARE RAW RESPONSE: $data');

      if (data == null) return [];

      final dataObj = data['data'];
      if (dataObj == null) return [];

      // Path 1: data.data.reservations.reservations (double nested)
      final reservations = dataObj['reservations'];
      if (reservations is Map && reservations['reservations'] is List) {
        debugPrint('=== HEALTHCARE: Found reservations.reservations path');
        return List<Map<String, dynamic>>.from(reservations['reservations']);
      }

      // Path 2: data.data.reservations is directly a List
      if (reservations is List) {
        debugPrint('=== HEALTHCARE: Found reservations as List directly');
        return List<Map<String, dynamic>>.from(reservations);
      }

      // Path 3: data.data is directly a List
      if (dataObj is List) {
        debugPrint('=== HEALTHCARE: Found data as List directly');
        return List<Map<String, dynamic>>.from(dataObj);
      }

      debugPrint('=== HEALTHCARE: No matching structure found');
      return [];
    } on DioException catch (e) {
      debugPrint('=== HEALTHCARE DioException: ${e.response?.data}');
      throw AppHttpException.fromDio(e);
    }
  }

  // Fetch bookings (accepted/refused) for hospital (type: childcare/healthcare)
  Future<List<Map<String, dynamic>>> getBookings({
    required String token,
    required String type,
    required String status,
  }) async {
    try {
      final response = await apiService.get(
        path: '/hospital-account/bookings/$type/$status',
        token: token,
      );
      final data = response.data;
      debugPrint('=== BOOKINGS RAW RESPONSE ($type/$status): $data');
      if (data != null && data['data'] != null) {
        final bookingsData = data['data']['bookings'];
        if (bookingsData != null && bookingsData['reservations'] != null) {
          return List<Map<String, dynamic>>.from(bookingsData['reservations']);
        }
      }
      return [];
    } on DioException catch (e) {
      debugPrint('=== BOOKINGS $type/$status DioException: ${e.response?.data}');
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
