// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get login => 'تسجيل دخول';

  @override
  String get email => 'الايميل';

  @override
  String get phoneNumber => 'رقم التليفون';

  @override
  String get emailAddress => 'البريد الإلكتروني';

  @override
  String get sendCode => 'ارسال الرمز';

  @override
  String get signIn => 'تسجيل';

  @override
  String get forgotPassword => 'هل نسيت كلمة المرور؟';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟ ';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get createAccountFor => 'إنشاء حساب لـ ';

  @override
  String get password => 'الرقم السري';

  @override
  String get signUp => 'إنشاء حساب';

  @override
  String get skip => 'تخطي';

  @override
  String get previous => 'السابق';

  @override
  String get next => 'التالي';

  @override
  String get start => 'ابدأ';

  @override
  String get onboardTitle1 => 'اعرف أماكن الحضانات المتاحة واحجز لطفلك بسهولة';

  @override
  String get onboardTitle2 =>
      'اعرف المستشفيات المتاح فيها عناية مركزة واحجز فورًا';

  @override
  String get onboardTitle3 =>
      'احجز أو اطلب طاقم طبي للمتابعة في المنزل أو أي مكان';

  @override
  String get otpVerification =>
      'أدخل رمز التحقق المكوّن من 6 أرقام الذي تم إرساله إلى رقم هاتفك.';

  @override
  String get resendCode => 'إعادة إرسال الرمز';

  @override
  String get phoneVerified => 'تم التحقق من رقم الهاتف';

  @override
  String get redirectToHome => 'سيتم تحويلك إلى الصفحة الرئيسية خلال لحظات';

  @override
  String get home => 'الرئيسية';

  @override
  String get nurseries => 'حضانات أطفال';

  @override
  String get icu => 'عناية مركزة';

  @override
  String get medicalStaff => 'طاقم طبي';

  @override
  String get patient => 'مستفيد';

  @override
  String get bookings => 'طلبات الحجز';

  @override
  String get myAccount => 'حسابي';

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navNurseries => 'حضانات';

  @override
  String get navIcu => 'عناية';

  @override
  String get navBookings => 'الحجوزات';

  @override
  String get navAccount => 'حسابي';

  @override
  String editProfile(String field) {
    return 'تعديل $field';
  }

  @override
  String get saveChanges => 'حفظ التعديلات';

  @override
  String get name => 'الاسم';

  @override
  String get address => 'العنوان';

  @override
  String get phoneLabel => 'رقم التليفون :';

  @override
  String get emailLabel => 'البريد الإلكتروني :';

  @override
  String get passwordLabel => 'الرقم السري';

  @override
  String navigatingTo(String title) {
    return 'الانتقال إلى $title';
  }

  @override
  String get invalidEmail => 'أدخل بريداً صالحاً ينتهي بـ com أو net أو edu';

  @override
  String get noConnectionText => 'Please check your internet connection';

  @override
  String get gender => 'النوع';

  @override
  String get male => 'ذكر';

  @override
  String get female => 'أنثى';

  @override
  String get uploadVerificationDoc => 'إرسال مستند للتحقق (مطلوب للطاقم الطبي)';

  @override
  String get documentUploaded => 'تم إرفاق المستند';

  @override
  String get networkError =>
      'لا يوجد اتصال بالإنترنت. تحقق من الشبكة وحاول مرة أخرى.';

  @override
  String get networkTimeout =>
      'انتهت مهلة الاتصال بالخادم. حاول مرة أخرى بعد قليل.';

  @override
  String get unexpectedError => 'حدث خطأ غير متوقع. حاول مرة أخرى.';

  @override
  String get invalidPassword => 'يجب أن تتكون كلمة المرور من 6 أحرف على الأقل';

  @override
  String get invalidPhone => 'يرجى إدخال رقم هاتف صحيح';

  @override
  String get emptyField => 'هذا الحقل لا يمكن أن يكون فارغاً';

  @override
  String get validationSuccess => 'تم التحقق بنجاح';

  @override
  String get validationError => 'يرجى تصحيح الأخطاء الموضحة في الحقول';

  @override
  String get searchCountry => 'بحث عن دولة...';

  @override
  String get username => 'اسم المستخدم';

  @override
  String get confirmPassword => 'تأكيد الرقم السري';

  @override
  String get alreadyHaveAccount => 'لدي حساب بالفعل؟ ';

  @override
  String get medicalStaffServiceDesc =>
      'خدمة متابعة ورعاية المرضى\nأو الأطفال في المنزل أو أي مكان';

  @override
  String get elderlyCare => 'رعاية كبار السن';

  @override
  String get postSurgeryCare => 'رعاية بعد العمليات';

  @override
  String get newbornFollowUp => 'متابعة الأطفال حديثي الولادة';

  @override
  String get patientName => 'اسم المريض';

  @override
  String get addressOrLocation => 'العنوان او المكان';

  @override
  String get medicalCondition => 'الحالة الطبيه';

  @override
  String get confirmBooking => 'تأكيد الحجز';

  @override
  String get requestDetails => 'بيانات الطلب';

  @override
  String get medicalStaffBooking => 'حجز طاقم طبي';

  @override
  String get notSpecified => 'غير محدد';

  @override
  String get bookingRequestSent => 'تم إرسال طلب الحجز';

  @override
  String get bookingRequests => 'طلبات الحجز';

  @override
  String get backToHome => 'العودة للرئيسية';

  @override
  String get condition => 'الحالة';

  @override
  String get serviceType => 'نوع الخدمة';

  @override
  String get personalInformation => 'البيانات الشخصية';

  @override
  String get editProfileInformation => 'تعديل بيانات الحساب';

  @override
  String get phoneEmailPassword => 'الهاتف، البريد، وكلمة السر';

  @override
  String get appSettings => 'إعدادات التطبيق';

  @override
  String get language => 'اللغة';

  @override
  String get support => 'الدعم الفني';

  @override
  String get aboutShefa => 'حول شفا';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get darkMode => 'الوضع الليلي';

  @override
  String get lightMode => 'الوضع النهاري';

  @override
  String get reviews => 'تقييمات';

  @override
  String get status => 'الحالة';

  @override
  String get active => 'نشط';

  @override
  String get arabic => 'العربية';

  @override
  String get english => 'الإنجليزية';

  @override
  String get loadingRingPreviewTitle => 'دائرة التحميل';

  @override
  String get loadingRingPreviewMenu => 'تصميم دائرة التحميل';

  @override
  String get loadingRingPreviewHint =>
      'لمعة الاسم تستخدم ألوان الهوية؛ يمكنك تغيير النص أو الحجم من الكود حيث تعرض التحميل.';

  @override
  String get loadingRingPreviewBrandedCaption => 'لمعة الاسم (الافتراضي)';

  @override
  String get loadingRingPreviewClassicCaption => 'نسخة الدائرة (واجهات مدمجة)';

  @override
  String get accountCreatedSuccess => 'تم إنشاء الحساب بنجاح';

  @override
  String get otpIncompleteCode => 'يرجى إدخال رمز التحقق المكوّن من 6 أرقام';

  @override
  String get verify => 'تحقق';

  @override
  String get passwordsDoNotMatch => 'كلمتا المرور غير متطابقتين';

  @override
  String otpEnterCodeForEmail(String email) {
    return 'أدخل رمز التحقق المكوّن من 6 أرقام المرسل إلى البريد:\n$email';
  }

  @override
  String get acceptedBookings => 'الحجوزات المقبولة';

  @override
  String get rejectedBookings => 'الحجوزات المرفوضة';

  @override
  String get childNameLabel => 'اسم الطفل';

  @override
  String get patientNameLabel => 'اسم المريض';

  @override
  String get phoneLabelText => 'رقم التليفون';

  @override
  String get serviceTypeLabel => 'نوع الخدمة';

  @override
  String get statusLabel => 'الحالة';

  @override
  String get acceptedStatus => 'مقبول';

  @override
  String get rejectedStatus => 'مرفوض';

  @override
  String get detailsButton => 'التفاصيل';

  @override
  String get bookingsTitle => 'الحجوزات';

  @override
  String get bookingDetailsTitle => 'تفاصيل الحجز';

  @override
  String get detailedRequestData => 'بيانات الطلب التفصيلية';

  @override
  String get deleteRequestButton => 'حذف الطلب';

  @override
  String get areYouSureDialogTitle => 'هل انت متأكد ؟';

  @override
  String get confirmDeleteButton => 'تأكيد الحذف';

  @override
  String get backButtonText => 'رجوع';

  @override
  String get editDataTitle => 'تعديل البيانات والأماكن المتاحة';

  @override
  String get availableNurseriesHeader => 'الأماكن المتاحة للحضانات:';

  @override
  String get availableIcuHeader => 'الأماكن المتاحة للعناية المركزة:';

  @override
  String get totalBedsHeader => 'إجمالي عدد الأسرة:';

  @override
  String get nurseryKidsLabel => 'حضانات أطفال';

  @override
  String get nurseryNicuLabel => 'العناية لحديثي الولادة (NICU)';

  @override
  String get icuAdultsLabel => 'عناية مركزة للكبار (ICU)';

  @override
  String get icuCcuLabel => 'عناية القلب (CCU)';

  @override
  String get icuPicuLabel => 'عناية أطفال (PICU)';

  @override
  String get totalNurseryBedsLabel => 'إجمالي أسرة الحضانات';

  @override
  String get totalIcuBedsLabel => 'إجمالي أسرة العناية';

  @override
  String get bookingOverviewTitle => 'نبذة عامة للحجوزات';

  @override
  String get todayLabel => 'اليوم';

  @override
  String get totalBookingRequestsCard => 'إجمالي\nطلبات الحجز';

  @override
  String get nurseriesCard => 'الحضانات';

  @override
  String get icuCard => 'العناية المركزة';

  @override
  String get kidsSub => 'اطفال 🍼';

  @override
  String get nicuSub => 'NICU 👶';

  @override
  String get icuSub => 'ICU 🏥';

  @override
  String get ccuSub => 'CCU ❤️';

  @override
  String get picuSub => 'PICU 👶';

  @override
  String get availablePlacesLabel => 'الاماكن المتاحة';

  @override
  String get nurseriesBedsTotalLabel => 'عدد الاسره الكلي للحضانات';

  @override
  String get icuBedsTotalLabel => 'عدد الاسره الكلي للعناية';

  @override
  String get editDataButton => 'تعديل البيانات';

  @override
  String get nurseryBookingRequests => 'طلبات حجز حضانات الأطفال';

  @override
  String get icuBookingRequests => 'طلبات حجز العناية المركزة';

  @override
  String get noNurseryRequests => 'لا يوجد طلبات حجز حضانات حالياً';

  @override
  String get noIcuRequests => 'لا يوجد طلبات حجز عناية مركزة حالياً';

  @override
  String get requestDataTitle => 'بيانات الطلب';

  @override
  String get acceptRequestButton => 'قبول الطلب';

  @override
  String get rejectRequestButton => 'رفض';

  @override
  String get notificationsTitle => 'الاشعارات';

  @override
  String get noNotifications => 'لا يوجد اشعارات';

  @override
  String get notificationsSubtitle => 'سيتم إشعارك عند حدوث أي تحديث.';

  @override
  String get notifNewIcuRequest => 'طلب حجز جديد في العناية المركزة ICU';

  @override
  String get notifRequestDetails => 'تفاصيل الطلب';

  @override
  String get notifUnreviewedRequests => 'طلبات حجز لم يتم مراجعتها';

  @override
  String get notifBookingRequestsButton => 'طلبات الحجز';

  @override
  String get notifOneBedLeftNursery => 'متبقي سرير واحد في الحضانة';

  @override
  String get notifAvailablePlacesButton => 'الاماكن المتاحه';

  @override
  String get notifIcuFullAlert => 'قسم العناية ممتلئ';

  @override
  String get hospitalName => 'مستشفى بنها الجامعي';

  @override
  String get hospitalLocation => 'القليوبية، بنها، الإشارة';
}
