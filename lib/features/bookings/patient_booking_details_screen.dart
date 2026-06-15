import 'package:flutter/material.dart';
import '../../core/theme/color_app.dart';
import '../../core/widgets/app_header.dart';
import '../../core/widgets/medical_background_icons.dart';
import '../../core/manager/app_state_manager.dart';
import '../../l10n/app_localizations.dart';

class PatientBookingDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> booking;

  const PatientBookingDetailsScreen({Key? key, required this.booking})
    : super(key: key);

  @override
  State<PatientBookingDetailsScreen> createState() =>
      _PatientBookingDetailsScreenState();
}

class _PatientBookingDetailsScreenState
    extends State<PatientBookingDetailsScreen>
    with SingleTickerProviderStateMixin {
  bool _isRefreshing = false;
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _animController.forward();

    // Refresh bookings from API
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshBookings();
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _refreshBookings() async {
    setState(() => _isRefreshing = true);
    await appStateManager.fetchPatientBookings();
    if (mounted) setState(() => _isRefreshing = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    // Extract booking data
    final hospital = widget.booking['hospitalId'];
    final String hospitalName = hospital is Map ? (hospital['name'] ?? '') : '';
    final service = widget.booking['serviceId'];
    final String serviceName = service is Map ? (service['name'] ?? '') : '';
    final String serviceType = service is Map ? (service['type'] ?? '') : '';
    final String status = widget.booking['status']?.toString() ?? 'pending';
    final String dateStr = widget.booking['createdAt']?.toString() ?? '';

    // Status display
    String statusText = l10n.pendingStatus;
    Color statusColor = Colors.orange;
    IconData statusIcon = Icons.hourglass_empty_rounded;
    if (status == 'confirmed' || status == 'approved') {
      statusText = l10n.confirmedStatus;
      statusColor = Colors.green;
      statusIcon = Icons.check_circle_rounded;
    } else if (status == 'rejected') {
      statusText = l10n.rejectedStatus;
      statusColor = Colors.red;
      statusIcon = Icons.cancel_rounded;
    }

    // Format date
    String displayDate = dateStr;
    try {
      final parsed = DateTime.tryParse(dateStr);
      if (parsed != null) {
        final hour12 = parsed.hour > 12 ? parsed.hour - 12 : parsed.hour;
        final amPm = parsed.hour >= 12 ? 'PM' : 'AM';
        displayDate =
            '$hour12:${parsed.minute.toString().padLeft(2, '0')} $amPm  •  ${parsed.day}/${parsed.month}/${parsed.year}';
      }
    } catch (_) {}

    return Scaffold(
      backgroundColor: isDark ? ColorApp.appDark : ColorApp.appLight,
      body: Stack(
        children: [
          const Positioned.fill(child: MedicalIconsBackground()),
          SafeArea(
            child: Column(
              children: [
                const AppHeader(),
                const SizedBox(height: 10),

                // Title bar with back button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: isDark
                                ? ColorApp.primary.withValues(alpha: 0.2)
                                : ColorApp.buttonDetails,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            isAr
                                ? Icons.arrow_forward_rounded
                                : Icons.arrow_back_rounded,
                            color: isDark ? Colors.white : ColorApp.primary,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        l10n.bookingDetailsTitle,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : ColorApp.primary,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 15),

                // Details card
                Expanded(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 10,
                      ),
                      child: Column(
                        children: [
                          // Main details card
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(24.0),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? ColorApp.icons.withValues(alpha: 0.9)
                                  : Colors.white.withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(20.0),
                              border: Border.all(
                                color: isDark
                                    ? Colors.grey[800]!
                                    : ColorApp.buttonDetails,
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.06),
                                  blurRadius: 15,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Status badge centered
                                Center(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: statusColor.withValues(
                                        alpha: 0.12,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: statusColor.withValues(
                                          alpha: 0.5,
                                        ),
                                        width: 1.2,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          statusIcon,
                                          color: statusColor,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          statusText,
                                          style: TextStyle(
                                            color: statusColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 16),

                                Center(
                                  child: Text(
                                    l10n.detailedRequestData,
                                    style: TextStyle(
                                      color: isDark
                                          ? Colors.white
                                          : ColorApp.locationText,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 16),

                                Divider(
                                  color: isDark
                                      ? Colors.grey[800]
                                      : Colors.grey[200],
                                ),

                                const SizedBox(height: 16),

                                // Hospital Name
                                _buildDetailRow(
                                  l10n.hospitalNameField,
                                  hospitalName.isNotEmpty
                                      ? hospitalName
                                      : l10n.notSpecified,
                                  isDark,
                                  Icons.local_hospital_rounded,
                                ),

                                const SizedBox(height: 16),

                                // Service Type
                                _buildDetailRow(
                                  l10n.serviceTypeField,
                                  serviceName.isNotEmpty
                                      ? serviceName
                                      : (serviceType.isNotEmpty
                                            ? serviceType
                                            : l10n.notSpecified),
                                  isDark,
                                  Icons.medical_services_rounded,
                                ),

                                const SizedBox(height: 16),

                                // Status
                                _buildDetailRow(
                                  l10n.bookingStatusField,
                                  statusText,
                                  isDark,
                                  Icons.info_outline_rounded,
                                  valueColor: statusColor,
                                ),

                                const SizedBox(height: 16),

                                // Date
                                _buildDetailRow(
                                  l10n.bookingDateField,
                                  displayDate.isNotEmpty
                                      ? displayDate
                                      : l10n.notSpecified,
                                  isDark,
                                  Icons.calendar_today_rounded,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Refresh indicator
                          if (_isRefreshing)
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: ColorApp.secondary,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    '...',
                                    style: TextStyle(
                                      color: isDark
                                          ? Colors.white70
                                          : Colors.black54,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value,
    bool isDark,
    IconData icon, {
    Color? valueColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: isDark
                  ? ColorApp.secondary
                  : ColorApp.primary.withValues(alpha: 0.7),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? Colors.grey[400]
                    : ColorApp.primary.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: isDark
                ? ColorApp.primary.withValues(alpha: 0.15)
                : const Color(0xFFF0F4F8),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: valueColor ?? (isDark ? Colors.white : Colors.black87),
            ),
          ),
        ),
      ],
    );
  }
}
