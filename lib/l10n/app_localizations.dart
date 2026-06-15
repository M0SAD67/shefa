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

  /// No description provided for @createAccountFor.
  ///
  /// In en, this message translates to:
  /// **'Create Account for '**
  String get createAccountFor;

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

  /// No description provided for @patient.
  ///
  /// In en, this message translates to:
  /// **'Patient'**
  String get patient;

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
  /// **'Use a valid email that ends with .com, .net, or .edu'**
  String get invalidEmail;

  /// No description provided for @noConnectionText.
  ///
  /// In en, this message translates to:
  /// **'Please check your internet connection'**
  String get noConnectionText;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @uploadVerificationDoc.
  ///
  /// In en, this message translates to:
  /// **'Upload Verification Document (Required for Staff)'**
  String get uploadVerificationDoc;

  /// No description provided for @documentUploaded.
  ///
  /// In en, this message translates to:
  /// **'Document Uploaded'**
  String get documentUploaded;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Check your network and try again.'**
  String get networkError;

  /// No description provided for @networkTimeout.
  ///
  /// In en, this message translates to:
  /// **'The server took too long to respond. Try again in a moment.'**
  String get networkTimeout;

  /// No description provided for @unexpectedError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get unexpectedError;

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

  /// No description provided for @bookingRequests.
  ///
  /// In en, this message translates to:
  /// **'Booking Requests'**
  String get bookingRequests;

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

  /// No description provided for @loadingRingPreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Loading ring'**
  String get loadingRingPreviewTitle;

  /// No description provided for @loadingRingPreviewMenu.
  ///
  /// In en, this message translates to:
  /// **'Loading ring (design)'**
  String get loadingRingPreviewMenu;

  /// No description provided for @loadingRingPreviewHint.
  ///
  /// In en, this message translates to:
  /// **'Brand shimmer uses your palette; pass different words or sizes from code where you show loading.'**
  String get loadingRingPreviewHint;

  /// No description provided for @loadingRingPreviewBrandedCaption.
  ///
  /// In en, this message translates to:
  /// **'Name shimmer (default)'**
  String get loadingRingPreviewBrandedCaption;

  /// No description provided for @loadingRingPreviewClassicCaption.
  ///
  /// In en, this message translates to:
  /// **'Ring variant (compact UI)'**
  String get loadingRingPreviewClassicCaption;

  /// No description provided for @accountCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully'**
  String get accountCreatedSuccess;

  /// No description provided for @otpIncompleteCode.
  ///
  /// In en, this message translates to:
  /// **'Please enter the complete 6-digit code'**
  String get otpIncompleteCode;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @otpEnterCodeForEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit verification code sent to {email}.'**
  String otpEnterCodeForEmail(String email);

  /// No description provided for @acceptedBookings.
  ///
  /// In en, this message translates to:
  /// **'Accepted Bookings'**
  String get acceptedBookings;

  /// No description provided for @rejectedBookings.
  ///
  /// In en, this message translates to:
  /// **'Rejected Bookings'**
  String get rejectedBookings;

  /// No description provided for @childNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Child Name'**
  String get childNameLabel;

  /// No description provided for @patientNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Patient Name'**
  String get patientNameLabel;

  /// No description provided for @phoneLabelText.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneLabelText;

  /// No description provided for @serviceTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Service Type'**
  String get serviceTypeLabel;

  /// No description provided for @statusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get statusLabel;

  /// No description provided for @acceptedStatus.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get acceptedStatus;

  /// No description provided for @rejectedStatus.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get rejectedStatus;

  /// No description provided for @detailsButton.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get detailsButton;

  /// No description provided for @bookingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get bookingsTitle;

  /// No description provided for @bookingDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Booking Details'**
  String get bookingDetailsTitle;

  /// No description provided for @detailedRequestData.
  ///
  /// In en, this message translates to:
  /// **'Detailed Request Data'**
  String get detailedRequestData;

  /// No description provided for @deleteRequestButton.
  ///
  /// In en, this message translates to:
  /// **'Delete Request'**
  String get deleteRequestButton;

  /// No description provided for @areYouSureDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get areYouSureDialogTitle;

  /// No description provided for @confirmDeleteButton.
  ///
  /// In en, this message translates to:
  /// **'Confirm Delete'**
  String get confirmDeleteButton;

  /// No description provided for @backButtonText.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get backButtonText;

  /// No description provided for @editDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Data & Available Places'**
  String get editDataTitle;

  /// No description provided for @availableNurseriesHeader.
  ///
  /// In en, this message translates to:
  /// **'Available Places for Nurseries:'**
  String get availableNurseriesHeader;

  /// No description provided for @availableIcuHeader.
  ///
  /// In en, this message translates to:
  /// **'Available Places for Intensive Care:'**
  String get availableIcuHeader;

  /// No description provided for @totalBedsHeader.
  ///
  /// In en, this message translates to:
  /// **'Total Bed Counts:'**
  String get totalBedsHeader;

  /// No description provided for @nurseryKidsLabel.
  ///
  /// In en, this message translates to:
  /// **'Nursery Kids'**
  String get nurseryKidsLabel;

  /// No description provided for @nurseryNicuLabel.
  ///
  /// In en, this message translates to:
  /// **'Nursery NICU'**
  String get nurseryNicuLabel;

  /// No description provided for @icuAdultsLabel.
  ///
  /// In en, this message translates to:
  /// **'ICU Adults'**
  String get icuAdultsLabel;

  /// No description provided for @icuCcuLabel.
  ///
  /// In en, this message translates to:
  /// **'ICU CCU'**
  String get icuCcuLabel;

  /// No description provided for @icuPicuLabel.
  ///
  /// In en, this message translates to:
  /// **'ICU PICU'**
  String get icuPicuLabel;

  /// No description provided for @totalNurseryBedsLabel.
  ///
  /// In en, this message translates to:
  /// **'Total Nursery Beds'**
  String get totalNurseryBedsLabel;

  /// No description provided for @totalIcuBedsLabel.
  ///
  /// In en, this message translates to:
  /// **'Total ICU Beds'**
  String get totalIcuBedsLabel;

  /// No description provided for @bookingOverviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Bookings Overview'**
  String get bookingOverviewTitle;

  /// No description provided for @todayLabel.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get todayLabel;

  /// No description provided for @totalBookingRequestsCard.
  ///
  /// In en, this message translates to:
  /// **'Total\nBookings'**
  String get totalBookingRequestsCard;

  /// No description provided for @nurseriesCard.
  ///
  /// In en, this message translates to:
  /// **'Nurseries'**
  String get nurseriesCard;

  /// No description provided for @icuCard.
  ///
  /// In en, this message translates to:
  /// **'Intensive Care'**
  String get icuCard;

  /// No description provided for @kidsSub.
  ///
  /// In en, this message translates to:
  /// **'Kids 🍼'**
  String get kidsSub;

  /// No description provided for @nicuSub.
  ///
  /// In en, this message translates to:
  /// **'NICU 👶'**
  String get nicuSub;

  /// No description provided for @icuSub.
  ///
  /// In en, this message translates to:
  /// **'ICU 🏥'**
  String get icuSub;

  /// No description provided for @ccuSub.
  ///
  /// In en, this message translates to:
  /// **'CCU ❤️'**
  String get ccuSub;

  /// No description provided for @picuSub.
  ///
  /// In en, this message translates to:
  /// **'PICU 👶'**
  String get picuSub;

  /// No description provided for @availablePlacesLabel.
  ///
  /// In en, this message translates to:
  /// **'Available Places'**
  String get availablePlacesLabel;

  /// No description provided for @nurseriesBedsTotalLabel.
  ///
  /// In en, this message translates to:
  /// **'Total Nursery Beds'**
  String get nurseriesBedsTotalLabel;

  /// No description provided for @icuBedsTotalLabel.
  ///
  /// In en, this message translates to:
  /// **'Total ICU Beds'**
  String get icuBedsTotalLabel;

  /// No description provided for @editDataButton.
  ///
  /// In en, this message translates to:
  /// **'Edit Data'**
  String get editDataButton;

  /// No description provided for @nurseryBookingRequests.
  ///
  /// In en, this message translates to:
  /// **'Nursery Booking Requests'**
  String get nurseryBookingRequests;

  /// No description provided for @icuBookingRequests.
  ///
  /// In en, this message translates to:
  /// **'ICU Booking Requests'**
  String get icuBookingRequests;

  /// No description provided for @noNurseryRequests.
  ///
  /// In en, this message translates to:
  /// **'No nursery booking requests at the moment'**
  String get noNurseryRequests;

  /// No description provided for @noIcuRequests.
  ///
  /// In en, this message translates to:
  /// **'No ICU booking requests at the moment'**
  String get noIcuRequests;

  /// No description provided for @requestDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Request Data'**
  String get requestDataTitle;

  /// No description provided for @acceptRequestButton.
  ///
  /// In en, this message translates to:
  /// **'Accept Request'**
  String get acceptRequestButton;

  /// No description provided for @rejectRequestButton.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get rejectRequestButton;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'No notifications'**
  String get noNotifications;

  /// No description provided for @notificationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You will be notified when there is any update.'**
  String get notificationsSubtitle;

  /// No description provided for @notifNewIcuRequest.
  ///
  /// In en, this message translates to:
  /// **'New booking request in ICU'**
  String get notifNewIcuRequest;

  /// No description provided for @notifRequestDetails.
  ///
  /// In en, this message translates to:
  /// **'Request Details'**
  String get notifRequestDetails;

  /// No description provided for @notifUnreviewedRequests.
  ///
  /// In en, this message translates to:
  /// **'Unreviewed booking requests'**
  String get notifUnreviewedRequests;

  /// No description provided for @notifBookingRequestsButton.
  ///
  /// In en, this message translates to:
  /// **'Booking Requests'**
  String get notifBookingRequestsButton;

  /// No description provided for @notifOneBedLeftNursery.
  ///
  /// In en, this message translates to:
  /// **'One nursery bed left'**
  String get notifOneBedLeftNursery;

  /// No description provided for @notifAvailablePlacesButton.
  ///
  /// In en, this message translates to:
  /// **'Available Places'**
  String get notifAvailablePlacesButton;

  /// No description provided for @notifIcuFullAlert.
  ///
  /// In en, this message translates to:
  /// **'Intensive care department is full'**
  String get notifIcuFullAlert;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @chooseDate.
  ///
  /// In en, this message translates to:
  /// **'Choose a date...'**
  String get chooseDate;

  /// No description provided for @profileUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdatedSuccess;

  /// No description provided for @profileUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update profile: {error}'**
  String profileUpdateFailed(String error);

  /// No description provided for @underDevelopment.
  ///
  /// In en, this message translates to:
  /// **'This section is currently under development'**
  String get underDevelopment;

  /// No description provided for @searchHospitalOrArea.
  ///
  /// In en, this message translates to:
  /// **'Search for area or hospital'**
  String get searchHospitalOrArea;

  /// No description provided for @failedToLoadNurseries.
  ///
  /// In en, this message translates to:
  /// **'Failed to load nurseries'**
  String get failedToLoadNurseries;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @noNurseriesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No nurseries available'**
  String get noNurseriesAvailable;

  /// No description provided for @addressLabel.
  ///
  /// In en, this message translates to:
  /// **'Address: {address}'**
  String addressLabel(String address);

  /// No description provided for @noServiceData.
  ///
  /// In en, this message translates to:
  /// **'No service data available'**
  String get noServiceData;

  /// No description provided for @hospitalAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Hospital Address: {address}'**
  String hospitalAddressLabel(String address);

  /// No description provided for @hospitalPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone: {phone}'**
  String hospitalPhoneLabel(String phone);

  /// No description provided for @forCases.
  ///
  /// In en, this message translates to:
  /// **'For cases:'**
  String get forCases;

  /// No description provided for @bookAction.
  ///
  /// In en, this message translates to:
  /// **'Book'**
  String get bookAction;

  /// No description provided for @unavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get unavailable;

  /// No description provided for @availableCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Available'**
  String availableCount(int count);

  /// No description provided for @medicalService.
  ///
  /// In en, this message translates to:
  /// **'Medical Service'**
  String get medicalService;

  /// No description provided for @hospital.
  ///
  /// In en, this message translates to:
  /// **'Hospital'**
  String get hospital;

  /// No description provided for @nurseryNicuOption.
  ///
  /// In en, this message translates to:
  /// **'Neonatal ICU (NICU)'**
  String get nurseryNicuOption;

  /// No description provided for @childNameHint.
  ///
  /// In en, this message translates to:
  /// **'Child Name'**
  String get childNameHint;

  /// No description provided for @phoneHint.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneHint;

  /// No description provided for @medicalConditionHint.
  ///
  /// In en, this message translates to:
  /// **'Medical Condition'**
  String get medicalConditionHint;

  /// No description provided for @pleaseCompleteBookingData.
  ///
  /// In en, this message translates to:
  /// **'Please complete the booking data'**
  String get pleaseCompleteBookingData;

  /// No description provided for @failedToLoadIcuServices.
  ///
  /// In en, this message translates to:
  /// **'Failed to load ICU services'**
  String get failedToLoadIcuServices;

  /// No description provided for @noIcuServicesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No ICU services available'**
  String get noIcuServicesAvailable;

  /// No description provided for @addressNotSpecified.
  ///
  /// In en, this message translates to:
  /// **'Address not specified'**
  String get addressNotSpecified;

  /// No description provided for @icuRequestForPatient.
  ///
  /// In en, this message translates to:
  /// **'ICU care request for patient: {name}'**
  String icuRequestForPatient(String name);

  /// No description provided for @newNurseryBookingForChild.
  ///
  /// In en, this message translates to:
  /// **'New nursery booking for child: {name}'**
  String newNurseryBookingForChild(String name);

  /// No description provided for @now.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get now;

  /// No description provided for @alertNurseryFull.
  ///
  /// In en, this message translates to:
  /// **'Alert: All nursery beds are full!'**
  String get alertNurseryFull;

  /// No description provided for @alertNurseryOneBed.
  ///
  /// In en, this message translates to:
  /// **'Alert: Only one nursery bed left!'**
  String get alertNurseryOneBed;

  /// No description provided for @alertIcuFull.
  ///
  /// In en, this message translates to:
  /// **'Alert: Adult ICU is completely full!'**
  String get alertIcuFull;

  /// No description provided for @alertIcuOneBed.
  ///
  /// In en, this message translates to:
  /// **'Alert: Only one adult ICU bed left!'**
  String get alertIcuOneBed;

  /// No description provided for @bookingData.
  ///
  /// In en, this message translates to:
  /// **'Booking Data'**
  String get bookingData;

  /// No description provided for @requestDetailsLabel.
  ///
  /// In en, this message translates to:
  /// **'Request Details'**
  String get requestDetailsLabel;

  /// No description provided for @conditionLabel.
  ///
  /// In en, this message translates to:
  /// **'Condition'**
  String get conditionLabel;

  /// No description provided for @hospitalName.
  ///
  /// In en, this message translates to:
  /// **'Benha University Hospital'**
  String get hospitalName;

  /// No description provided for @hospitalLocation.
  ///
  /// In en, this message translates to:
  /// **'Qalyubia, Benha, El-Eshara'**
  String get hospitalLocation;

  /// No description provided for @hospitalNameField.
  ///
  /// In en, this message translates to:
  /// **'Hospital Name'**
  String get hospitalNameField;

  /// No description provided for @serviceTypeField.
  ///
  /// In en, this message translates to:
  /// **'Service Type'**
  String get serviceTypeField;

  /// No description provided for @bookingStatusField.
  ///
  /// In en, this message translates to:
  /// **'Booking Status'**
  String get bookingStatusField;

  /// No description provided for @bookingDateField.
  ///
  /// In en, this message translates to:
  /// **'Booking Date'**
  String get bookingDateField;

  /// No description provided for @pendingStatus.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pendingStatus;

  /// No description provided for @confirmedStatus.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get confirmedStatus;

  /// No description provided for @viewBookingDetails.
  ///
  /// In en, this message translates to:
  /// **'View Booking Details'**
  String get viewBookingDetails;

  /// No description provided for @noBookingRequests.
  ///
  /// In en, this message translates to:
  /// **'No booking requests at the moment'**
  String get noBookingRequests;

  /// No description provided for @bookingRequestData.
  ///
  /// In en, this message translates to:
  /// **'Request Data'**
  String get bookingRequestData;

  /// No description provided for @requestAcceptedTitle.
  ///
  /// In en, this message translates to:
  /// **'Request Accepted'**
  String get requestAcceptedTitle;

  /// No description provided for @requestAcceptedMessage.
  ///
  /// In en, this message translates to:
  /// **'Your booking request has been accepted successfully'**
  String get requestAcceptedMessage;

  /// No description provided for @exitButton.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exitButton;
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
