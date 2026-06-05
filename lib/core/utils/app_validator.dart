import 'package:flutter/widgets.dart';
import '../../l10n/app_localizations.dart';

class AppValidator {
  static String? validateEmail(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.emptyField;
    }
    // Matches standard email format
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
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

    // Length check
    if (value.length < 8) {
      return AppLocalizations.of(context)!.invalidPassword;
    }

    // Complexity check: Uppercase, Lowercase, Number, and Special Character
    final passwordRegex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&#])[A-Za-z\d@$!%*?&#]{8,}$',
    );

    if (!passwordRegex.hasMatch(value)) {
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
