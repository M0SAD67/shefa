// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get login => 'Login';

  @override
  String get email => 'Email';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get emailAddress => 'Email Address';

  @override
  String get sendCode => 'Send Code';

  @override
  String get signIn => 'Sign In';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get dontHaveAccount => 'Don\'t have an account? ';

  @override
  String get createAccount => 'Create Account';

  @override
  String get password => 'Password';

  @override
  String get signUp => 'Sign Up';

  @override
  String get skip => 'Skip';

  @override
  String get previous => 'Previous';

  @override
  String get next => 'Next';

  @override
  String get start => 'Start';

  @override
  String get onboardTitle1 =>
      'Know the available nursery locations and book for your child easily';

  @override
  String get onboardTitle2 =>
      'Know the hospitals where intensive care is available and book immediately';

  @override
  String get onboardTitle3 =>
      'Book or request a medical staff for follow-up at home or anywhere';

  @override
  String get otpVerification =>
      'Enter the 6-digit verification code sent to your phone number.';

  @override
  String get resendCode => 'Resend Code';

  @override
  String get phoneVerified => 'Phone number verified';

  @override
  String get redirectToHome =>
      'You will be redirected to the home page in a moments';

  @override
  String get home => 'Home';

  @override
  String get nurseries => 'Nurseries';

  @override
  String get icu => 'Intensive Care';

  @override
  String get medicalStaff => 'Medical Staff';

  @override
  String get bookings => 'Bookings';

  @override
  String get myAccount => 'My Account';

  @override
  String get navHome => 'Home';

  @override
  String get navNurseries => 'Nurseries';

  @override
  String get navIcu => 'ICU';

  @override
  String get navBookings => 'Bookings';

  @override
  String get navAccount => 'My Account';

  @override
  String editProfile(String field) {
    return 'Edit $field';
  }

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get name => 'Name';

  @override
  String get address => 'Address';

  @override
  String get phoneLabel => 'Phone Number :';

  @override
  String get emailLabel => 'Email Address :';

  @override
  String get passwordLabel => 'Password';

  @override
  String navigatingTo(String title) {
    return 'Navigating to $title';
  }

  @override
  String get invalidEmail => 'Please enter a valid email address';

  @override
  String get invalidPassword => 'Password must be at least 6 characters';

  @override
  String get invalidPhone => 'Please enter a valid phone number';

  @override
  String get emptyField => 'This field cannot be empty';

  @override
  String get validationSuccess => 'Validation Successful';

  @override
  String get validationError => 'Please correct the errors in the fields';
}
