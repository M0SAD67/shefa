import 'package:dio/dio.dart';
import '../utils/api_error_message.dart';

/// Thrown by [AuthRepository] so the UI can show localized network messages
/// and verbatim API validation text.
enum AppHttpFailureKind { apiMessage, noConnection, timeout, unknown }

class AppHttpException implements Exception {
  final AppHttpFailureKind kind;
  final String apiMessage;

  const AppHttpException._(this.kind, [this.apiMessage = '']);

  factory AppHttpException.fromApiBody(String message) =>
      AppHttpException._(AppHttpFailureKind.apiMessage, message);

  factory AppHttpException.noConnection() =>
      const AppHttpException._(AppHttpFailureKind.noConnection);

  factory AppHttpException.timeout() =>
      const AppHttpException._(AppHttpFailureKind.timeout);

  factory AppHttpException.unknown() =>
      const AppHttpException._(AppHttpFailureKind.unknown);

  /// Maps [DioException] to a typed failure for consistent snackbars.
  factory AppHttpException.fromDio(DioException e) {
    final parsed = ApiErrorMessage.tryParseBody(e.response?.data);
    if (parsed != null && parsed.isNotEmpty) {
      return AppHttpException.fromApiBody(parsed);
    }

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return AppHttpException.timeout();
      case DioExceptionType.connectionError:
      case DioExceptionType.badCertificate:
        return AppHttpException.noConnection();
      default:
        if (e.response == null) {
          return AppHttpException.noConnection();
        }
        return AppHttpException.unknown();
    }
  }

  String resolveMessage({
    required String networkError,
    required String timeoutError,
    required String unknownError,
  }) {
    switch (kind) {
      case AppHttpFailureKind.apiMessage:
        return apiMessage;
      case AppHttpFailureKind.noConnection:
        return networkError;
      case AppHttpFailureKind.timeout:
        return timeoutError;
      case AppHttpFailureKind.unknown:
        return unknownError;
    }
  }

  @override
  String toString() => switch (kind) {
        AppHttpFailureKind.apiMessage => apiMessage,
        AppHttpFailureKind.noConnection => 'AppHttpException(noConnection)',
        AppHttpFailureKind.timeout => 'AppHttpException(timeout)',
        AppHttpFailureKind.unknown => 'AppHttpException(unknown)',
      };
}
