import 'package:flutter/material.dart';
import '../../core/constants/assets_app.dart';
import '../../core/theme/color_app.dart';
import '../../core/widgets/app_header.dart';
import '../../core/widgets/medical_background_icons.dart';
import '../../core/manager/app_state_manager.dart';
import '../../l10n/app_localizations.dart';

class BookingRequestsScreen extends StatefulWidget {
  const BookingRequestsScreen({Key? key}) : super(key: key);

  @override
  State<BookingRequestsScreen> createState() => _BookingRequestsScreenState();
}

class _BookingRequestsScreenState extends State<BookingRequestsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      appStateManager.fetchPatientBookings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? ColorApp.appDark : ColorApp.appLight,
      body: Stack(
        children: [
          // Pattern Background
          const Positioned.fill(child: MedicalIconsBackground()),
          SafeArea(
            child: Column(
              children: [
                const AppHeader(),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        l10n.bookingRequests,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: ColorApp.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Expanded(
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.center,
                          child: Opacity(
                            opacity: 0.15,
                            child: Image.asset(
                              AssetsApp.bgOnboardOpacity,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      ListenableBuilder(
                        listenable: appStateManager,
                        builder: (context, child) {
                          if (appStateManager.isLoadingBookings) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          final bookings = appStateManager.patientBookings;
                          if (bookings.isEmpty) {
                            return Center(
                              child: Text(
                                l10n.noNotifications,
                                style: TextStyle(
                                  color: isDark
                                      ? Colors.white70
                                      : Colors.black54,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          }

                          return ListView.builder(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 10,
                            ),
                            itemCount: bookings.length,
                            itemBuilder: (context, index) {
                              final booking = bookings[index];
                              final hospital = booking['hospitalId'];
                              final String hospitalName = hospital is Map
                                  ? (hospital['name'] ?? '')
                                  : '';
                              final service = booking['serviceId'];
                              final String serviceName = service is Map
                                  ? (service['name'] ?? '')
                                  : '';
                              final String status =
                                  booking['status']?.toString() ?? 'pending';
                              final String dateStr =
                                  booking['createdAt']?.toString() ?? '';

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: _buildBookingCard(
                                  isDark: isDark,
                                  title: hospitalName.isNotEmpty
                                      ? hospitalName
                                      : 'طلب حجز خدمة',
                                  serviceType: serviceName,
                                  status: status,
                                  date: dateStr,
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingCard({
    required bool isDark,
    required String title,
    required String serviceType,
    required String status,
    required String date,
  }) {
    String statusText = 'قيد الانتظار';
    Color statusColor = Colors.orange;
    if (status == 'confirmed' || status == 'approved') {
      statusText = 'تم التأكيد';
      statusColor = Colors.green;
    } else if (status == 'rejected') {
      statusText = 'تم الرفض';
      statusColor = Colors.red;
    }

    // Format date string gracefully if possible
    String displayDate = date;
    try {
      final parsed = DateTime.tryParse(date);
      if (parsed != null) {
        displayDate =
            '${parsed.hour}:${parsed.minute.toString().padLeft(2, '0')} ${parsed.hour >= 12 ? 'PM' : 'AM'} - ${parsed.day}/${parsed.month}/${parsed.year}';
      }
    } catch (_) {}

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: isDark
            ? ColorApp.icons.withValues(alpha: 0.9)
            : Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: isDark
              ? ColorApp.primary.withValues(alpha: 0.3)
              : ColorApp.buttonDetails,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'بيانات الطلب',
                style: TextStyle(
                  color: isDark ? Colors.white70 : ColorApp.locationText,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: statusColor, width: 1),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : ColorApp.icons,
            ),
          ),
          const SizedBox(height: 8),
          if (serviceType.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                'نوع الخدمة: $serviceType',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: isDark ? ColorApp.secondary : ColorApp.primary,
                ),
              ),
            ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.access_time_rounded,
                size: 14,
                color: isDark ? ColorApp.appLight : ColorApp.appDark,
              ),
              const SizedBox(width: 4),
              Text(
                displayDate,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? ColorApp.appLight : ColorApp.appDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
