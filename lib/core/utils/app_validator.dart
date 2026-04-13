import 'package:flutter/widgets.dart';
import '../../l10n/app_localizations.dart';

class AppValidator {
  static String? validateEmail(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.emptyField;
    }
    // Matches API (Joi): local@sub.domain.com — TLD must be com, net, or edu.
    final emailRegex = RegExp(
      r'^[^\s@]+@([a-zA-Z0-9-]+\.){1,2}(com|net|edu)$',
    );
    if (!emailRegex.hasMatch(value.trim())) {
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
