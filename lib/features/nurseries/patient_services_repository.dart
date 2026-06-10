import 'package:dio/dio.dart';

import '../../core/cache/cache_helper.dart';
import '../../core/errors/app_http_exception.dart';
import '../../core/utils/api_service.dart';
import 'patient_service_model.dart';

class PatientServicesRepository {
  String? get _token => CacheHelper.getData(key: 'token') as String?;

  Future<List<PatientService>> getNurseryServices() async {
    final token = _token;
    if (token == null) return const [];

    try {
      final response = await apiService.get(
        path: '/services/nursery',
        token: token,
      );
      return PatientService.listFromServicesResponse(response.data);
    } on DioException catch (e) {
      try {
        final response = await apiService.get(path: '/childcare', token: token);
        return PatientService.listFromChildcareResponse(response.data);
      } on DioException {
        throw AppHttpException.fromDio(e);
      }
    }
  }

  Future<List<PatientService>> getCareServices() async {
    final token = _token;
    if (token == null) return const [];

    try {
      final response = await apiService.get(
        path: '/services/care',
        token: token,
      );
      return PatientService.listFromServicesResponse(response.data);
    } on DioException catch (e) {
      throw AppHttpException.fromDio(e);
    }
  }

  Future<void> bookChildcare({
    required String serviceId,
    required String type,
    required String childName,
    required String phone,
    required String condition,
  }) async {
    final token = _token;
    if (token == null) return;

    try {
      await apiService.post(
        path: '/childcare/$serviceId/book',
        token: token,
        data: {
          'type': type,
          'childName': childName,
          'phone': phone,
          'condition': condition,
        },
      );
    } on DioException catch (e) {
      throw AppHttpException.fromDio(e);
    }
  }
}

final patientServicesRepository = PatientServicesRepository();
