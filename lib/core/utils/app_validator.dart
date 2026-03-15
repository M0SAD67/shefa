import 'package:flutter/widgets.dart';
import '../../l10n/app_localizations.dart';

class AppValidator {
  static String? validateEmail(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.emptyField;
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return AppLocalizations.of(context)!.invalidEmail;
    }
    return null;
  }

  static String? validatePassword(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.emptyField;
    }
    if (value.length < 6) {
      return AppLocalizations.of(context)!.invalidPassword;
    }
    return null;
  }

  static String? validatePhone(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.emptyField;
    }
    if (value.length < 10) {
      return AppLocalizations.of(context)!.invalidPhone;
    }
    return null;
  }
}
