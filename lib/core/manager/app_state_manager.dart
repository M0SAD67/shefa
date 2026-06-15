import 'package:flutter/material.dart';
import '../cache/cache_helper.dart';
import '../../features/hospital/nursery_request_model.dart';
import '../../features/hospital/icu_request_model.dart';
import '../../features/hospital/hospital_repository.dart';
import '../utils/api.dart';
import '../utils/api_service.dart';

class AppStateManager extends ChangeNotifier {
  // Singleton pattern for easy access if needed,
  // though using it via Provider/ListenableBuilder is better.
  static final AppStateManager _instance = AppStateManager._internal();
  factory AppStateManager() => _instance;
  AppStateManager._internal();

  ThemeMode _themeMode = ThemeMode.light;
  Locale _locale = const Locale('ar');

  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;

  bool get isDarkMode => _themeMode == ThemeMode.dark;
  bool get isArabic => _locale.languageCode == 'ar';

  static const String _themeKey = 'themeMode';
  static const String _langKey = 'languageCode';
  static const String _genderKey = 'userGender';
  static const String _roleKey = 'userRole';

  String _gender = 'male';
  String get gender => _gender;
  bool get isFemale => _gender == 'female';

  int _userRole = 0; // 0 for patient, 1 for hospital
  int get userRole => _userRole;
  bool get isHospital => _userRole == 1;

  String _userName = "";
  String _userEmail = "";
  String _userPhone = "";
  String _userAddress = "";
  String _profileImage = "";

  String get userName => _userName;
  String get userEmail => _userEmail;
  String get userPhone => _userPhone;
  String get userAddress => _userAddress;
  String get profileImage => _profileImage;
  // عدد الاشعارات الغير مقروءة (يستخدمه الهيدر لعرض الشارة)
  int get unreadNotificationsCount {
    try {
      return apiNotifications.where((n) => n['badge'] != null).length;
    } catch (_) {
      return 0;
    }
  }

  void setUserProfile({
    String? name,
    String? email,
    String? phone,
    String? address,
    String? profileImage,
  }) {
    if (name != null && name.isNotEmpty) _userName = name;
    if (email != null && email.isNotEmpty) _userEmail = email;
    if (phone != null && phone.isNotEmpty) _userPhone = phone;
    if (address != null && address.isNotEmpty) _userAddress = address;
    if (profileImage != null && profileImage.isNotEmpty) {
      _profileImage = _normalizeImageUrl(profileImage);
    }
    notifyListeners();

    if (name != null && name.isNotEmpty)
      CacheHelper.saveData(key: 'profile_name', value: name);
    if (email != null && email.isNotEmpty)
      CacheHelper.saveData(key: 'profile_email', value: email);
    if (phone != null && phone.isNotEmpty)
      CacheHelper.saveData(key: 'profile_phone', value: phone);
    if (address != null && address.isNotEmpty)
      CacheHelper.saveData(key: 'profile_address', value: address);
    if (profileImage != null && profileImage.isNotEmpty) {
      CacheHelper.saveData(key: 'profile_image', value: _profileImage);
    }
  }

  String _normalizeImageUrl(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return '';
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }
    if (trimmed.startsWith('/')) {
      return '${Api.baseUrl}$trimmed';
    }
    return '${Api.baseUrl}/$trimmed';
  }

  Future<void> fetchUserProfile() async {
    final token = CacheHelper.getData(key: 'token') as String?;
    if (token == null ||
        token == 'mock_hospital_token' ||
        token == 'mock_patient_token') {
      return;
    }

    try {
      dynamic data;
      try {
        final response = await apiService.get(
          path: Api.userProfile,
          token: token,
        );
        data = response.data;
      } catch (e) {
        debugPrint(
          'Failed to get profile from /user, trying /profile fallback: $e',
        );
        try {
          final responseFallback = await apiService.get(
            path: '/profile',
            token: token,
          );
          data = responseFallback.data;
        } catch (fallbackError) {
          debugPrint('Error fetching fallback profile: $fallbackError');
          return;
        }
      }

      if (data == null) return;

      final account =
          data['data']?['account'] ??
          data['account'] ??
          data['data']?['user'] ??
          data['user'] ??
          data['data'] ??
          data;

      if (account == null) return;

      final rawRole = account['role'];
      final role = rawRole is int
          ? rawRole
          : int.tryParse(rawRole?.toString() ?? '') ?? _userRole;
      setUserRole(role == 1 ? 1 : 0);

      final name =
          account['username']?.toString() ??
          (account['firstName'] != null || account['lastName'] != null
              ? '${account['firstName'] ?? ''} ${account['lastName'] ?? ''}'
                    .trim()
              : '');

      final genderValue = account['gender'];
      if (genderValue != null) {
        final genderText = genderValue.toString();
        if (genderText == '2' || genderText.toLowerCase() == 'female') {
          setGender('female');
        } else if (genderText == '1' || genderText.toLowerCase() == 'male') {
          setGender('male');
        }
      }

      setUserProfile(
        name: name.isNotEmpty ? name : null,
        email: account['email']?.toString(),
        phone: account['phone']?.toString(),
        address: account['address']?.toString(),
        profileImage:
            account['profilePicture']?.toString() ??
            account['avatar']?.toString() ??
            account['image']?.toString() ??
            account['photo']?.toString(),
      );
    } catch (e) {
      debugPrint('Error fetching user profile for header: $e');
    }
  }

  // Hospital Dashboard & Operations State
  int nurseriesKids = 5;
  int nurseriesNicu = 5;
  int icuAdults = 5;
  int icuCcu = 5;
  int icuPicu = 5;

  int totalNurseryBeds = 55;
  int totalIcuBeds = 55;

  // API IDs tracking
  String? hospitalId;
  String? kidsServiceId;
  String? nicuServiceId;
  String? adultsServiceId;
  String? ccuServiceId;
  String? picuServiceId;

  List<NurseryRequest> nurseryRequests = [];

  List<IcuRequest> icuRequests = [];

  List<Map<String, dynamic>> apiNotifications = [];

  // Accepted/Rejected bookings for HospitalBookingsScreen
  List<dynamic> acceptedBookings = [];
  List<dynamic> rejectedBookings = [];
  bool isLoadingReservations = false;

  List<dynamic> patientBookings = [];
  bool isLoadingBookings = false;

  Future<void> acceptNursery(NurseryRequest request) async {
    nurseryRequests.removeWhere(
      (r) => r.childName == request.childName && r.time == request.time,
    );
    if (request.serviceType.contains('حديثي') ||
        request.serviceType.contains('NICU')) {
      if (nurseriesNicu > 0) nurseriesNicu--;
    } else {
      if (nurseriesKids > 0) nurseriesKids--;
    }
    // Add to accepted bookings
    acceptedBookings.add(
      NurseryRequest(
        id: request.id,
        childName: request.childName,
        phone: request.phone,
        status: 'مقبول - تم تأكيد الحجز',
        serviceType: request.serviceType,
        time: request.time,
      ),
    );
    // Sync status to patient bookings list
    _updatePatientBookingStatus(request.id, request.childName, 'confirmed');
    notifyListeners();

    final token = CacheHelper.getData(key: 'token') as String?;
    if (token != null &&
        token != 'mock_hospital_token' &&
        token != 'mock_patient_token') {
      if (request.id != null) {
        try {
          await hospitalRepository.updateReservationStatus(
            reservationId: request.id!,
            isChildcare: true,
            action: 'accept',
            token: token,
          );
        } catch (e) {
          debugPrint('Error accepting nursery: $e');
        }
      }
    }
  }

  Future<void> rejectNursery(NurseryRequest request) async {
    nurseryRequests.removeWhere(
      (r) => r.childName == request.childName && r.time == request.time,
    );
    // Also remove from accepted if it was previously accepted
    acceptedBookings.removeWhere(
      (r) => r is NurseryRequest && r.childName == request.childName,
    );
    // Add to rejected bookings
    rejectedBookings.add(
      NurseryRequest(
        id: request.id,
        childName: request.childName,
        phone: request.phone,
        status: 'مرفوض',
        serviceType: request.serviceType,
        time: request.time,
      ),
    );
    // Sync status to patient bookings list
    _updatePatientBookingStatus(request.id, request.childName, 'rejected');
    notifyListeners();

    final token = CacheHelper.getData(key: 'token') as String?;
    if (token != null &&
        token != 'mock_hospital_token' &&
        token != 'mock_patient_token') {
      if (request.id != null) {
        try {
          await hospitalRepository.updateReservationStatus(
            reservationId: request.id!,
            isChildcare: true,
            action: 'refuse',
            token: token,
          );
        } catch (e) {
          debugPrint('Error refusing nursery: $e');
        }
      }
    }
  }

  Future<void> acceptIcu(IcuRequest request) async {
    icuRequests.removeWhere(
      (r) => r.patientName == request.patientName && r.time == request.time,
    );
    if (request.serviceType.contains('الكبار') ||
        request.serviceType.contains('ICU')) {
      if (icuAdults > 0) icuAdults--;
    } else if (request.serviceType.contains('القلب') ||
        request.serviceType.contains('CCU')) {
      if (icuCcu > 0) icuCcu--;
    } else {
      if (icuPicu > 0) icuPicu--;
    }
    // Add to accepted bookings
    acceptedBookings.add(
      IcuRequest(
        id: request.id,
        patientName: request.patientName,
        phone: request.phone,
        status: 'مقبول - تم حجز السرير',
        serviceType: request.serviceType,
        time: request.time,
      ),
    );
    // Sync status to patient bookings list
    _updatePatientBookingStatus(request.id, request.patientName, 'confirmed');
    notifyListeners();

    final token = CacheHelper.getData(key: 'token') as String?;
    if (token != null &&
        token != 'mock_hospital_token' &&
        token != 'mock_patient_token') {
      if (request.id != null) {
        try {
          await hospitalRepository.updateReservationStatus(
            reservationId: request.id!,
            isChildcare: false,
            action: 'accept',
            token: token,
          );
        } catch (e) {
          debugPrint('Error accepting ICU: $e');
        }
      }
    }
  }

  Future<void> rejectIcu(IcuRequest request) async {
    icuRequests.removeWhere(
      (r) => r.patientName == request.patientName && r.time == request.time,
    );
    // Also remove from accepted if it was previously accepted
    acceptedBookings.removeWhere(
      (r) => r is IcuRequest && r.patientName == request.patientName,
    );
    // Add to rejected bookings
    rejectedBookings.add(
      IcuRequest(
        id: request.id,
        patientName: request.patientName,
        phone: request.phone,
        status: 'مرفوض',
        serviceType: request.serviceType,
        time: request.time,
      ),
    );
    // Sync status to patient bookings list
    _updatePatientBookingStatus(request.id, request.patientName, 'rejected');
    notifyListeners();

    final token = CacheHelper.getData(key: 'token') as String?;
    if (token != null &&
        token != 'mock_hospital_token' &&
        token != 'mock_patient_token') {
      if (request.id != null) {
        try {
          await hospitalRepository.updateReservationStatus(
            reservationId: request.id!,
            isChildcare: false,
            action: 'refuse',
            token: token,
          );
        } catch (e) {
          debugPrint('Error refusing ICU: $e');
        }
      }
    }
  }

  /// Updates [patientBookings] list entry status so the patient sees the
  /// hospital's accept/reject decision immediately (works in both mock and API mode).
  void _updatePatientBookingStatus(String? id, String name, String newStatus) {
    for (final booking in patientBookings) {
      if (booking is! Map) continue;
      // Match by id if available
      final String bookingId = booking['_id']?.toString() ?? booking['id']?.toString() ?? '';
      if (id != null && id.isNotEmpty && bookingId == id) {
        booking['status'] = newStatus;
        return;
      }
      // Fallback: match by name inside reservationDetails
      final details = booking['reservationDetails'];
      if (details is Map) {
        final String detailName =
            details['childName']?.toString() ??
            details['patientName']?.toString() ??
            '';
        if (detailName.isNotEmpty && detailName == name) {
          booking['status'] = newStatus;
          return;
        }
      }
    }
  }

  Future<void> fetchHospitalData(String token, String username) async {
    if (token == 'mock_hospital_token' || token == 'mock_patient_token') {
      nurseriesKids = 5;
      nurseriesNicu = 5;
      icuAdults = 5;
      icuCcu = 5;
      icuPicu = 5;
      notifyListeners();
      return;
    }

    try {
      final homeData = await hospitalRepository.getHospitalHome(token);
      if (homeData != null) {
        final hospital = homeData['hospital'];
        if (hospital != null) {
          final String hName = hospital['name']?.toString() ?? '';
          final locationObj = hospital['location'];
          String hAddress = '';
          if (locationObj != null) {
            hAddress =
                locationObj['address']?.toString() ?? locationObj.toString();
          }
          final String hPhone = hospital['phone']?.toString() ?? '';

          setUserProfile(
            name: hName.isNotEmpty ? hName : null,
            address: hAddress.isNotEmpty ? hAddress : null,
            phone: hPhone.isNotEmpty ? hPhone : null,
            profileImage:
                hospital['logo']?.toString() ??
                hospital['profilePicture']?.toString() ??
                hospital['image']?.toString(),
          );
        }

        // Try parsing capacities and service IDs from "places" first (standard backend model)
        final placesObj = homeData['places'];
        if (placesObj != null) {
          debugPrint(
            'Parsing capacities and service IDs from places object...',
          );
          // 1. Childcare
          final childcareObj = placesObj['childcare'];
          if (childcareObj != null && childcareObj['items'] != null) {
            final List<dynamic> items = childcareObj['items'];
            for (final item in items) {
              final String key = item['key']?.toString() ?? '';
              final int capacity = (item['capacity'] as num?)?.toInt() ?? 0;
              final List<dynamic> itemServices = item['services'] ?? [];
              final String serviceId = itemServices.isNotEmpty
                  ? (itemServices.first['_id']?.toString() ?? '')
                  : '';

              if (key == 'normal') {
                nurseriesKids = capacity;
                if (serviceId.isNotEmpty) kidsServiceId = serviceId;
              } else if (key == 'nicu') {
                nurseriesNicu = capacity;
                if (serviceId.isNotEmpty) nicuServiceId = serviceId;
              }
            }
          }

          // 2. Healthcare
          final healthcareObj = placesObj['healthcare'];
          if (healthcareObj != null && healthcareObj['items'] != null) {
            final List<dynamic> items = healthcareObj['items'];
            for (final item in items) {
              final String key = item['key']?.toString() ?? '';
              final int capacity = (item['capacity'] as num?)?.toInt() ?? 0;
              final List<dynamic> itemServices = item['services'] ?? [];
              final String serviceId = itemServices.isNotEmpty
                  ? (itemServices.first['_id']?.toString() ?? '')
                  : '';

              if (key == 'icu') {
                icuAdults = capacity;
                if (serviceId.isNotEmpty) adultsServiceId = serviceId;
              } else if (key == 'ccu') {
                icuCcu = capacity;
                if (serviceId.isNotEmpty) ccuServiceId = serviceId;
              } else if (key == 'picu') {
                icuPicu = capacity;
                if (serviceId.isNotEmpty) picuServiceId = serviceId;
              }
            }
          }

          totalNurseryBeds = nurseriesKids + nurseriesNicu;
          totalIcuBeds = icuAdults + icuCcu + icuPicu;
        } else if (hospital != null && hospital['services'] != null) {
          // Fallback to manual services list search
          final List<dynamic> services = hospital['services'];
          debugPrint('=== Hospital Services Fallback (${services.length}) ===');
          for (final service in services) {
            final String name = service['name']?.toString() ?? '';
            final String type = service['type']?.toString() ?? '';
            final int capacity = (service['capacity'] as num?)?.toInt() ?? 0;
            final String id = service['_id']?.toString() ?? '';

            final bool isNurseryType = type == "حضانات أطفال";
            final bool isIcuType =
                type == "عناية مركزة" || type == "مركز عناية";

            if (isNurseryType ||
                (!isIcuType &&
                    (name.contains("حضانة") || name.contains("حضانات")))) {
              if (name.contains("حديثي") ||
                  name.contains("ولادة") ||
                  name.toLowerCase().contains("nicu")) {
                nurseriesNicu = capacity;
                nicuServiceId = id;
              } else {
                nurseriesKids = capacity;
                kidsServiceId = id;
              }
            } else if (isIcuType ||
                name.contains("عناية") ||
                name.contains("رعاية")) {
              if (name.contains("الكبار") ||
                  name.contains("بالغين") ||
                  name.toLowerCase().contains("icu")) {
                icuAdults = capacity;
                adultsServiceId = id;
              } else if (name.contains("القلب") ||
                  name.toLowerCase().contains("ccu")) {
                icuCcu = capacity;
                ccuServiceId = id;
              } else {
                icuPicu = capacity;
                picuServiceId = id;
              }
            }
          }

          totalNurseryBeds = nurseriesKids + nurseriesNicu;
          totalIcuBeds = icuAdults + icuCcu + icuPicu;
        }

        // Parse notifications (flexible parsing to support all backend response formats)
        final notificationsObj = homeData['notifications'] ?? homeData['latestNotifications'] ?? homeData['items'];
        List<dynamic> latestList = [];
        if (notificationsObj is List) {
          latestList = notificationsObj;
        } else if (notificationsObj is Map) {
          if (notificationsObj['latest'] is List) {
            latestList = notificationsObj['latest'];
          } else if (notificationsObj['items'] is List) {
            latestList = notificationsObj['items'];
          } else if (notificationsObj['notifications'] is List) {
            latestList = notificationsObj['notifications'];
          }
        }

        apiNotifications = latestList.map((notif) {
          if (notif is! Map) return <String, dynamic>{};
          final String id = notif['_id']?.toString() ?? notif['id']?.toString() ?? '';
          final String title = notif['title']?.toString() ?? '';
          final String message = notif['message']?.toString() ?? notif['body']?.toString() ?? notif['description']?.toString() ?? '';
          final String route = notif['route']?.toString() ?? notif['action']?.toString() ?? notif['type']?.toString() ?? '';
          final bool isRead = (notif['isRead'] ?? notif['read']) as bool? ?? false;
          final String createdAt = notif['createdAt']?.toString() ?? notif['date']?.toString() ?? notif['time']?.toString() ?? '';

          // Map route to internal action
          String action = 'home';
          String buttonText = 'عرض التفاصيل';
          if (route.contains('childcare') || route.contains('nursery') || route.contains('booking')) {
            action = 'requests';
            buttonText = 'طلبات الحجوزات';
          } else if (route.contains('healthcare') || route.contains('icu') || route.contains('care')) {
            action = 'icu';
            buttonText = 'طلبات العناية';
          }

          return <String, dynamic>{
            'id': id,
            'title': title,
            'message': message,
            'time': createdAt,
            'badge': isRead ? null : '1',
            'buttonText': buttonText,
            'action': action,
          };
        }).where((element) => element.isNotEmpty).toList();

        final List<dynamic> requests = homeData['requests'] ?? [];
        final List<NurseryRequest> newNurseryRequests = [];
        final List<IcuRequest> newIcuRequests = [];

        for (final req in requests) {
          final String id = req['_id']?.toString() ?? '';
          final String status = req['status']?.toString() ?? 'pending';
          final String dateStr = req['createdAt']?.toString() ?? '';
          final String phone = req['phone']?.toString() ?? '';
          final String patientName =
              req['patientName']?.toString() ??
              req['childName']?.toString() ??
              '';
          final serviceObj = req['service'];
          final String serviceName = serviceObj != null
              ? (serviceObj['name']?.toString() ?? '')
              : '';
          final String serviceType = serviceObj != null
              ? (serviceObj['type']?.toString() ?? '')
              : '';

          // Differentiate by service type, not by field name
          final bool isChildcare =
              serviceType == 'حضانات أطفال' ||
              serviceName.contains('حضانة') ||
              serviceName.contains('حضانات') ||
              serviceName.toLowerCase().contains('nicu');

          if (isChildcare) {
            newNurseryRequests.add(
              NurseryRequest(
                id: id,
                childName: patientName.isNotEmpty ? patientName : 'طفل',
                phone: phone,
                status: status == 'pending'
                    ? 'قيد الانتظار'
                    : (status == 'confirmed' ? 'تم القبول' : 'تم الرفض'),
                serviceType: serviceName,
                time: dateStr,
              ),
            );
          } else {
            newIcuRequests.add(
              IcuRequest(
                id: id,
                patientName: patientName.isNotEmpty ? patientName : 'مريض',
                phone: phone,
                status: status == 'pending'
                    ? 'قيد الانتظار'
                    : (status == 'confirmed' ? 'تم القبول' : 'تم الرفض'),
                serviceType: serviceName,
                time: dateStr,
              ),
            );
          }
        }

        nurseryRequests = newNurseryRequests;
        icuRequests = newIcuRequests;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error fetching hospital data: $e');
    }
  }

  Future<void> fetchBookings() async {
    final token = CacheHelper.getData(key: 'token') as String?;
    if (token == 'mock_hospital_token' || token == 'mock_patient_token') {
      nurseryRequests = [
        NurseryRequest(
          childName: 'أحمد محمد',
          phone: '0100000000',
          status: 'حالة غير مستقرة، تنفس صناعي ومتابعة مستمرة',
          serviceType: 'حضانات أطفال',
          time: '5:54 PM - 10 Jan 2026',
        ),
        NurseryRequest(
          childName: 'سارة علي',
          phone: '0111111111',
          status: 'حالة متوسطة، صفراء وتغذية علاجية',
          serviceType: 'العناية لحديثي الولادة (NICU)',
          time: '3:20 PM - 11 Jan 2026',
        ),
        NurseryRequest(
          childName: 'محمود حسن',
          phone: '0122222222',
          status: 'مبتسر، وزن ناقص وصعوبة تنفس',
          serviceType: 'حضانات أطفال',
          time: '1:10 PM - 12 Jan 2026',
        ),
      ];

      icuRequests = [
        IcuRequest(
          patientName: 'أحمد محمد',
          phone: '0100000000',
          status: 'فشل تنفسي حاد، غير مستقر',
          serviceType: 'عناية مركزة للكبار (ICU)',
          time: '5:54 PM - 10 Jan 2026',
        ),
        IcuRequest(
          patientName: 'سارة علي',
          phone: '0111111111',
          status: 'جلطة دماغية، تحت الملاحظة',
          serviceType: 'عناية القلب (CCU)',
          time: '3:20 PM - 11 Jan 2026',
        ),
        IcuRequest(
          patientName: 'محمود حسن',
          phone: '0122222222',
          status: 'أزمة قلبية حادة، رعاية فائقة',
          serviceType: 'عناية القلب (CCU)',
          time: '1:10 PM - 12 Jan 2026',
        ),
      ];

      // Mock accepted/rejected for development
      acceptedBookings = [
        NurseryRequest(
          childName: 'أحمد محمود',
          phone: '0123456789',
          status: 'مقبول - تم تأكيد الحجز',
          serviceType: 'حضانات اطفال',
          time: '5:54 PM - 10 Jan 2026',
        ),
        IcuRequest(
          patientName: 'سيد علي',
          phone: '0111111111',
          status: 'مقبول - تم حجز السرير',
          serviceType: 'عناية مركزة للكبار (ICU)',
          time: '6:00 PM - 10 Jan 2026',
        ),
      ];
      rejectedBookings = [
        IcuRequest(
          patientName: 'محمد إبراهيم',
          phone: '0100000000',
          status: 'لا توجد أسرة خالية حالياً',
          serviceType: 'عناية مركزة للكبار (ICU)',
          time: '9:00 AM - 11 Jan 2026',
        ),
        NurseryRequest(
          childName: 'طفل غير محدد (مرفوض)',
          phone: '0122222222',
          status: 'الحالة لا تستدعي حضانة',
          serviceType: 'حضانات اطفال',
          time: '10:30 AM - 11 Jan 2026',
        ),
      ];
      notifyListeners();
      return;
    }

    if (token != null) {
      await fetchHospitalData(token, "");
      await fetchReservations();
    }
  }

  /// Fetches reservations from API and splits them into pending requests, and accepted/rejected bookings
  Future<void> fetchReservations() async {
    final token = CacheHelper.getData(key: 'token') as String?;
    if (token == null) return;

    isLoadingReservations = true;
    notifyListeners();

    final List<NurseryRequest> newNurseryRequests = [];
    final List<IcuRequest> newIcuRequests = [];
    final List<dynamic> newAccepted = [];
    final List<dynamic> newRejected = [];

    // --- Helper to parse data into request objects ---
    void parseAndAddRequest(
      Map<String, dynamic> res,
      bool isChildcare,
      String defaultStatus,
      List<dynamic> targetList,
    ) {
      final String id = res['_id']?.toString() ?? '';
      final String status = res['status']?.toString() ?? defaultStatus;
      final String dateStr = res['createdAt']?.toString() ?? '';

      final details = res['reservationDetails'];
      final String phone =
          details?['phone']?.toString() ?? res['phone']?.toString() ?? '';
      final String patientName =
          details?['patientName']?.toString() ??
          details?['childName']?.toString() ??
          res['childName']?.toString() ??
          res['patientName']?.toString() ??
          (isChildcare ? 'طفل' : 'مريض');
      final String condition =
          details?['condition']?.toString() ?? res['condition']?.toString() ?? '';

      final serviceObj = res['service'] ?? res['serviceId'];
      final String serviceName = serviceObj is Map
          ? (serviceObj['name']?.toString() ??
                (isChildcare ? 'حضانات أطفال' : 'عناية مركزة'))
          : (isChildcare ? 'حضانات أطفال' : 'عناية مركزة');

      if (isChildcare) {
        targetList.add(
          NurseryRequest(
            id: id,
            childName: patientName,
            phone: phone,
            status: status,
            serviceType: serviceName,
            time: dateStr,
            condition: condition,
          ),
        );
      } else {
        targetList.add(
          IcuRequest(
            id: id,
            patientName: patientName,
            phone: phone,
            status: status,
            serviceType: serviceName,
            time: dateStr,
            condition: condition,
          ),
        );
      }
    }

    try {
      // 1. Fetch pending childcare reservations
      final childcareList = await hospitalRepository.getChildcareReservations(
        token,
      );
      for (final res in childcareList) {
        parseAndAddRequest(res, true, 'قيد الانتظار', newNurseryRequests);
      }
    } catch (e) {
      debugPrint('Error fetching pending childcare reservations: $e');
    }

    try {
      // 2. Fetch pending healthcare reservations
      final healthcareList = await hospitalRepository.getHealthcareReservations(
        token,
      );
      for (final res in healthcareList) {
        parseAndAddRequest(res, false, 'قيد الانتظار', newIcuRequests);
      }
    } catch (e) {
      debugPrint('Error fetching pending healthcare reservations: $e');
    }

    try {
      // 3. Fetch accepted childcare bookings
      final acceptedChildcare = await hospitalRepository.getBookings(
        token: token,
        type: 'childcare',
        status: 'accepted',
      );
      for (final res in acceptedChildcare) {
        parseAndAddRequest(res, true, 'مقبول - تم تأكيد الحجز', newAccepted);
      }

      // 4. Fetch accepted healthcare bookings
      final acceptedHealthcare = await hospitalRepository.getBookings(
        token: token,
        type: 'healthcare',
        status: 'accepted',
      );
      for (final res in acceptedHealthcare) {
        parseAndAddRequest(res, false, 'مقبول - تم حجز السرير', newAccepted);
      }

      // 5. Fetch refused childcare bookings
      final refusedChildcare = await hospitalRepository.getBookings(
        token: token,
        type: 'childcare',
        status: 'refused',
      );
      for (final res in refusedChildcare) {
        parseAndAddRequest(res, true, 'مرفوض', newRejected);
      }

      // 6. Fetch refused healthcare bookings
      final refusedHealthcare = await hospitalRepository.getBookings(
        token: token,
        type: 'healthcare',
        status: 'refused',
      );
      for (final res in refusedHealthcare) {
        parseAndAddRequest(res, false, 'مرفوض', newRejected);
      }
    } catch (e) {
      debugPrint('Error fetching accepted/refused bookings: $e');
    }

    nurseryRequests = newNurseryRequests;
    icuRequests = newIcuRequests;
    acceptedBookings = newAccepted;
    rejectedBookings = newRejected;
    debugPrint(
      '=== FINAL: accepted=${newAccepted.length}, rejected=${newRejected.length}, pendingNursery=${newNurseryRequests.length}, pendingIcu=${newIcuRequests.length}',
    );
    isLoadingReservations = false;
    notifyListeners();
  }

  Future<void> fetchPatientBookings() async {
    final token = CacheHelper.getData(key: 'token') as String?;
    if (token == null) return;
    if (token == 'mock_hospital_token' || token == 'mock_patient_token') {
      patientBookings = [
        {
          'hospitalId': {'name': 'مستشفي بنها الجامعي'},
          'serviceId': {
            'name': 'عناية مركزة للكبار (ICU)',
            'type': 'عناية مركزة',
          },
          'status': 'confirmed',
          'createdAt': '2026-01-10T17:54:00.000Z',
        },
        {
          'hospitalId': {'name': 'حجز طاقم طبي'},
          'serviceId': {'name': 'رعاية كبار السن', 'type': 'طاقم طبي'},
          'status': 'pending',
          'createdAt': '2026-01-11T15:20:00.000Z',
        },
        {
          'hospitalId': {'name': 'مستشفي بنها الجامعي'},
          'serviceId': {'name': 'حضانات أطفال', 'type': 'حضانات أطفال'},
          'status': 'pending',
          'createdAt': '2026-01-12T13:10:00.000Z',
        },
      ];
      notifyListeners();
      return;
    }

    isLoadingBookings = true;
    notifyListeners();

    try {
      final response = await apiService.get(path: '/booking', token: token);
      final data = response.data;
      if (data != null && data['data'] != null) {
        patientBookings = data['data']['bookings'] as List<dynamic>? ?? [];
        if (patientBookings.isNotEmpty) {
          final firstBooking = patientBookings.first;
          final details = firstBooking['reservationDetails'];
          if (details != null) {
            final pName = details['patientName']?.toString();
            final pPhone = details['phone']?.toString();
            final pAddress = details['address']?.toString();

            if (_userName.isEmpty ||
                _userName == 'Patient User' ||
                _userAddress.isEmpty) {
              setUserProfile(
                name: (pName != null && pName.isNotEmpty) ? pName : null,
                phone: (pPhone != null && pPhone.isNotEmpty) ? pPhone : null,
                address: (pAddress != null && pAddress.isNotEmpty)
                    ? pAddress
                    : null,
              );
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Error fetching patient bookings: $e');
    } finally {
      isLoadingBookings = false;
      notifyListeners();
    }
  }

  Future<void> updateHospitalBeds({
    required int kids,
    required int nicu,
    required int adults,
    required int ccu,
    required int picu,
    required int totalNursery,
    required int totalIcu,
  }) async {
    nurseriesKids = kids;
    nurseriesNicu = nicu;
    icuAdults = adults;
    icuCcu = ccu;
    icuPicu = picu;
    totalNurseryBeds = totalNursery;
    totalIcuBeds = totalIcu;
    notifyListeners();

    final token = CacheHelper.getData(key: 'token') as String?;
    if (token != null &&
        token != 'mock_hospital_token' &&
        token != 'mock_patient_token') {
      try {
        if (kidsServiceId != null) {
          await hospitalRepository.updateServiceCapacity(
            serviceId: kidsServiceId!,
            capacity: kids,
            token: token,
          );
        }
        if (nicuServiceId != null) {
          await hospitalRepository.updateServiceCapacity(
            serviceId: nicuServiceId!,
            capacity: nicu,
            token: token,
          );
        }
        if (adultsServiceId != null) {
          await hospitalRepository.updateServiceCapacity(
            serviceId: adultsServiceId!,
            capacity: adults,
            token: token,
          );
        }
        if (ccuServiceId != null) {
          await hospitalRepository.updateServiceCapacity(
            serviceId: ccuServiceId!,
            capacity: ccu,
            token: token,
          );
        }
        if (picuServiceId != null) {
          await hospitalRepository.updateServiceCapacity(
            serviceId: picuServiceId!,
            capacity: picu,
            token: token,
          );
        }
      } catch (e) {
        debugPrint('Error saving capacities: $e');
      }
    }
  }

  void init() {
    final savedName = CacheHelper.getData(key: 'profile_name');
    if (savedName != null) _userName = savedName.toString();

    final savedEmail = CacheHelper.getData(key: 'profile_email');
    if (savedEmail != null) _userEmail = savedEmail.toString();

    final savedPhone = CacheHelper.getData(key: 'profile_phone');
    if (savedPhone != null) _userPhone = savedPhone.toString();

    final savedAddress = CacheHelper.getData(key: 'profile_address');
    if (savedAddress != null) _userAddress = savedAddress.toString();

    final savedImage = CacheHelper.getData(key: 'profile_image');
    if (savedImage != null) _profileImage = savedImage.toString();

    final savedTheme = CacheHelper.getData(key: _themeKey);
    if (savedTheme != null) {
      _themeMode = savedTheme == 'dark' ? ThemeMode.dark : ThemeMode.light;
    }

    final savedLang = CacheHelper.getData(key: _langKey);
    if (savedLang != null) {
      _locale = Locale(savedLang);
    }

    final savedGender = CacheHelper.getData(key: _genderKey);
    if (savedGender != null) {
      _gender = savedGender;
    }

    final savedRole = CacheHelper.getData(key: _roleKey);
    if (savedRole != null) {
      _userRole = savedRole is int
          ? savedRole
          : int.tryParse(savedRole.toString()) ?? 0;
    }
    notifyListeners();
  }

  Future<void> clearUserData() async {
    _userRole = 0;
    _userName = '';
    _userEmail = '';
    _userPhone = '';
    _userAddress = '';
    _profileImage = '';
    _gender = '';

    // Clear lists & data
    nurseryRequests = [];
    icuRequests = [];
    apiNotifications = [];
    acceptedBookings = [];
    rejectedBookings = [];
    patientBookings = [];

    // Clear service IDs
    hospitalId = null;
    kidsServiceId = null;
    nicuServiceId = null;
    adultsServiceId = null;
    ccuServiceId = null;
    picuServiceId = null;

    await CacheHelper.removeData(key: 'token');
    await CacheHelper.removeData(key: 'email');
    await CacheHelper.removeData(key: _roleKey);
    await CacheHelper.removeData(key: _genderKey);
    await CacheHelper.removeData(key: 'profile_name');
    await CacheHelper.removeData(key: 'profile_email');
    await CacheHelper.removeData(key: 'profile_phone');
    await CacheHelper.removeData(key: 'profile_address');
    await CacheHelper.removeData(key: 'profile_image');

    notifyListeners();
  }

  void setUserRole(int role) {
    _userRole = role;
    CacheHelper.saveData(key: _roleKey, value: role);
    notifyListeners();
  }

  void setGender(String gender) {
    _gender = gender;
    CacheHelper.saveData(key: _genderKey, value: gender);
    notifyListeners();
  }

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    CacheHelper.saveData(key: _themeKey, value: isDarkMode ? 'dark' : 'light');
    notifyListeners();
  }

  void toggleLanguage() {
    _locale = _locale.languageCode == 'ar'
        ? const Locale('en')
        : const Locale('ar');
    CacheHelper.saveData(key: _langKey, value: _locale.languageCode);
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    CacheHelper.saveData(
      key: _themeKey,
      value: mode == ThemeMode.dark ? 'dark' : 'light',
    );
    notifyListeners();
  }

  void setLocale(Locale lo) {
    _locale = lo;
    CacheHelper.saveData(key: _langKey, value: lo.languageCode);
    notifyListeners();
  }
}

final appStateManager = AppStateManager();
