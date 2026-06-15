import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../core/theme/color_app.dart';
import '../../core/widgets/hospital_header.dart';
import '../../core/manager/app_state_manager.dart';
import '../../l10n/app_localizations.dart';
import '../auth/auth_repository.dart';
import '../../core/cache/cache_helper.dart';

class HospitalHomeScreen extends StatefulWidget {
  static const String routeName = 'HospitalHomeScreen';
  const HospitalHomeScreen({super.key});

  @override
  State<HospitalHomeScreen> createState() => _HospitalHomeScreenState();
}

class _HospitalHomeScreenState extends State<HospitalHomeScreen> {
  DateTime? _selectedDate = DateTime.now();
  String? _customDateLabel;

  bool _isSameDay(String timeStr, DateTime targetDate) {
    try {
      final dt = DateTime.parse(timeStr);
      return dt.year == targetDate.year &&
          dt.month == targetDate.month &&
          dt.day == targetDate.day;
    } catch (_) {
      final months = {
        'jan': 1,
        'feb': 2,
        'mar': 3,
        'apr': 4,
        'may': 5,
        'jun': 6,
        'jul': 7,
        'aug': 8,
        'sep': 9,
        'oct': 10,
        'nov': 11,
        'dec': 12,
      };
      final lower = timeStr.toLowerCase();
      final match = RegExp(r'(\d+)\s+([a-z]{3})\s+(\d{4})').firstMatch(lower);
      if (match != null) {
        final day = int.tryParse(match.group(1) ?? '');
        final monthStr = match.group(2) ?? '';
        final year = int.tryParse(match.group(3) ?? '');
        final month = months[monthStr];
        if (day != null && month != null && year != null) {
          return year == targetDate.year &&
              month == targetDate.month &&
              day == targetDate.day;
        }
      }
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final token = CacheHelper.getData(key: 'token') as String?;
    if (token == null) return;
    if (token == 'mock_hospital_token' || token == 'mock_patient_token') {
      await appStateManager.fetchBookings();
      return;
    }

    // Try to load profile separately - don't let it block hospital data
    String username = '';
    try {
      final profileResult = await authRepository.getUserProfile(token);
      final userData = profileResult['data'] != null
          ? profileResult['data']['account']
          : profileResult['account'];
      if (userData != null) {
        username = userData['firstName'] ?? userData['username'] ?? '';
      }
    } catch (e) {
      debugPrint('Profile fetch failed (non-blocking): $e');
    }

    // Always load hospital data and bookings regardless of profile result
    try {
      await appStateManager.fetchHospitalData(token, username);
      await appStateManager.fetchBookings();
    } catch (e) {
      debugPrint('Error loading hospital data: $e');
    }
  }

  void _showEditDataSheet() {
    final state = appStateManager;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    final TextEditingController nurseriesKidsCtrl = TextEditingController(
      text: state.nurseriesKids.toString(),
    );
    final TextEditingController nurseriesNicuCtrl = TextEditingController(
      text: state.nurseriesNicu.toString(),
    );
    final TextEditingController icuAdultsCtrl = TextEditingController(
      text: state.icuAdults.toString(),
    );
    final TextEditingController icuCcuCtrl = TextEditingController(
      text: state.icuCcu.toString(),
    );
    final TextEditingController icuPicuCtrl = TextEditingController(
      text: state.icuPicu.toString(),
    );
    final TextEditingController totalNurseryCtrl = TextEditingController(
      text: state.totalNurseryBeds.toString(),
    );
    final TextEditingController totalIcuCtrl = TextEditingController(
      text: state.totalIcuBeds.toString(),
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          top: 10, // Reduced top padding from 20 to 10
          left: 20,
          right: 20,
        ),
        decoration: BoxDecoration(
          color: isDark ? ColorApp.icons : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[700] : Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ), // Reduced distance below handle from 20 to 12
              Text(
                l10n.editDataTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : ColorApp.primary,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                l10n.availableNurseriesHeader,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.grey[300] : ColorApp.icons,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _buildEditField(
                      l10n.nurseryKidsLabel,
                      nurseriesKidsCtrl,
                      isDark,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildEditField(
                      l10n.nurseryNicuLabel,
                      nurseriesNicuCtrl,
                      isDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                l10n.availableIcuHeader,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.grey[300] : ColorApp.icons,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _buildEditField(
                      l10n.icuAdultsLabel,
                      icuAdultsCtrl,
                      isDark,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildEditField(
                      l10n.icuCcuLabel,
                      icuCcuCtrl,
                      isDark,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildEditField(
                      l10n.icuPicuLabel,
                      icuPicuCtrl,
                      isDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                l10n.totalBedsHeader,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.grey[300] : ColorApp.icons,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _buildEditField(
                      l10n.totalNurseryBedsLabel,
                      totalNurseryCtrl,
                      isDark,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildEditField(
                      l10n.totalIcuBedsLabel,
                      totalIcuCtrl,
                      isDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  state.updateHospitalBeds(
                    kids:
                        int.tryParse(nurseriesKidsCtrl.text) ??
                        state.nurseriesKids,
                    nicu:
                        int.tryParse(nurseriesNicuCtrl.text) ??
                        state.nurseriesNicu,
                    adults: int.tryParse(icuAdultsCtrl.text) ?? state.icuAdults,
                    ccu: int.tryParse(icuCcuCtrl.text) ?? state.icuCcu,
                    picu: int.tryParse(icuPicuCtrl.text) ?? state.icuPicu,
                    totalNursery:
                        int.tryParse(totalNurseryCtrl.text) ??
                        state.totalNurseryBeds,
                    totalIcu:
                        int.tryParse(totalIcuCtrl.text) ?? state.totalIcuBeds,
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorApp.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  l10n.saveChanges,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditField(
    String label,
    TextEditingController controller,
    bool isDark,
  ) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      style: TextStyle(color: isDark ? Colors.white : Colors.black),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          fontSize: 11,
          color: isDark ? Colors.grey[400] : ColorApp.locationText,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? Colors.grey[700]! : Colors.grey[350]!,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ColorApp.primary),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: isDark ? ColorApp.appDark : ColorApp.appLight,
      extendBody: true,
      body: ListenableBuilder(
        listenable: appStateManager,
        builder: (context, _) {
          final state = appStateManager;
          final isArabic = state.isArabic;
          final String displayLabel = _customDateLabel ?? l10n.todayLabel;

          // Filter requests by the selected date
          final filteredNursery = _selectedDate == null
              ? state.nurseryRequests
              : state.nurseryRequests
                    .where((r) => _isSameDay(r.time, _selectedDate!))
                    .toList();
          final filteredIcu = _selectedDate == null
              ? state.icuRequests
              : state.icuRequests
                    .where((r) => _isSameDay(r.time, _selectedDate!))
                    .toList();

          final int activeNurseryCount = 25 - (3 - filteredNursery.length);
          final int activeIcuCount = 10 - (3 - filteredIcu.length);
          final int activeTotalCount = activeNurseryCount + activeIcuCount;

          return Column(
            children: [
              const HospitalHeader(),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Booking Overview Title & Dropdown
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.bookingOverviewTitle,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : ColorApp.icons,
                            ),
                          ),
                          Material(
                            color: isDark ? ColorApp.icons : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            clipBehavior: Clip.antiAlias,
                            child: PopupMenuButton<String>(
                              clipBehavior: Clip.antiAlias,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              menuPadding: EdgeInsets.zero,
                              onSelected: (value) async {
                                if (value == 'today') {
                                  setState(() {
                                    _selectedDate = DateTime.now();
                                    _customDateLabel = null;
                                  });
                                  await appStateManager.fetchBookings();
                                } else if (value == 'yesterday') {
                                  setState(() {
                                    _selectedDate = DateTime.now().subtract(
                                      const Duration(days: 1),
                                    );
                                    _customDateLabel = l10n.yesterday;
                                  });
                                  await appStateManager.fetchBookings();
                                } else if (value == 'custom') {
                                  final DateTime? picked = await showDatePicker(
                                    context: context,
                                    initialDate:
                                        _selectedDate ?? DateTime.now(),
                                    firstDate: DateTime(2020),
                                    lastDate:
                                        DateTime.now(), // Disable future dates
                                    locale: Locale(isArabic ? 'ar' : 'en'),
                                  );
                                  if (picked != null) {
                                    setState(() {
                                      _selectedDate = picked;
                                      _customDateLabel =
                                          "${picked.year}/${picked.month}/${picked.day}";
                                    });
                                    await appStateManager.fetchBookings();
                                  }
                                }
                              },
                              itemBuilder: (BuildContext context) =>
                                  <PopupMenuEntry<String>>[
                                    PopupMenuItem<String>(
                                      value: 'custom',
                                      child: Text(l10n.chooseDate),
                                    ),
                                    PopupMenuItem<String>(
                                      value: 'yesterday',
                                      child: Text(l10n.yesterday),
                                    ),
                                    PopupMenuItem<String>(
                                      value: 'today',
                                      child: Text(l10n.todayLabel),
                                    ),
                                  ],
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: ColorApp.secondary),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      displayLabel,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(
                                      Icons.keyboard_arrow_down,
                                      size: 16,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),

                      // Three Horizontal Cards Layout in a single row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 1. إجمالي طلبات الحجز (Blue) - Start Card
                          Expanded(
                            child: Container(
                              height: 110,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: ColorApp.primary,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: ColorApp.primary.withValues(
                                      alpha: 0.3,
                                    ),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    l10n.totalBookingRequestsCard,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    activeTotalCount.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text(
                                    "+11.01% ↗",
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 8,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),

                          // 2. الحضانات (Green) - Middle Card
                          Expanded(
                            child: Container(
                              height: 110,
                              padding: const EdgeInsets.only(top: 6, bottom: 4),
                              decoration: BoxDecoration(
                                color: ColorApp.secondary,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: ColorApp.secondary.withValues(
                                      alpha: 0.3,
                                    ),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    l10n.nurseriesCard,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "+11.01% ↗",
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 7,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        activeNurseryCount.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: ColorApp.thairty,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      children: [
                                        _buildSubItemRow(
                                          state.nurseriesKids.toString(),
                                          l10n.kidsSub,
                                        ),
                                        const SizedBox(height: 2),
                                        _buildSubItemRow(
                                          state.nurseriesNicu.toString(),
                                          l10n.nicuSub,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),

                          // 3. العناية المركزة (Light Green) - End Card
                          Expanded(
                            child: Container(
                              height: 110,
                              padding: const EdgeInsets.only(top: 6, bottom: 4),
                              decoration: BoxDecoration(
                                color: ColorApp.secondary,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: ColorApp.secondary.withValues(
                                      alpha: 0.3,
                                    ),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    l10n.icuCard,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "+6.08% ↗",
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 7,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        activeIcuCount.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: ColorApp.thairty,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      children: [
                                        _buildSubItemRow(
                                          state.icuAdults.toString(),
                                          l10n.icuSub,
                                        ),
                                        const SizedBox(height: 1),
                                        _buildSubItemRow(
                                          state.icuCcu.toString(),
                                          l10n.ccuSub,
                                        ),
                                        const SizedBox(height: 1),
                                        _buildSubItemRow(
                                          state.icuPicu.toString(),
                                          l10n.picuSub,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Section 3: الأماكن المتاحة Block (Green Border Outer Box)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark ? ColorApp.icons : Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: ColorApp.secondary, // Green border
                            width: 1.8,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Center Label "الاماكن المتاحة"
                            Center(
                              child: Text(
                                l10n.availablePlacesLabel,
                                style: const TextStyle(
                                  color: ColorApp.secondary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Row with Left and Right Panels
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 1. Start Panel: حضانات الأطفال (border box)
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(18),
                                      border: Border.all(
                                        color: isDark
                                            ? Colors.grey[700]!
                                            : Colors.grey[300]!,
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          l10n.nurseriesCard,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            color: isDark
                                                ? Colors.white
                                                : ColorApp.icons,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        _buildAvailableCapsule(
                                          l10n.nurseryKidsLabel,
                                          state.nurseriesKids,
                                        ),
                                        const SizedBox(height: 6),
                                        _buildAvailableCapsule(
                                          l10n.nurseryNicuLabel,
                                          state.nurseriesNicu,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),

                                // 2. End Panel: عناية مركزة (border box)
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(18),
                                      border: Border.all(
                                        color: isDark
                                            ? Colors.grey[700]!
                                            : Colors.grey[300]!,
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          l10n.icuCard,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            color: isDark
                                                ? Colors.white
                                                : ColorApp.icons,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        _buildAvailableCapsule(
                                          l10n.icuAdultsLabel,
                                          state.icuAdults,
                                        ),
                                        const SizedBox(height: 6),
                                        _buildAvailableCapsule(
                                          l10n.icuCcuLabel,
                                          state.icuCcu,
                                        ),
                                        const SizedBox(height: 6),
                                        _buildAvailableCapsule(
                                          l10n.icuPicuLabel,
                                          state.icuPicu,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Section 4: Total Beds count cards
                      _buildTotalBedCountCard(
                        l10n.nurseriesBedsTotalLabel,
                        state.totalNurseryBeds,
                      ),
                      _buildTotalBedCountCard(
                        l10n.icuBedsTotalLabel,
                        state.totalIcuBeds,
                      ),
                      const SizedBox(height: 15),

                      // Section 5: Edit Data pencil link (centered)
                      Center(
                        child: GestureDetector(
                          onTap: _showEditDataSheet,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Iconsax.edit,
                                size: 16,
                                color: isDark
                                    ? Colors.grey[400]
                                    : Colors.grey[600],
                              ),
                              const SizedBox(width: 6),
                              Text(
                                l10n.editDataButton,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? Colors.white
                                      : ColorApp.appDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSubItemRow(String count, String label) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 8)),
        Text(
          count,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 9,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildAvailableCapsule(String label, int value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? ColorApp.appDark : ColorApp.appLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.grey[700]! : const Color(0xFFCFD8DC),
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              textAlign: TextAlign.start,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isDark ? Colors.white : ColorApp.primary,
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value.toString(),
            style: const TextStyle(
              color: ColorApp.secondary, // Green number
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalBedCountCard(String label, int total) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: ColorApp.locationText.withValues(alpha: .15),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark ? Colors.grey[700]! : const Color(0xFFB0BEC5),
          width: 1.2,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : ColorApp.primary,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              color: isDark ? ColorApp.appDark : ColorApp.appLight,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? Colors.grey[700]! : const Color(0xFFB0BEC5),
              ),
            ),
            child: Text(
              total.toString(),
              style: TextStyle(
                color: isDark ? Colors.white : ColorApp.primary,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
