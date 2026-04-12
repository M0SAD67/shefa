import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @sendCode.
  ///
  /// In en, this message translates to:
  /// **'Send Code'**
  String get sendCode;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get dontHaveAccount;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @onboardTitle1.
  ///
  /// In en, this message translates to:
  /// **'Know the available nursery locations and book for your child easily'**
  String get onboardTitle1;

  /// No description provided for @onboardTitle2.
  ///
  /// In en, this message translates to:
  /// **'Know the hospitals where intensive care is available and book immediately'**
  String get onboardTitle2;

  /// No description provided for @onboardTitle3.
  ///
  /// In en, this message translates to:
  /// **'Book or request a medical staff for follow-up at home or anywhere'**
  String get onboardTitle3;

  /// No description provided for @otpVerification.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit verification code sent to your phone number.'**
  String get otpVerification;

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get resendCode;

  /// No description provided for @phoneVerified.
  ///
  /// In en, this message translates to:
  /// **'Phone number verified'**
  String get phoneVerified;

  /// No description provided for @redirectToHome.
  ///
  /// In en, this message translates to:
  /// **'You will be redirected to the home page in a moments'**
  String get redirectToHome;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @nurseries.
  ///
  /// In en, this message translates to:
  /// **'Nurseries'**
  String get nurseries;

  /// No description provided for @icu.
  ///
  /// In en, this message translates to:
  /// **'Intensive Care'**
  String get icu;

  /// No description provided for @medicalStaff.
  ///
  /// In en, this message translates to:
  /// **'Medical Staff'**
  String get medicalStaff;

  /// No description provided for @bookings.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get bookings;

  /// No description provided for @myAccount.
  ///
  /// In en, this message translates to:
  /// **'My Account'**
  String get myAccount;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navNurseries.
  ///
  /// In en, this message translates to:
  /// **'Nurseries'**
  String get navNurseries;

  /// No description provided for @navIcu.
  ///
  /// In en, this message translates to:
  /// **'ICU'**
  String get navIcu;

  /// No description provided for @navBookings.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get navBookings;

  /// No description provided for @navAccount.
  ///
  /// In en, this message translates to:
  /// **'My Account'**
  String get navAccount;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit {field}'**
  String editProfile(String field);

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone Number :'**
  String get phoneLabel;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email Address :'**
  String get emailLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @navigatingTo.
  ///
  /// In en, this message translates to:
  /// **'Navigating to {title}'**
  String navigatingTo(String title);

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get invalidEmail;

  /// No description provided for @invalidPassword.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get invalidPassword;

  /// No description provided for @invalidPhone.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get invalidPhone;

  /// No description provided for @emptyField.
  ///
  /// In en, this message translates to:
  /// **'This field cannot be empty'**
  String get emptyField;

  /// No description provided for @validationSuccess.
  ///
  /// In en, this message translates to:
  /// **'Validation Successful'**
  String get validationSuccess;

  /// No description provided for @validationError.
  ///
  /// In en, this message translates to:
  /// **'Please correct the errors in the fields'**
  String get validationError;

  /// No description provided for @searchCountry.
  ///
  /// In en, this message translates to:
  /// **'Search country...'**
  String get searchCountry;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// No description provided for @medicalStaffServiceDesc.
  ///
  /// In en, this message translates to:
  /// **'Home or anywhere patient\nand child care service'**
  String get medicalStaffServiceDesc;

  /// No description provided for @elderlyCare.
  ///
  /// In en, this message translates to:
  /// **'Elderly Care'**
  String get elderlyCare;

  /// No description provided for @postSurgeryCare.
  ///
  /// In en, this message translates to:
  /// **'Post-Surgery Care'**
  String get postSurgeryCare;

  /// No description provided for @newbornFollowUp.
  ///
  /// In en, this message translates to:
  /// **'Newborn Follow-up'**
  String get newbornFollowUp;

  /// No description provided for @patientName.
  ///
  /// In en, this message translates to:
  /// **'Patient Name'**
  String get patientName;

  /// No description provided for @addressOrLocation.
  ///
  /// In en, this message translates to:
  /// **'Address or Location'**
  String get addressOrLocation;

  /// No description provided for @medicalCondition.
  ///
  /// In en, this message translates to:
  /// **'Medical Condition'**
  String get medicalCondition;

  /// No description provided for @confirmBooking.
  ///
  /// In en, this message translates to:
  /// **'Confirm Booking'**
  String get confirmBooking;

  /// No description provided for @requestDetails.
  ///
  /// In en, this message translates to:
  /// **'Request Details'**
  String get requestDetails;

  /// No description provided for @medicalStaffBooking.
  ///
  /// In en, this message translates to:
  /// **'Medical Staff Booking'**
  String get medicalStaffBooking;

  /// No description provided for @notSpecified.
  ///
  /// In en, this message translates to:
  /// **'Not specified'**
  String get notSpecified;

  /// No description provided for @bookingRequestSent.
  ///
  /// In en, this message translates to:
  /// **'Booking Request Sent'**
  String get bookingRequestSent;

  /// No description provided for @backToHome.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get backToHome;

  /// No description provided for @condition.
  ///
  /// In en, this message translates to:
  /// **'Condition'**
  String get condition;

  /// No description provided for @serviceType.
  ///
  /// In en, this message translates to:
  /// **'Service Type'**
  String get serviceType;

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// No description provided for @editProfileInformation.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile Information'**
  String get editProfileInformation;

  /// No description provided for @phoneEmailPassword.
  ///
  /// In en, this message translates to:
  /// **'Phone, Email, and Password'**
  String get phoneEmailPassword;

  /// No description provided for @appSettings.
  ///
  /// In en, this message translates to:
  /// **'App Settings'**
  String get appSettings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @aboutShefa.
  ///
  /// In en, this message translates to:
  /// **'About Shefa'**
  String get aboutShefa;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightMode;

  /// No description provided for @reviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviews;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
