import '../errors/app_http_exception.dart';
import '../../l10n/app_localizations.dart';

/// User-visible text for auth API failures (localized where appropriate).
String authErrorSnackMessage(Object error, AppLocalizations l10n) {
  if (error is AppHttpException) {
    return error.resolveMessage(
      networkError: l10n.networkError,
      timeoutError: l10n.networkTimeout,
      unknownError: l10n.unexpectedError,
    );
  }
  final s = error.toString();
  const prefix = 'Exception: ';
  if (s.startsWith(prefix)) {
    return s.substring(prefix.length).trim();
  }
  return s.trim();
}
